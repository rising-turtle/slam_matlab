function rs = vicinalboost(cfg, data)
% VICINALBOOST
%
%  RS = VICINALBOOST(CFG, DATA)
%
%  DATA is a structure with the following fields:
%
%  DATA.Y             Training data labels
%  DATA.X             Training data samples
%  DATA.DX            Data tangent vectors (scaled)
%  DATA.IS_TRAIN      Mark training / testing data
%  DATA.F0            Collection of initial WCs
%  DATA.DIMS          Dimensions of the data (for visualization)
%
%
%  CFG is a structure with the following fields:
%
%  CFG.NWC             Number of weak classifier of the final model
%  CFG.SIGMA           Isotropic Parzen window smoothing
%  CFG.USE_TG          Use or not the tangent space
%  CFG.GD_MAX_NITERS   # of GD iterations (set to 0 to de-activate)
%  CFG.GD_RESTART_NITERS  
%                      # of GD iterations before restart
%  CFG.GD_METHOD       CGD method: 'NONE', 'FR, 'PR', 'HS'.
%  CFG.HAAR_N           # of HAAR wavelets (set t0 0 to de-activate)
%  CFG.VERBOSITY        0 - quiet, 1 - text, 2 - main figs, 3 - all
%
%  RS is a structure with the following fields:
%
%  RS.F               Weak classifiers parameters
%  RS.COEFF           Coefficients
%  RS.EE              Exp. criterion as each WC is added
%  RS.E01             Train error as each WC is added
%  RS.E01T            Test error as each WC is added

% AUTORIGHTS
% Copyright 2007 (c) Andrea Vedaldi and Paolo Favaro
% 
% This file is part of VicinalBoost, available in the terms of the GNU
% General Public License version 2.

% --------------------------------------------------------------------
%                                                                Setup
% --------------------------------------------------------------------

% sel  = select training data
% selt = select testing data

sel  = find( data.is_train) ;
selt = find(~data.is_train) ;

% this is not really necessary:

sel  = sel(randperm(length(sel))) ;
selt = selt(randperm(length(selt))) ;

% y   = training data labels
% yt  = testing data labels
% x   = training data
% xt  = testing data

y   = data.y(   sel ) ;
yt  = data.y(   selt) ;
x   = data.x(:, sel ) ;
xt  = data.x(:, selt) ;

% L   = data dimensionality
% N   = # of training data
% Nt  = # of testing data
% Np  = # of positive training data 
% Nm  = # of negative training data 
% Npt = # of positive testing data 
% Nmt = # of negative testing data 

L   = size(data.x, 1) ;
N   = length(sel ) ;
Nt  = length(selt) ;
Np  = sum(y  == +1) ;
Npt = sum(yt == +1) ;
Nm  = N  - Np ;
Nmt = Nt - Npt ;

% wgt   = AdaBoost coefficients or weights
% ywgt  = weights .* y
% F     = weak classifiers selected so far
% H     = strong classifier H evaluated on train
% Ht    = strong classifier H evaluated on test

wgt   = ones(1,N) / N ;
ywgt  = y .* wgt ;
F     = zeros(L + 1, cfg.nwc) ;
coeff = zeros(1, cfg.nwc) ;
H     = zeros(1, N ) ;
Ht    = zeros(1, Nt) ;

movie_nf = 1 ;
movie_do = 0 ;

% e01   = 01 loss of strong class on train
% e01t  = 01 loss of strong class on test
% ee    = exp loss of strong class on train

rs.e01  = zeros(1, cfg.nwc) ;
rs.e01t = zeros(1, cfg.nwc) ;
rs.ee   = zeros(1, cfg.nwc) ;

% weights used to rebalance the test set to correspond to the train
% set when computing the test error

adj_test = zeros(length(yt),1) ;
adj_test(yt == +1) = (Nt / Npt) * (Np / N) ;
adj_test(yt == -1) = (Nt / Nmt) * (Nm / N) ; 

