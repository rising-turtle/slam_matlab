% SHAPES_HAAR
%
% Repeat for N, HAAR_N

clear ex ;

check_wavelab ;

Nr     = [20 40 100] ;
nfolds = [20 16 6  ] ;
sigma  = [0.3] ;
haarnr = 5 + [0 10 20 30 40] ;
verb   = 1 ; 
e      = 1 ;

ex_results_path  = 'results/shapes_haar.mat' ;

for N = Nr
	for haar_n = haarnr
		for folds = 1:nfolds(find(N == Nr))
			ex{e}.N                 = N ;
			ex{e}.random_seed       = folds ;
			ex{e}.nfolds            = 1 ;
			ex{e}.nwc               = 800 ;
			ex{e}.tg_scale          = 10 ;
			ex{e}.cfg.gd_max_niters = 50 ;
			ex{e}.cfg.use_tg        = 1 ;
			ex{e}.cfg.sigma         = sigma ;
			ex{e}.cfg.haar_n        = haar_n ;
			ex{e}.cfg.verbosity     = verb ;   
			e = e + 1 ;
		end
	end
end

shapes_driver ;
