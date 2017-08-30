% Compare ROS-SBA and GTSAM 
%
% Author : Soonhac Hong (sxhong1@ualr.edu)
% Date : 2/11/13

function [graph, initial] = compare_ros_sba_gtsam(file_name)

import gtsam.*

graphslam_addpath;
addpath('D:\soonhac\Project\PNBD\SW\ASEE\slamtoolbox\slamToolbox_11_09_08\FrameTransforms\Rotations');
addpath('D:\soonhac\Project\PNBD\SW\ASEE\slamtoolbox\slamToolbox_11_09_08\DataManagement');


file_name = 'data/ba/ros_sba/sample_bundler_file.out';
%file_name = 'data/ba/ros_sba/exp1_bus_door_straight_150_Replace_pose_feature_1614_101_ros_sba.out';
%file_name = 'results/ros_sba/result.out';

%%load ROS-SBA output file
[camera_poses, camera_parameters, landmark_position, landmark_projection] = load_rossba(file_name);

show_camera_pose(camera_poses, true, 'no', 'no', 'off', 'k.-' );
hold on;
plot3(landmark_position(:,1),landmark_position(:,2),landmark_position(:,3),'m*');
axis equal;


%% Generate measured landmark points at each camera from measured image plane points
landmark_relative_position=[];
for i=1:size(landmark_projection,1)
    camera_index = landmark_projection(i,1);
    f = camera_parameters(camera_index+1,1);
    unit_z = landmark_position(camera_index+1,3);
    unit_x = landmark_projection(i,3)*unit_z/f;
    unit_y = (-1)*landmark_projection(i,4)*unit_z/f;
    landmark_relative_position = [landmark_relative_position; [camera_index, landmark_projection(i,2), unit_x, unit_y, unit_z]];
end


%% Compute relative pose between camera pose
nCamera = size(camera_poses,1);
camera_relative_pose=[];
for i=1:nCamera
    first_camera_index = i-1;
    first_camera_points_idx= find(landmark_relative_position(:,1) == first_camera_index);
    first_camera_points = landmark_relative_position(first_camera_points_idx,:);
    for j=first_camera_index+1:nCamera-1
        second_camera_index = j;
        second_camera_points_idx= find(landmark_relative_position(:,1) == second_camera_index);
        second_camera_points = landmark_relative_position(second_camera_points_idx,:);
        
        [first_op_set, second_op_set] = find_correspondent_points(first_camera_points, second_camera_points);
        % TODO : SVD
        [rot, trans, sta] = find_transform_matrix(first_op_set', second_op_set');
        [euler_xyz] = R2e(rot);
        %[phi, theta, psi] = rot_to_euler(rot); 
        camera_relative_pose = [camera_relative_pose; [double(first_camera_index),double(second_camera_index), trans', euler_xyz']];
    end
end

%% Generate graph and initial
graph = NonlinearFactorGraph;
initial = Values;

for i=1:size(camera_poses,1)
    t= gtsam.Point3(camera_poses(i,1), camera_poses(i,2), camera_poses(i,3));
    R = gtsam.Rot3.Ypr(camera_poses(i,6), camera_poses(i,5), camera_poses(i,4));  % rz,ry,rx
    position=gtsam.Pose3(R,t);
    initial.insert(i-1,position);
end

pose_noise_model = get_pose_noise_model();
for i=1:size(camera_relative_pose,1)
    i1 = camera_relative_pose(i,1);
    i2 = camera_relative_pose(i,2);
    t = gtsam.Point3(camera_relative_pose(i,3), camera_relative_pose(i,4), camera_relative_pose(i,5));
    R = gtsam.Rot3.Ypr(camera_relative_pose(i,8), camera_relative_pose(i,7), camera_relative_pose(i,6));
    dpose = gtsam.Pose3(R,t);
    graph.add(BetweenFactorPose3(i1, i2, dpose, pose_noise_model));
end


%% Run pose-optimization using gtsam
first = initial.at(0);
figure;plot3(first.x(),first.y(),first.z(),'r*'); hold on
plot3_gtsam(initial,'g-',false);
drawnow;

graph.add(NonlinearEqualityPose3(0, first));
optimizer = LevenbergMarquardtOptimizer(graph, initial);
result = optimizer.optimizeSafely();

%plot3DTrajectory(result, 'r-', false); axis equal;
plot3_gtsam(result,'r-',false); axis equal;

view(3); axis equal;


% Save initial pose
gtsam_isp_file_name = 'data/ba/ros_sba/sample_bundler_file_initial.isp';
save_graph_isp(initial, gtsam_isp_file_name);
% Save optimized pose
gtsam_opt_file_name = 'results/isam/3d/sample_bundler_file.opt';
save_graph_isp(result, gtsam_opt_file_name);


%%Compare ROS-SBA and GTSAM
ros_sba_result_file_name = 'results/ros_sba/result.out';
%ros_sba_result_file_name = 'results/ros_sba/exp1_bus_door_straight_150_Replace_pose_feature_1614_101_ros_sba_result.out';
[opt_poses] = load_graph_isp(gtsam_opt_file_name);
show_camera_pose(opt_poses, true, 'no', 'no', 'off', 'bo-');
hold on;
[ros_sba_result_camera_poses, ros_sba_result_camera_parameters, ros_sba_result_landmark_position, ros_sba_result_landmark_projection] = load_rossba(ros_sba_result_file_name);

show_camera_pose(ros_sba_result_camera_poses, false, 'no', 'no', 'off', 'rd-');
%hold on;
plot3(ros_sba_result_landmark_position(:,1),ros_sba_result_landmark_position(:,2),ros_sba_result_landmark_position(:,3),'m*');
grid;
axis equal;
legend('Pose-GTSAM','SBA','Landmark');
hold off;

end


function [first_op_set, second_op_set] = find_correspondent_points(first_camera_points, second_camera_points)

first_op_set = [];
second_op_set = [];

for i=1:size(first_camera_points,1)
    first_op_set = [first_op_set; first_camera_points(i,3:5)];
    matched_index = find(second_camera_points(:,2) == first_camera_points(i,2));
    second_op_set = [second_op_set; second_camera_points(matched_index,3:5)];
end
end


function [pose_noise_model] = get_pose_noise_model()

    import gtsam.*

    %step_factor = abs(i2-i1);
    step_factor = 1; %abs(i2-i1);
    
    translation_covariance = (double(step_factor)^2) * 0.5; %0.014; %[m]
    orientation_covariance = (double(step_factor)^2) * 1.0*pi/180; %0.6*pi/180; %[degree] -> [radian]
    
    pose_noise_model = noiseModel.Diagonal.Sigmas([translation_covariance; translation_covariance; translation_covariance; orientation_covariance; orientation_covariance; orientation_covariance]);  % [m][radian]

end