if cfg.verbosity > 0
  fprintf('vicinalboost: sigma             = %g\n', cfg.sigma) ;
  fprintf('vicinalboost: use_tg            = %g\n', cfg.use_tg) ;  
  fprintf('vicinalboost: gd_max_niters     = %d\n', cfg.gd_max_niters) ;
  fprintf('vicinalboost: gd_restart_niters = %d\n', cfg.gd_restart_niters) ;
  fprintf('vicinalboost: gd_method         = %s\n', cfg.gd_method) ;  
  fprintf('vicinalboost: haar_n            = %d\n', cfg.haar_n) ;
  fprintf('vicinalboost: train data: %d (%d pos, %d neg)\n', N,  Np,  Nm ) ; 
  fprintf('vicinalboost: test  data: %d (%d pos, %d neg)\n', Nt, Npt, Nmt) ; 
  fprintf('vicinalboost: init WCs: %d\n', size(data.F0,2)) ;
end

% --------------------------------------------------------------------
%                                                     Parzen smoothing
% --------------------------------------------------------------------
% Prepare co-variance matrices of Parzen's kernels.

% sigma = isotropic Parzen's window variance
sigma = cfg.sigma ;

if cfg.use_tg == 0
  % for isotropic noise S is a scalar
  S   = sigma * ones(1, N ) ;
  St  = sigma * ones(1, Nt) ;
  
  if cfg.verbosity
    fprintf('vicinalboost: using isotropic Parzen window\n') ;
  end  
  
else
  % for anisotropic noise S is a scalar plus a vector for each
  % tangent space dimensions.
  P = length(data.dx) ;
  S   = sigma * ones(P*L+1, N ) ;
  St  = sigma * ones(P*L+1, Nt) ;
  for p=1:P
    S( 1 + (p-1) * L + (1:L), :) = data.dx{p}(:, sel ) ;
    St(1 + (p-1) * L + (1:L), :) = data.dx{p}(:, selt) ;
  end
  
  if cfg.verbosity
    fprintf('vicinalboost: using anisotropic Parzen window with %d directions\n', P) ;
  end
end

