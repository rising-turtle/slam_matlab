function tangent_shapes
% TANGENT_FACES  Compute tangent space of faces

% Load Shapes data
if exist('x') ~= 1
  fprintf('Loading data\n') ;
	load('data/shapes') ;

  % sphericize data
  mf = mean(x,1);
  sf = std(x,0,1);
  sf = sf+1*(sf==0);
  x = (x - ones(size(x,1),1) * mf ) ./ (ones(size(x,1),1) * sf) ;
	global x ;
end

% This is the deviation of the parameters. They are scaled so that a
% unitary parameter will move any pixel of the patch of at most 1
% pixel. The contrast is scaled in term of unit intensity.

dsigma(1) = 1 ;   % std dev of translation along x
dsigma(2) = 1 ;   % std dev of translation along y
dsigma(3) = 1 ;   % std dev of rotation around center
dsigma(4) = 1 ;   % std dev of scaling
dsigma(5) = .1;%0.1 ; % std dev of contrast

% mesh and other numbers
sz      = [24 24] ;
N       = size(x,2) ;
ur      = 1:24 ;
vr      = 1:24;
[u,v]   = meshgrid(ur,vr) ;

% To compute the numerical derivatives for translation we simply use
% one pixel motion, but for rotation and scaling all pixels have different
% amount of motion. This parameter is the amount of motion of the
% pixels farther away from the patch center.

dpix_scale = 1 ;
dpix_rot   = 1.5

% --------------------------------------------------------------------
%                                                             Contrast
% --------------------------------------------------------------------
dx{5} = zeros(size(x)) ;
for i=1:N
  P  = reshape(x(:,i),sz) ;
  dx{5}(:,i) = dsigma(5) * P(:) ;
    
  if mod(i,1000)==0
    fprintf('preproc: contrast: %6d of %6d (%.3f %%).\n', i,N,i/N*100) ;
  end
end

% --------------------------------------------------------------------
%                                                              Scaling
% --------------------------------------------------------------------

% Scale so that the motion of periferical pixel is of at most of
% one pixel for unitary scaling

% patch center
T       = (sz'+1) /2 ;

% patch `radius'
r       = sz(1) / 2 ;

% max scaling
dsc     = dpix_scale / r ;

% warp coordinate (scale up)
Sp      = eye(2)*(1+dsc) ;
Tp      = T - inv(Sp)*T ;
[up,vp] = waffine(inv(Sp),Tp,u,v) ;

% warp coordinate (scale down)
Sm      = eye(2)*(1-dsc) ;
Tm      = T - inv(Sm)*T ;
[um,vm] = waffine(inv(Sm),Tm,u,v) ;

dx{4} = zeros(size(x)) ;
for i=1:N
  P  = reshape(x(:,i),sz) ;
  Pm = imwbackward(ur,vr,P,um,vm) ; 
  Pp = imwbackward(ur,vr,P,up,vp) ; 

  % fill holes
  selm = find(isnan(Pm)) ; Pm(selm) = P(selm) ;
  selp = find(isnan(Pp)) ; Pm(selp) = P(selp) ;
  
  T  =  (Pp-Pm)/2/dpix_scale ;
  
  dx{4}(:,i) = dsigma(4)*T(:) ;

  if 0
    figure(100) ;
    subplot(2,2,1);imagesc(P) ;
    subplot(2,2,2);imagesc(Pp) ;
    subplot(2,2,3);imagesc(Pm) ;
    subplot(2,2,4);imagesc(T) ;
    drawnow ;
    keyboard 
  end
  
  if mod(i,1000)==0
    fprintf('preproc: scal: %6d of %6d (%.3f %%).\n', i,N,i/N*100) ;
  end
end

% --------------------------------------------------------------------
%                                                             Rotation
% --------------------------------------------------------------------

% See comments for scaling above

T       = (sz'+1)/2 ;
r       = sz(1)/2 ;
dth     = dpix_rot/r ;
Rp      = [cos(dth),  -sin(dth) ; sin(dth), cos(dth)] ;
Tp      = T - Rp*T ;
[up,vp] = waffine(Rp,Tp,u,v) ;
Rm      = [cos(-dth),  -sin(-dth) ; sin(-dth), cos(-dth)] ;
Tm      = T - Rm*T ;
[um,vm] = waffine(Rm,Tm,u,v) ;

dx{3} = zeros(size(x)) ;
for i=1:N
  P  = reshape(x(:,i),sz) ;
  Pp = imwbackward(ur,vr,P,up,vp) ;
  Pm = imwbackward(ur,vr,P,um,vm) ; 

  % fill holes
  selp = find(isnan(Pp)) ; Pp(selp) = P(selp) ;
  selm = find(isnan(Pm)) ; Pm(selm) = P(selm) ;
  
  T  = (Pp-Pm)/2/dpix_rot ;
  
  dx{3}(:,i) = dsigma(3)*T(:) ;

  if 0
    figure(100) ;
    subplot(2,2,1);imagesc(P) ;
    subplot(2,2,2);imagesc(Pp) ;
    subplot(2,2,3);imagesc(Pm) ;
    subplot(2,2,4);imagesc(T) ;
    drawnow ;
    keyboard 
  end
    
  if mod(i,1000)==0
    fprintf('preproc: rot: %6d of %6d (%.3f %%).\n', i,N,i/N*100) ;
  end
end

% --------------------------------------------------------------------
%                                                          Translation
% --------------------------------------------------------------------
dx{1} = zeros(size(x)) ;
for i=1:N
  P  = reshape(x(:,i),sz) ;
  Pp = [P(:,1) P(:,1:end-1)] ;
  Pm = [P(:,2:end) P(:,end)] ;
  T  = (Pp-Pm)/2 ;
  
  dx{1}(:,i) = dsigma(1) * T(:) ;
    
  if mod(i,1000)==0
    fprintf('preproc: tx: %6d of %6d (%.3f %%).\n', i,N,i/N*100) ;
  end
end

dx{2} = zeros(size(x)) ;
for i=1:N
  P  = reshape(x(:,i),sz) ;
  Pp = [P(2:end,:);P(end,:)] ;
  Pm = [P(1,:);P(1:end-1,:)] ;
  T  = (Pp-Pm)/2 ;
  
  dx{2}(:,i) = dsigma(2)*T(:) ;
  
  if mod(i,1000)==0
    fprintf('preproc: ty: %6d of %6d (%.3f %%).\n', i,N,i/N*100) ;
  end
end

% --------------------------------------------------------------------
%                                                               Finish
% --------------------------------------------------------------------
fprintf('preproc: saving back\n') ;
save('data/shapes_tangent', 'x', 'y', 'dx') ;
