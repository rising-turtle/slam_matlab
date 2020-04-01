% JOIN_FACES_BASIC
[ex,rs] = joinexp('results/faces_basic-*.mat') ;
backup('results/faces_basic.mat') ;
save('results/faces_basic.mat','ex','rs') ;
