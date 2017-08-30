% Run pose graph optimization
%
% Author : Soonhac Hong (sxhong1@ualr.edu)
% History : 
% 3/26/14 : Created

function [result, graph, initial, h_global]=run_pose_graph_optimization_v0(data_name, dynamic_index, vro_result, vro_pose_std, graph, initial, h_global, dis)

import gtsam.*

t = gtsam.Point3(0, 0, 0);

if isempty(h_global)
    h_global = get_global_transformation_dataname(data_name, dynamic_index, 'none');
    rot = h_global(1:3,1:3);
    R = gtsam.Rot3(rot);
    origin= gtsam.Pose3(R,t);
    initial.insert(0,origin);
end

pgc_t=tic;
[graph,initial] = construct_pose_graph(vro_result, vro_pose_std, graph, initial);
first = initial.at(0);
pgc_ct =toc(pgc_t)

graph.add(NonlinearEqualityPose3(0, first));

gtsam_t=tic;
optimizer = LevenbergMarquardtOptimizer(graph, initial);
result = optimizer.optimizeSafely();
gtsam_ct =toc(gtsam_t)

% Show the results in the plot and generate location information
if dis==true
    plot_graph_initial_result_v0(initial, result);
end

end

