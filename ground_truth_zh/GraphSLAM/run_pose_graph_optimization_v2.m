% Run pose graph optimization
%
% Author : Soonhac Hong (sxhong1@ualr.edu)
% History : 
% 3/26/14 : Created

function [result, graph, initial, h_global, location_file_index, location_info_history]=run_pose_graph_optimization_v2(vro_result, vro_pose_std, graph, initial, h_global, dis, location_flag, location_file_index, location_info_history, lcd_found)

import gtsam.*

t = gtsam.Point3(0, 0, 0);

if isempty(h_global)
    h_global = get_global_transformation_single('smart_cane');
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
    [location_file_index, location_info_history]=plot_graph_initial_result_v2(initial, result, location_flag, location_file_index, location_info_history, lcd_found);
elseif location_flag == true && lcd_found == true
    [location_info, location_file_index] = generate_location_info_v2(result,[], location_file_index);
end

end

