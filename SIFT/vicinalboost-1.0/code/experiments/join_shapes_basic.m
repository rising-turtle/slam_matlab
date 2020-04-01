% JOIN_SHAPES_BASIC
[ex,rs] = joinexp('results/shapes_basic-*.mat') ;
backup('results/shapes_basic.mat') ;
save('results/shapes_basic.mat','ex','rs') ;
