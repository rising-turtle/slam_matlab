% FACES_DRIVER
% CFG.INIT_WC

clear rs ;

% --------------------------------------------------------------------
%                                                            Load data
% --------------------------------------------------------------------

fprintf('faces_driver: checking data ... ') ;
global data ;
if isempty(data)
  fprintf('loading ... ') ;
	data=load('data/vjf_tangent') ;
  data.dx_scale = 1 ;
	data.dims = [24 24] ;
end
fprintf('done\n') ;

% --------------------------------------------------------------------
%                                  Select which experiments to perform
% --------------------------------------------------------------------

ex_range = 1:length(ex) ;

% for parallel execution on a cluster
if exist('ex_cluster_job_id','var')
  ex_range = ex_cluster_job_id ;
  [ex_path,ex_name,ex_ext] = fileparts(ex_results_path) ;
  ex_suffix = sprintf('%05d', ex_cluster_job_id) ;
  ex_results_path = ...
      fullfile(ex_path, ...
               sprintf('%s-%s%s', ex_name, ex_suffix, ex_ext)) ;
  clear ex_path ex_name ex_suffix ex_ext ;
end

fprintf('faces_driver: saving to: %s\n', ex_results_path) ;

% --------------------------------------------------------------------
%                                                      Run experiments
% --------------------------------------------------------------------

for ex_number = ex_range
	randn('state',ex{ex_number}.random_seed) ;
	rand( 'state',ex{ex_number}.random_seed) ;
	
  for fold_number = 1:ex{ex_number}.nfolds
		e = find(ex_number == ex_range) ;
		
    fprintf('faces_driver: ** experiment %4d/%d, fold %4d/%d **\n', ...
            ex_number,length(ex), ...
            fold_number,ex{ex_number}.nfolds) ;
		
		if (e > length(ex)),
			fprintf('** experiment out of range; skipping\n')
		end
		
    % basic configuration
		cfg.nwc                = 100 ;
    cfg.sigma              = 0.01 ;
    cfg.use_tg             = 0 ;
    cfg.gd_max_niters      = 50 ;
    cfg.gd_restart_niters  = 50 ;
    cfg.gd_method          = 'hs' ;
    cfg.haar_n             = 0 ;
    cfg.verbosity          = 2 ;
    
    % overwrite with experiment parameters
    cfg = override(cfg, ex{ex_number}.cfg, 1) ;
    
    % select testing and training data
    N    = ex{ex_number}.N ;
    selp = find(data.y == +1) ;
    selm = find(data.y == -1) ;
    selp = selp(randperm(length(selp))) ;
    selm = selm(randperm(length(selm))) ;       
    data.is_train = zeros(1,size(data.x,2)) ;
    data.is_train([selp(1:N) selm(1:N)]) = 1 ;
    
    % rescale tangent space		
		new_scale = ex{ex_number}.tg_scale ;
		fprintf('faces_driver: tangent vectors scale = %g\n',new_scale) ;
    try
      delta = new_scale / data.dx_scale ;    
      for d = 1:length(data.dx)
        data.dx{d} =  delta * data.dx{d} ;
        fprintf('faces_driver: scaling tangent vectors %d/%d to %g (delta %g)\n',...
                d,length(data.dx),new_scale,delta) ;
      end
      data.dx_scale = new_scale ;
    catch
      % make sure data stays consistent in case of error!
      clear delta ;
    end
    
    % get initial weak classifiers
		ex{ex_number}
    L = size(data.x, 1) ;
		nwc0 = ex{ex_number}.nwc;
    data.F0 = std(data.x(:,1)) * randn(L + 1, nwc0) ;
%		sr = linspace(ex{ex_number}.init_wc_s0,...
%   ex{ex_number}.init_wc_s1,nwc0) ;
 		sr = linspace(3.4, 4.4, nwc0) ;
		
    for t = 1:nwc0
      tmp = imsmooth(randn(24,24), sr(t)) ;
      data.F0(2:end, t) = tmp(:) ;
    end
		
		figure(1000) ; clf ;
		imarraysc(reshape(data.F0(2:end,:),sqrt(L),sqrt(L),[])) ; colormap gray;
    
    % run algorithm    
    rs{e, fold_number} = vicinalboost(cfg, data) ;
    
    % add this information to make it simpler to plot
    rs{e, fold_number}.sigma      = cfg.sigma ;
    rs{e, fold_number}.ntrain     = N ;
		rs{e, fold_number}.nhaar      = cfg.haar_n ;
    rs{e, fold_number}.use_haar   = cfg.haar_n > 0 ;
		rs{e, fold_number}.gd_niters  = cfg.gd_max_niters ;
    rs{e, fold_number}.use_gd     = cfg.gd_max_niters > 0 ;
    rs{e, fold_number}.use_tg     = cfg.use_tg ;
		rs{e, fold_number}.gd_method  = cfg.gd_method ;
		rs{e, fold_number}.tg_scale   = ex{ex_number}.tg_scale ;
%		rs{e, fold_number}.init_wc_s0 = ex{ex_number}.init_wc_s0 ;
%		rs{e, fold_number}.init_wc_s1 = ex{ex_number}.init_wc_s1 ;
		
    % backup+save    
    backup(ex_results_path) ;
    save(ex_results_path, 'ex', 'rs', 'ex_range') ;
  end
end
