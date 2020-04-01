% JOIN_FACES_TEST
[ex,rs] = joinexp('results/faces_test-*.mat') ;
backup('results/faces_test.mat') ;
save('results/faces_test.mat','ex','rs') ;
