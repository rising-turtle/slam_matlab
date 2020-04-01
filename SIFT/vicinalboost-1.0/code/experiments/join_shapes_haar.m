% JOIN_SHAPES_HAAR
[ex,rs] = joinexp('results/shapes_haar-*.mat') ;
backup('results/shapes_haar.mat') ;
save('results/shapes_haar.mat','ex','rs') ;
