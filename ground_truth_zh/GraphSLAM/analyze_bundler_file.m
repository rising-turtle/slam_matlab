% Analyze bundler file
%
% Author : Soonhac Hong (sxhong1@ualr.edu)
% Date : 2/13/13

function analyze_bundler_file()

graphslam_addpath;
addpath('D:\soonhac\Project\PNBD\SW\ASEE\slamtoolbox\slamToolbox_11_09_08\FrameTransforms\Rotations');
addpath('D:\soonhac\Project\PNBD\SW\ASEE\slamtoolbox\slamToolbox_11_09_08\DataManagement');

%file_name = 'data/ba/ros_sba/exp1_bus_door_straight_150_Replace_pose_feature_426_48_ros_sba.out';
file_name = 'results/ros_sba/exp1_bus_door_straight_150_Replace_pose_feature_426_48_ros_sba_result.out';
%file_name = 'data/ba/ros_sba/exp1_bus_door_straight_150_Replace_pose_feature_1614_101_ros_sba.out';
%file_name = 'results/ros_sba/exp1_bus_door_straight_150_Replace_pose_feature_1614_101_ros_sba_result.out';
%file_name = 'data/ba/ros_sba/sample_bundler_file.out';
%file_name = 'results/ros_sba/result.out';

%%load ROS-SBA output file
[camera_poses, camera_parameters, landmark_position, landmark_projection] = load_rossba(file_name);

show_camera_pose(camera_poses, true, 'no', 'no', 'on', 'k.-' );
hold on;
%plot3(landmark_position(:,1),landmark_position(:,2),landmark_position(:,3),'m.');
axis equal;

%% Anlayze landmark position
landmark_distance = sqrt(sum(landmark_position.^2,2));


%% Analyze projection
%cam = initialize_cam2();
cam = initialize_cam();
features_info=[];
u0 = cam.Cx;
v0 = cam.Cy;

%ros_sba_T = sr4k_p2T([0,0,0,pi/2,0,0]);
% temp_t = camera_poses(1,1:3)';
% temp_R = e2R(camera_poses(1,4:6)');
% reference_T = [temp_R, temp_t; 0 0 0 1];
%reference_T = inv(ros_sba_T)*reference_T;



for i=1:size(camera_poses,1)
    temp_t = camera_poses(i,1:3)';
    temp_R = e2R(camera_poses(i,4:6)');   
    %temp_R = eye(3);
%     T = [temp_R, temp_t; 0 0 0 1];
%     %T = bundler_T*T;  % Convert Bundler frame to SBA frame.
%     temp_t = T(1:3,4);
%     temp_R = T(1:3,1:3);
    projection_idx = find(landmark_projection(:,1) == (i-1));
    estimated_uv=[];
    measured_uv=[];
    for j=1:size(projection_idx,1)-1
        measured_uv(j,:) = landmark_projection(projection_idx(j), end-1:end);
        measured_uv(j,:) = [measured_uv(j,1) + u0, -1 * measured_uv(j,2) + v0];
        temp_p = landmark_position(landmark_projection(projection_idx(j), 2)+1,:)';
        %temp_p = reference_T * [landmark_position(landmark_projection(projection_idx(j), 2)+1,:)'; 1];   % The reference frame of all landmark positions is the first camera coordinate !!!!!
        %temp_p = bundler_T * [landmark_position(landmark_projection(projection_idx(j), 2)+1,:)'; 1];   % The reference frame of all landmark positions is the first camera coordinate !!!!!
        estimated_uv(j,:) = hi_cartesian_test(temp_p(1:3), temp_t, temp_R, cam, features_info)';
        %estimated_uv(j,:) =  hi_cartesian_test(temp_p(1:3), [0;0;0], eye(3), cam, features_info )';
    end
    figure;
    plot(estimated_uv(:,1), estimated_uv(:,2),'b+');
    hold on;
    plot(measured_uv(:,1),measured_uv(:,2),'ro');
    legend('Estimated','Measured');
    hold off;
    
    projection_error = sqrt(sum((estimated_uv - measured_uv(:,1:2)).^2,2));
    projection_error_mean_std(i,:) = [mean(projection_error), std(projection_error)]; 
end

figure;
errorbar(projection_error_mean_std(:,1), projection_error_mean_std(:,2),'b.');

end


function cam = initialize_cam2()
nRows = 480;
nCols = 640;
k1=     0; %-0.85016;
k2=     0; %0.56153;
cam.Cx =    320; 
cam.Cy =    240; 
cam.fd = 430;
cam.f = 430;
cam.k1 =    k1;
cam.k2 =    k2;
cam.nRows = nRows;
cam.nCols = nCols;
cam.d  =    4/nCols*0.001;
cam.F  =    cam.f/cam.d;
% cam.f =     f;
cam.dx =    cam.d; %% dx and dy are actually slightly different dx =4/176 while dy = 3.17/144
cam.dy =    cam.d;

cam.K =     sparse( [ cam.fd   0     cam.Cx;
    0  cam.fd    cam.Cy;
    0    0     1] );
cam.model = 'two_distortion_parameters';
end