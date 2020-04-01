% JOIN_FACES_FULL
[ex,rs] = joinexp('results/faces_full-*.mat') ;
backup('results/faces_full.mat') ;
save('results/faces_full.mat','ex','rs') ;
