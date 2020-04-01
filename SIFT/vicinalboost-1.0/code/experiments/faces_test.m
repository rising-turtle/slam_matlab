% FACES_BASIC
%
% Repeat for : PARZEN, TANGENT, TANGENT+GRADIENT
% Repeat for : SIGMA, N

randn('state',0 );
rand('state',0 );

clear ex ;

Nr           = [2000] ;
nfolds       = 3 ;
sigmar       = [0.4] ;
tg_scale_r   = 8 ;
gd_niters_r  = 100 ;
init_wc_s0_r = 3.4 ; 
init_wc_s1_r = 4.4 ;

verb   = 2 ; 
e      = 1 ;
ex_results_path  = 'results/faces_test.mat' ;

for init_wc_s1 = init_wc_s1_r
	for init_wc_s0 = init_wc_s0_r
		for gd_niters = gd_niters_r
			for tg_scale = tg_scale_r
				for N = Nr
					for sigma = sigmar
						for folds = 1:nfolds(find(N == Nr))
							ex{e}.N                 = N ;
							ex{e}.random_seed       = folds ;
							ex{e}.nfolds            = 1 ;
							ex{e}.nwc               = 800 ;					
							ex{e}.tg_scale          = tg_scale ;
							ex{e}.init_wc_s0        = init_wc_s0;
							ex{e}.init_wc_s1        = init_wc_s1;
							ex{e}.cfg.gd_max_niters = gd_niters ;
							ex{e}.cfg.use_tg        = 1 ;
							ex{e}.cfg.sigma         = sigma ;
							ex{e}.cfg.verbosity     = verb ;    						
							ex{e}.cfg.gd_method     = 'none' ;
							e = e + 1 ;
							
							ex{e} = ex{e-1} ;
							ex{e}.cfg.gd_method     = 'fr' ;
							e = e + 1 ;
							
							ex{e} = ex{e-1} ;
							ex{e}.cfg.gd_method     = 'pr' ;
							e = e + 1 ;
							
							ex{e} = ex{e-1} ;
							ex{e}.cfg.gd_method     = 'hs' ;
							e = e + 1 ;
						end
					end
				end
			end
		end
	end
end

faces_driver ;
