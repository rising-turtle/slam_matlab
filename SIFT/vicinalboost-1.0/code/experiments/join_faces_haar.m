% JOIN_FACES_HAAR
[ex,rs] = joinexp('results/faces_haar-*.mat') ;
backup('results/faces_haar.mat') ;
save('results/faces_haar.mat','ex','rs') ;