% --------------------------------------------------------------------
%                                                       Pre-processing
% --------------------------------------------------------------------
% For each initial WC h in data.F0 compute
%  ha = - <gamma1,x_i>
%  hb = sqrt(2 gamma1'S(x_i)gamma1)

if cfg.verbosity 
  fprintf('vicinalboost: pre-processing initial WCs ...       ') ;
end

K = size(data.F0, 2) ;

ha = zeros(K, N) ;
hb = zeros(K, N) ;

for k = 1:K
  gamma1  = data.F0(2:end,k) ;
  ha(k,:) = - gamma1' * x ;
  hb(k,:) = sqrt( 2 * multvar(S,gamma1) )  ;
  
  if cfg.verbosity
    fprintf('\b\b\b\b\b\b\b [%4i]',k) ;
  end
end

if cfg.verbosity
  fprintf(' done.\n') ;
end

if 0
  figure(1) ; clf ; colormap gray ;
  imarraysc(reshape(data.F0(2:end,:),24,24,WC)) ;
end

% --------------------------------------------------------------------
%                                                                Boost
% --------------------------------------------------------------------
force_stop = 0 ;
for t = 1:cfg.nwc
          
  % ------------------------------------------------------------------
  %                                             Select best initial WC
  % ------------------------------------------------------------------  
  % Compute optimal threshold and optimal correlation of each WC
  
  K      = size(data.F0, 2) ;
  E      = zeros(1, K) ;
  gamma0 = zeros(1, K) ;
  nu     = sqrt(2/pi) ;
  for k = 1:K
    a = ha(k,:) ;
    b = hb(k,:) ;
    
    ywgtp = [  +ywgt  -ywgt ] ;
    ap    = [ a-b*nu a+b*nu ] ;
    bp    = [   b*nu   b*nu ] ;
    
    % divide
    ywgtp = ywgtp ./ bp ;
    
    % sort
    [ap,perm] = sort(ap) ;
    ywgtp     = ywgtp(perm) ;
    
    % energy for all threhsolds
    Ep = - ap .* cumsum(ywgtp) + cumsum(ap .* ywgtp) ;
    
    % sanity check
    if 0
      figure(212) ; clf ; hold on ;
      plot(ap,Ep) ;
      Epp = [] ;
      for t=ap
        param = [t;h_set(2:end,k)] ;
        Epp  = [Epp -sum(ywgt.*weak_erf(param,x,S)) ] ;
      end
      plot(ap,Epp,'r') ;
      drawnow;
    end
    
    % select best threshold
    [Ep,best] = min(Ep) ;
    
    % this is the fit for the WC number k. Save back.
    E(k)      = - Ep ;
    gamma0(k) = ap(best) ;
  end
  
  % Select best WC
  [drop,best] = max(E) ;
	
  % take the parameters of the WC and the optimal threshold
  param  = [gamma0(best) ; data.F0(2:end,best)] ;
  h_cur  = weak_erf(param,x,S) ;
  E      = E(best) ;
  
  % ------------------------------------------------------------------
  %                                                        Optimize WC
  % ------------------------------------------------------------------
  % Optimize orientation and treshold by gradient descent
  
  % extract parameters
  gamma0 = param(1) ;
  gamma1 = param(2:end) ;
  
  % for non-linear conjugate gradient descent
  conj  = [] ;
    
  for gd_iter = 1:cfg.gd_max_niters
        
    [gSg,Sg] = multvar(S,gamma1) ;
    gSg      = 2 * gSg ;
    sgSg     = sqrt(gSg) ;
    
    num      = gamma0 + gamma1' * x ;
    wdrf     = ywgt .* derf( num ./ sgSg ) ;
    
    tmp1     = wdrf ./ sgSg ;
    tmp2     = 2 * tmp1 .* num  ./  gSg ;
    dgamma0  = sum(tmp1) ;
    dgamma1  = x * tmp1' - Sg * tmp2' ;
    
    % Non-linear conjugate gradient adjustment.
    %
    % See:
    %
    % http://www.ipp.mpg.de/de/for/bereiche/stellarator/ ...
    %   Comp_sci/CompScience/csep/csep1.phy.ornl.gov/mo/node20.html
    
    if mod(gd_iter - 1, cfg.gd_restart_niters) == 0
      % restart conjugate direction after n iterations
      grad = [dgamma0 ; dgamma1] ;
      conj = grad ;
    else
      % calculate conjugate direction
      grad_ = grad ;
      conj_ = conj ;
      grad  = [dgamma0 ; dgamma1] ;
      switch cfg.gd_method
        case 'none'
          beta = 0 ;
        case 'fr'
          beta = (grad'*grad) / (grad_'*grad_) ;
        case 'pr'
          beta = (grad'*(grad-grad_)) / (grad_'*grad_) ;
        case 'hs'
          beta = (grad'*(grad-grad_)) / (conj_'*(grad-grad_)) ;
      end
      % rarely it might procude NaNs... in this case give up
      if isnan(beta), beta = 0 ; end
      conj  = grad + beta*conj_ ;
      dgamma0 = conj(1) ;
      dgamma1 = conj(2:end) ;
    end
    
    % Now the direction is decided by the gradient; do
    % a Newton step along that direction!
    %
    %
    % MAPLE says:
    %                                          a + l b
    %                         f := l -> ----------------------
    %                                                       2
    %                                   sqrt(c + 2 r l + d l )
    %
    %                         b                 (a + l b) (2 r + 2 d l)
    %               --------------------- - 1/2 -----------------------
    %                               2 1/2                        2 3/2
    %               (c + 2 r l + d l )           (c + 2 r l + d l )
    %
    %                                                       2
    %       b (2 r + 2 d l)          (a + l b) (2 r + 2 d l)         (a + l b) d
    %  - --------------------- + 3/4 ------------------------ - ---------------------
    %                    2 3/2                        2 5/2                     2 3/2
    %    (c + 2 r l + d l )           (c + 2 r l + d l )        (c + 2 r l + d l )
    
    step = 0 ;
    
    a =  gamma0 +   gamma1' * x ;
    b = dgamma0 +  dgamma1' * x ;
    c = gSg / 2  ;
    d = multvar(S,dgamma1) ;
    r = multvar(S,gamma1,dgamma1) ;

    den   = c + 2*r* step + d* step^2 ;
    dens  = sqrt(den) ;
    den3s = den .* dens ;
    den5s = den .* den3s ;
    tmp1  = a + b * step ;
    tmp2  = 2 * (r + d * step) ;
    tmp3  = tmp1 ./ dens ;
    
    drf  =  ywgt .*  derf(tmp3 / sqrt(2)) / sqrt(2) ;
    ddrf =  ywgt .* dderf(tmp3 / sqrt(2)) / 2 ;
    
    tmp4  = b ./ dens - .5 * tmp1.*tmp2./den3s ;
    tmp5  = - b.*tmp2./den3s ...
            + 3/4 * tmp1.* tmp2.*tmp2./den5s ...
            - tmp1.*d./den3s ;
    
    dstep   = sum( drf .* tmp4) ;
    ddstep  = sum(ddrf .* tmp4.*tmp4 + drf .* tmp5);
    
    if abs(ddstep) < 1e-10
      ddstep = 1e-10 ;
    end
    
    stepsz  = - dstep / ddstep ;
    
    % We adjust stepsz for cases in which the Hessian is really bad
    % (stepsz < 0) and we also enlarge a little bit the aperture.
    
    stepsz  = abs(stepsz) * 1.5  ;
    
    % Line search
    stepr = linspace(0,stepsz,15) ;
    for i = 1:length(stepr)
      step  = stepr(i) ;
      
      den   = c + 2*r* step + d* step^2 ;
      dens  = sqrt(den) ;
      den3s = den .* dens ;
      den5s = den .* den3s ;
      tmp1  = a + b * step ;
      tmp2  = 2 * (r + d * step) ;
      tmp3  = tmp1 ./ dens ;
      
      rf   =  ywgt .*   erf(tmp3 / sqrt(2)) ;
      E_ls(i) = sum(rf) ;
    end
    
    [E_,best] = max(E_ls) ;
    step = stepr(best) ;
    
    % do step, finally
    gamma1_  = gamma1 + step * dgamma1 ;
    gamma0_  = gamma0 + step * dgamma0 ;
    param_   = [gamma0_;gamma1_] ;
    h_cur_   = weak_erf(param_,x,S) ;
    
    % save pack for next iteration
    E         = E_ ;
    gamma1    = gamma1_ ;
    gamma0    = gamma0_ ;
    param     = param_ ;
    h_cur     = h_cur_ ;
    
    % save history
    E_gd(gd_iter) = E ;
    if gd_iter > 1 && ...
        (E_gd(gd_iter) - E_gd(gd_iter-1))/E_gd(gd_iter-1) < 1e-5
      break ;
    end
    
    if cfg.verbosity >=3
      figure(1000) ; clf ;
      set(gcf,'color','w') ;
      axes('position',[.08 .08 .36 .36]) ;
      plot(E_gd(1:gd_iter),'linewidth',2) ;
      title('Weak classifier fit') ;
      ylabel('fit') ;
      xlabel('iteration') ;
      subplot(2,2,1) ;
			if length(data.dims == 2)
				imagesc(reshape(gamma1,data.dims))
				axis equal ; axis off ;
			else
				plot(gamma1(:)) ;
			end
			title('Weak classifier') ;
      subplot(2,2,2) ;
			if length(data.dims == 2)
				imagesc(reshape(dgamma1,data.dims)) ;
				axis equal ; axis off ;
			else
				plot(dgamma1(:)) ;
			end
      title('Weak classifier gradient') ;;
      axes('position',[.58 .08 .36 .36]) ;
      plot(stepr,E_ls,'linewidth',2) ;
      title('Line search') ;
      ylabel('fit') ;
      xlabel('step size') ;
      drawnow ;
      
      spn = linspace(0,1,256) ;
      colormap(gray(256)) ;
      
      if movie_do
        MOV(nf) = getframe(1000) ;
        nf=nf+1 ;
      end
    end    		
  end % next GD iteration
  
  
  if cfg.haar_n > 0
    
    % approximate WC with Haar wavelets
		sz = data.dims ;
		
		if (length(sz) ~= 2), 
			error('Haar projection is supported only for 2D data');
		end
		
    gamma_haar = image2dyadic(gamma1,sz);
    gamma_haar = haarfilter(gamma_haar,sz,...
														floor(log2(min(sz))),...
														cfg.haar_n) ;
    gamma_haar = dyadic2image(gamma_haar,sz);
    gamma1_    = gamma_haar(:);
    param_     = [gamma0;gamma1_] ;
    h_cur_     = weak_erf(param_,x,S) ;
    
    % save pack for next iteration
    gamma1    = gamma1_ ;
    param     = param_ ;
    h_cur     = h_cur_ ;
    
    % re-calculate correlation
    E = sum(ywgt .* h_cur) ;
  end
  
  % ------------------------------------------------------------------
  %                                          Calculate mixing constant
  % ------------------------------------------------------------------
  
  % E at this point must contain correlation of current learner to
  % boosting gradient and SZ its size
  c = 0 ;
  
  wgt_ = wgt ;
  
  if all(y .* h_cur > 0)
    force_stop = 1 ;
    if t == 1 
      c = 1 ;
    else
      c = coeff(t - 1) ;
    end
  end
  
  while ~ force_stop
    % re-calculate weak classifier size
    SZ = sum(wgt .* h_cur .* h_cur) ;
    
    % Gauss-Newton step
    dc = E / SZ ;
    c  = c + dc ;
		
    % update weights
    wgt  = wgt_ .* exp( - c .* y .* h_cur) ;
    Z    = sum(wgt) ;
    wgt  = wgt / Z ;
    ywgt = y .* wgt ;
    
    if dc / (c+1e-3) < 1e-8
      break
    end
    
    % re-calculate correlation
    E   = sum(ywgt .* h_cur) ;
  end
	  
  % ------------------------------------------------------------------
  %                                         Record new weak classifier
  % ------------------------------------------------------------------
  F(:,t)   = param ;
  coeff(t) = c ;
  
  % ------------------------------------------------------------------
  %                                                             Update
  % ------------------------------------------------------------------
  
  % train
  H  = H + coeff(t) * h_cur ;
  
  % test
  ht = weak_erf(F(:,t), xt, St) ;
  Ht = Ht + coeff(t) * ht ;
    
  % ------------------------------------------------------------------
  %                                                           Energies
  % ------------------------------------------------------------------
  
  rs.ee(t)    = mean(exp(- y .* H)) ;
  rs.e01(t)   = mean((1 - y  .* sign(H) ) / 2) ;
  rs.e01t(t)  = mean((1 - yt .* sign(Ht)) / 2 .* adj_test') ;
    
  if force_stop
    break ; 
  end
  
  % ------------------------------------------------------------------
  %                                                              Plots
  % ------------------------------------------------------------------
  
%  if(mod(t - 1, 10)~=0 && t ~= cfg.nwc) continue ; end
  
  %fprintf('ada: weak learner %d added\n',t) ;
  fprintf('vicinalboost: nwc:%4i train:%5.2f%% test:%5.2f%% exp:%5.2f%%\n',...
          t,...
          rs.e01(t)  * 100, ...
          rs.e01t(t) * 100, ...
          rs.ee(t)   * 100) ;
  
  if cfg.verbosity >= 2
    figure(100) ; clf ;
    hold on ;
    plot(rs.ee(1:t)   * 100,  'r-',  'LineWidth',2) ;
    plot(rs.e01(1:t)  * 100,  'b-',  'LineWidth',2) ;
    plot(rs.e01t(1:t) * 100,  'g-',  'LineWidth',2) ;
    ylim([0 110]) ; ylabel('%') ;
    xlabel('num. WCs') ;
    legend('exp. bound','train err.','tes err.') ;
    title('Energies') ;
  end
  
  drawnow ;
  
  if movie_do
    MOV(nf) = getframe(gcf) ;
    nf=nf + 1 ;
  end
end

rs.ee(t+1:end)    = rs.ee(t) ;
rs.e01(t+1:end)   = rs.e01(t) ;
rs.e01t(t+1:end)  = rs.e01t(t) ;
rs.cfg            = cfg ;
rs.F              = F ;
rs.coeff          = coeff ;

% --------------------------------------------------------------------
function y = weak(h,X)
% --------------------------------------------------------------------
% Calculate weak lerner.

c = cos(h(1)) ;
s = sin(h(1)) ;
y = sign([c s]*X-h(2)) ;

% --------------------------------------------------------------------
function y = weak_erf(h,X,S)
% --------------------------------------------------------------------
% Calculate smooth weak learner.
% Each column of S is either a scalar or a stacked varaince matrix.

L = size(X,1) ;
N = size(X,2) ;

fast_erf = @erf ;

num = h(2:end)' * X + h(1) ;
den = sqrt( 2 * multvar(S,h(2:end)) )  ;
y   = fast_erf( num ./ den ) ;

% --------------------------------------------------------------------
function y = derf(x)
% --------------------------------------------------------------------
% erf derivative

y = 2/sqrt(pi) * exp(-x.*x) ;

% --------------------------------------------------------------------
function y = dderf(x)
% --------------------------------------------------------------------
% erf second derivative

y = - 4/sqrt(pi) * x .* exp(-x.*x) ;
