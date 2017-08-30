function [graph, result, initial] = optimize_graph(graph, initial)
%
% David Z, 3/6/2015 
% graph optimization 
%

import gtsam.*

optimizer = LevenbergMarquardtOptimizer(graph, initial);
result = optimizer.optimizeSafely();

end