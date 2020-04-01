% SHAPES_BASIC
%
% Repeat for : PARZEN, TANGENT, TANGENT+GRADIENT
% Repeat for : SIGMA, N

randn('state',0 );
rand('state',0 );

clear ex ;

Nr     = [25] ;
sigmar = [0.4] ;
verb   = 2 ; 
e      = 1 ;

ex_results_path  = 'results/shapes_test.mat' ;

% SMALL DATA SETS 
for N = Nr
  for sigma = sigmar
    ex{e}.N                 = N ;
    ex{e}.nfolds            = 1 ;
    ex{e}.nwc               = 800 ;
    ex{e}.tg_scale          = 1 ;
    ex{e}.cfg.gd_max_niters = 50 ;
    ex{e}.cfg.use_tg        = 1 ;
    ex{e}.cfg.sigma         = sigma ;
    ex{e}.cfg.verbosity     = verb ;    
    e = e + 1 ;
  end
end

shapes_driver ;
