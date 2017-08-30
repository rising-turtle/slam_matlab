% Convert *.isp and *.sam to files for ROS sba(http://www.ros.org/wiki/sba/Tutorials/IntroductionToSBA)
%
% Author : Soonhac Hong (sxhong1@ualr.edu)
% Date : 2/11/13

function convert_isam2rossba()

graphslam_addpath;
addpath('D:\soonhac\Project\PNBD\SW\ASEE\slamtoolbox\slamToolbox_11_09_08\FrameTransforms\Rotations');
addpath('D:\soonhac\Project\PNBD\SW\ASEE\slamtoolbox\slamToolbox_11_09_08\DataManagement');

%% Load isam data
%sam_filename = 'D:\soonhac\Project\PNBD\SW\ASEE\GraphSLAM\data\3d\whitecane\exp8__Replace_pose_feature_76_18_vro_cov.sam';
%isp_filename = 'D:\soonhac\Project\PNBD\SW\ASEE\GraphSLAM\data\3d\whitecane\exp8__Replace_pose_feature_76_18_vro.isp';
%sam_filename = 'D:\soonhac\Project\PNBD\SW\ASEE\GraphSLAM\data\3d\whitecane\exp8__Replace_pose_feature_10138_580_vro_cov.sam';
%isp_filename = 'D:\soonhac\Project\PNBD\SW\ASEE\GraphSLAM\data\3d\whitecane\exp8__Replace_pose_feature_10138_580_vro.isp';
%isp_filename = 'D:\soonhac\Project\PNBD\SW\ASEE\GraphSLAM\data\3d\whitecane\exp3_bus_straight_150_Replace_pose_feature_1385_84_vro_icp_ch.isp';
%sam_filename = 'D:\soonhac\Project\PNBD\SW\ASEE\GraphSLAM\data\3d\whitecane\exp3_bus_straight_150_Replace_pose_feature_1385_84_vro_icp_ch_cov.sam';

file_index = 9;     % 5 = whitecane 6 = etas 7 = loops 8 = kinect_tum 9 = loops2 10= amir_vro 11 = sparse_feature
dynamic_index =1;     % 15:square_500, 16:square_700, 17:square_swing
vro_name_list={'vro','vro_icp','vro_icp_ch','icp'};
vro_name_index = 1;
vro_name=vro_name_list{vro_name_index};
compensation_option ={'Replace','Linear'};
compensation_index = 1;
feature_pose_name = 'pose_feature';
vro_size = 426; %1614; %1632;
pose_size = 48; %101; %104;
isgframe = 'gframe';

[g2o_result_dir_name, isam_result_dir_name, vro_dir_name, dynamic_dir_name] = get_file_names(file_index, dynamic_index);
sam_filename = sprintf('%s%s_%s_%s_%d_%d_%s_cov.sam', vro_dir_name, dynamic_dir_name, compensation_option{compensation_index}, feature_pose_name, vro_size, pose_size, vro_name);
isp_filename = sprintf('%s%s_%s_%s_%d_%d_%s.isp', vro_dir_name, dynamic_dir_name, compensation_option{compensation_index}, feature_pose_name, vro_size, pose_size, vro_name);

sba_filename =sprintf('data/ba/ros_sba/%s_%s_%s_%d_%d_ros_sba.out',dynamic_dir_name, compensation_option{compensation_index}, feature_pose_name, vro_size, pose_size);
%sam_filename = 'D:\soonhac\Project\PNBD\SW\ASEE\GraphSLAM\data\3d\whitecane\exp1_bus_door_straight_150_Replace_pose_zero_1632_104_vro_icp_ch_cov.sam';
%isp_filename = 'D:\soonhac\Project\PNBD\SW\ASEE\GraphSLAM\data\3d\whitecane\exp1_bus_door_straight_150_Replace_pose_zero_1632_104_vro_icp_ch.isp';
%sba_filename = 'D:\soonhac\Project\PNBD\SW\ASEE\GraphSLAM\data\ba\ros_sba\exp8__Replace_pose_feature_10138_580_ros_sba.out';




[landmarks, initial_landmarks] = load_landmark_vro(sam_filename);
[initial_camera_pose] = load_camera_pose(isp_filename);  % x, y, z, rx, ry, rz
sr4k_parameter = initialize_cam();

%check_camera_projection(initial_camera_pose, landmarks, isgframe);

%show_camera_pose(initial_camera_pose, true, 'vro', 'k.-');

%debug
% show_camera_pose(initial_camera_pose,true, 'k.-');
% hold on;
% plot3(initial_landmarks(:,2),initial_landmarks(:,3),initial_landmarks(:,4),'m*')
% axis equal;

%% Generate cameara pose
% Data format (http://phototour.cs.washington.edu/bundler/bundler-v0.3-manual.html#S6)
% # Bundle file v0.3
%     <num_cameras> <num_points>   [two integers]
%     <camera1>
%     <camera2>
%        ...
%     <cameraN>
%     <point1>
%     <point2>
%        ...
%     <pointM>
%
% <cameraI>
%   <f> <k1> <k2>   [the focal length, followed by two radial distortion coeffs]
%       <R>             [a 3x3 matrix representing the camera rotation]
%       <t>             [a 3-vector describing the camera translation]
%
% Global coordindate
% Z : depth
%  -------------> X
% |
% |
% V
% Y
%

fu = sr4k_parameter.f;
u0 = sr4k_parameter.Cx;
v0 = sr4k_parameter.Cy;
kd = [sr4k_parameter.k1, sr4k_parameter.k2];
%ros_sba_T = inv(p2T([0,0,0,-90*pi/180,0,0]));
ros_sba_T = sr4k_p2T([0,0,0,pi/2,0,0]);


%ros_sba_R2 = e2R([-pi/2, 0, -pi/2]);
%ros_sba_T = [ros_sba_R2 [0, 0, 0]'; 0 0 0 1];

%file_name_pose = sprintf('%s%s_%s_%s_%d_%d_%s.isp',file_name, dir_name, cmp_option, feature_pose_name, vro_size, e_t_pose_size, vro_name);
%filename = 'D:\soonhac\Project\PNBD\SW\ASEE\GraphSLAM\data\ba\ros_sba\exp8__Replace_pose_feature_76_18_ros_sba.out';
%sba_filename = 'D:\soonhac\Project\PNBD\SW\ASEE\GraphSLAM\data\ba\ros_sba\exp8__Replace_pose_feature_10138_580_ros_sba.out';
%filename = 'D:\soonhac\Project\PNBD\SW\ASEE\GraphSLAM\data\ba\ros_sba\exp3_bus_straight_150_Replace_pose_feature_1385_84_ros_sba.out';

converted_camera_pose=[];
cams_fd = fopen(sba_filename, 'w');
fprintf(cams_fd,'# Bundle file v0.3\n');
fprintf(cams_fd,'%d %d\n', size(initial_camera_pose,1), size(initial_landmarks,1));
%r2d = 180/pi;

%first camera pose as the reference frame
% rot = e2R([pi, 0, 0]);
% trans = [0, 0, 0]';
% fprintf(cams_fd,'%f %f %f\n', fu, kd);
% for r=1:3
%     fprintf(cams_fd,'%f %f %f\n', rot(r,:));
% end
% fprintf(cams_fd,'%f %f %f\n', trans(1), trans(2), trans(3));  
% converted_camera_pose=[converted_camera_pose; trans(1:3)' [0, 0, 0]];
% ros_sba_T_camera = [rot trans; 0 0 0 1];

trans = [0 0 0]; 
rot = e2R([pi(), 0, 0]);%e2R([initial_camera_pose(1,4), initial_camera_pose(1,5), initial_camera_pose(1,6)]);
bundler_T = [rot trans'; 0 0 0 1];

for i=1:size(initial_camera_pose,1)
    trans = initial_camera_pose(i,1:3);
    if strcmp(isgframe, 'gframe')
        rot = e2R([initial_camera_pose(i,4), initial_camera_pose(i,5), initial_camera_pose(i,6)]);
    else
        rot = euler_to_rot(initial_camera_pose(i,5)*180/pi,initial_camera_pose(i,4)*180/pi,initial_camera_pose(i,6)*180/pi);
    end
    
    T = [rot trans'; 0 0 0 1];
    %T = ros_sba_T * inv(first_camera_T) * T;
    %T = ros_sba_T * T;
    %T = bundler_T*ros_sba_T * T;
    sba_T = inv(T);  % ROS SBA convention !!!!  camera N = inv(T)* camera N+1
    if strcmp(isgframe, 'gframe') 
        T = bundler_T*sba_T;  % rotate 180 around x for Bundler frame
    else
        T = bundler_T*ros_sba_T*sba_T*inv(ros_sba_T);  % rotate 180 around x to Bundler frame
    end
    trans = T(1:3,4)';
    rot = T(1:3,1:3);
    %trans = ros_sba_T*[trans'; 1]; % convert coordinate
    %debug_rot = euler_to_rot(initial_camera_pose(i,5)*r2d,initial_camera_pose(i,4)*r2d,initial_camera_pose(i,6)*r2d); % [ry, rx, rz]
    %rot = e2R([initial_camera_pose(i,4), -initial_camera_pose(i,6), initial_camera_pose(i,5)]);
    %rot = e2R([0, 0, 0]);
    %rot = ros_sba_T_camera(1:3,1:3)*ros_sba_T(1:3,1:3)*e2R([initial_camera_pose(i,4), initial_camera_pose(i,5), initial_camera_pose(i,6)]);
    fprintf(cams_fd,'%f %f %f\n', fu, kd);
    for r=1:3
        fprintf(cams_fd,'%f %f %f\n', rot(r,:));
    end
    fprintf(cams_fd,'%f %f %f\n', trans(1), trans(2), trans(3));  
    %fprintf(cams_fd,'%f %f %f\n', trans);
    %converted_camera_pose=[converted_camera_pose; T(1:3,4)' R2e(T(1:3,1:3))'];
    converted_camera_pose=[converted_camera_pose; trans R2e(rot)'];
end

show_camera_pose(converted_camera_pose,true, 'typical', 'ros_sba', 'on', 'k.-');

%% Generate landmarks points
%
% <pointM>
%       <position>      [a 3-vector describing the 3D position of the point]
%       <color>         [a 3-vector describing the RGB color of the point]
%       <view list>     [a list of views the point is visible in]
% <view list>
%       <nlist> <camera> <key> <x> <y> ....   [The pixel positions are floating point numbers in a coordinate system where the origin is the center of the image, the x-axis increases to the right, and the y-axis increases towards the top of the image.]
%
% Note : The reference coordinate of landmark point is the first camera coordinate !!!!

%ros_sba_T_landmark = sr4k_p2T([0,0,0,-pi/2,0,0]);

%TODO : initial_landmarks and landmarks position is different in position
%and measured pixel


converted_landmark=[];
color = [255, 255, 255];
key_offset = landmarks(1,2);
for i=1:size(initial_landmarks,1)
    xyz = initial_landmarks(i,2:4);
    if strcmp(isgframe, 'gframe') 
        xyz = [xyz'; 1]; 
    else
        xyz = ros_sba_T*[xyz'; 1]; % convert coordinate because z-axis should represent the depth.
    end
    %xyz = bundler_T * ros_sba_T*[xyz'; 1]; % convert coordinate. See Note !!!!
    %xyz = ros_sba_T*inv(first_camera_T)*[xyz'; 1]; % convert coordinate. See Note !!!!
    landmark_idx = initial_landmarks(i,1);
    nframes_idx=find(landmarks(:,2)==landmark_idx);
    fprintf(cams_fd,'%f %f %f\n', xyz(1), xyz(2), xyz(3)); 
    %fprintf(cams_fd,'%f %f %f\n', xyz);
    fprintf(cams_fd,'%d %d %d\n', color);
    %View list
    fprintf(cams_fd,'%d ', size(nframes_idx,1));
    for c=1:size(nframes_idx,1)
        frame_idx = landmarks(nframes_idx(c,1),1);
        key_idx = landmarks(nframes_idx(c,1),2);
        img_idx = landmarks(nframes_idx(c,1),6:7);
        img_idx(1) = img_idx(1) - u0;   % Adjust image coordinate for ROS SBA
        img_idx(2) = (-1) * (img_idx(2) - v0);   % Adjust image coordinate for ROS SBA
        fprintf(cams_fd,'%d %d %f %f ', frame_idx, key_idx-key_offset, img_idx);
        converted_landmark=[converted_landmark; frame_idx, key_idx-key_offset, xyz(1), xyz(2), xyz(3),img_idx];
    end
    fprintf(cams_fd,'\n');
    %coverted_landmark=[coverted_landmark; xyz(1), xyz(2), xyz(3)];
end
fclose(cams_fd);

%Debug - show landmarks
hold on;
plot3(converted_landmark(:,3), converted_landmark(:,4), converted_landmark(:,5), 'm.');
hold off;
axis equal;

%check_camera_projection_with_converted_data(converted_camera_pose, converted_landmark, initial_camera_pose, landmarks, isgframe);

end

function check_camera_projection_with_converted_data(camera_poses, feature_points, initial_camera_pose, initial_landmarks, isgframe)
cam = initialize_cam();
features_info=[];
ros_sba_T = sr4k_p2T([0,0,0,pi/2,0,0]);
u0 = cam.Cx;
v0 = cam.Cy;
trans = [0 0 0]; 
rot = e2R([pi(), 0, 0]);%e2R([initial_camera_pose(1,4), initial_camera_pose(1,5), initial_camera_pose(1,6)]);
bundler_T = [rot trans'; 0 0 0 1];


camera_index_list=unique(feature_points(:,1));

for i=1:size(camera_index_list,1)
    temp_t = camera_poses(i,1:3)';
    initial_temp_t = initial_camera_pose(i,1:3)';
    %temp_R = e2R(camera_poses(i,4:6)');   
    if strcmp(isgframe, 'gframe') 
        temp_R = e2R(camera_poses(i,4:6)'); 
        initial_temp_R = e2R(initial_camera_pose(i,4:6)'); 
    else
        temp_R = euler_to_rot(camera_poses(i,5)*180/pi,camera_poses(i,4)*180/pi,camera_poses(i,6)*180/pi);
    end
    
    T = [temp_R, temp_t; 0 0 0 1];
    T = bundler_T*T;  % Convert VRO frame to SBA frame
    T = inv(T);
    temp_t = T(1:3,4);
    temp_R = T(1:3,1:3);
    
    abs(temp_t - initial_temp_t)
    abs(temp_R - initial_temp_R)
    
    initial_camera_index = camera_index_list(i);
    initial_data_index_list = find(initial_landmarks(:,1) == initial_camera_index);
    initial_unit_data = initial_landmarks(initial_data_index_list,:);
    initial_estimated_uv = [];
    initial_measured_uv = initial_unit_data(:,6:7);
    
    camera_index = camera_index_list(i);
    data_index_list = find(feature_points(:,1) == camera_index);
    unit_data = feature_points(data_index_list,:);
    estimated_uv = [];
    measured_uv = [unit_data(:,6)+u0, unit_data(:,7).*(-1) + v0];
    for j=1:size(unit_data,1)
        %temp_p = ros_sba_T * [unit_data(j,3:5) 1]';
        temp_p = [unit_data(j,3:5) 1]';
        initial_temp_p = [initial_unit_data(j,3:5) 1]';
        %estimated_uv(j,:) = hi_cartesian_test(temp_p(1:3), [0;0;0], eye(3), cam, features_info )';
        if strcmp(isgframe, 'gframe') 
            estimated_uv(j,:) = hi_cartesian_test(temp_p(1:3), temp_t, temp_R, cam, features_info )';
            %estimated_uv(j,:) = hi_cartesian_test(initial_temp_p(1:3), temp_t, temp_R, cam, features_info )';
            initial_estimated_uv(j,:) = hi_cartesian_test(initial_temp_p(1:3), initial_temp_t, initial_temp_R, cam, features_info )';
        else
            estimated_uv(j,:) = vro_camera_projection(temp_p(1:3), temp_t, temp_R, cam, features_info, ros_sba_T)';
        end
    end
    figure;
    plot(estimated_uv(:,1), estimated_uv(:,2),'b+');
    hold on;
    %plot(unit_data(:,6)+u0,unit_data(:,7).*(-1) + v0,'ro');
    plot(measured_uv(:,1), measured_uv(:,2),'ro');
    plot(initial_estimated_uv(:,1), initial_estimated_uv(:,2),'gd');
    legend('Estimated','Measured','Init Estimated');
    hold off;
    
    projection_error = sqrt(sum((estimated_uv - measured_uv).^2,2));
    projection_error_mean_std(i,:) = [mean(projection_error), std(projection_error)]; 
    
    initial_projection_error = sqrt(sum((initial_estimated_uv - initial_measured_uv).^2,2));
    initial_projection_error_mean_std(i,:) = [mean(initial_projection_error), std(initial_projection_error)]; 
    
    
    %compare with initial values
    %abs(projection_error - initial_projection_error)
    %abs(projection_error_mean_std - initial_projection_error_mean_std)
end

figure;
errorbar(projection_error_mean_std(:,1), projection_error_mean_std(:,2),'b');

figure;
errorbar(initial_projection_error_mean_std(:,1), initial_projection_error_mean_std(:,2),'r');

end

function check_camera_projection(camera_poses, feature_points, isgframe)
cam = initialize_cam();
features_info=[];
ros_sba_T = sr4k_p2T([0,0,0,pi/2,0,0]);

camera_index_list=unique(feature_points(:,1));

for i=1:size(camera_index_list,1)
    temp_t = camera_poses(i,1:3)';
    %temp_R = e2R(camera_poses(i,4:6)');   
    if strcmp(isgframe, 'gframe') 
        temp_R = e2R(camera_poses(i,4:6)'); 
    else
        temp_R = euler_to_rot(camera_poses(i,5)*180/pi,camera_poses(i,4)*180/pi,camera_poses(i,6)*180/pi);
    end
    
%     T = [temp_R, temp_t; 0 0 0 1];
%     T = ros_sba_T*T;  % Convert VRO frame to SBA frame
%     temp_t = T(1:3,4);
%     temp_R = T(1:3,1:3);
    
    camera_index = camera_index_list(i);
    data_index_list = find(feature_points(:,1) == camera_index);
    unit_data = feature_points(data_index_list,:);
    estimated_uv = [];
    for j=1:size(unit_data,1)
        %temp_p = ros_sba_T * [unit_data(j,3:5) 1]';
        temp_p = [unit_data(j,3:5) 1]';
        %estimated_uv(j,:) = hi_cartesian_test(temp_p(1:3), [0;0;0], eye(3), cam, features_info )';
        if strcmp(isgframe, 'gframe') 
            estimated_uv(j,:) = hi_cartesian_test(temp_p(1:3), temp_t, temp_R, cam, features_info )';
        else
            estimated_uv(j,:) = vro_camera_projection(temp_p(1:3), temp_t, temp_R, cam, features_info, ros_sba_T)';
        end
    end
    figure;
    plot(estimated_uv(:,1), estimated_uv(:,2),'b+');
    hold on;
    plot(unit_data(:,6),unit_data(:,7),'ro');
    legend('Estimated','Measured');
    hold off;
    
    projection_error = sqrt(sum((estimated_uv - unit_data(:,6:7)).^2,2));
    projection_error_mean_std(i,:) = [mean(projection_error), std(projection_error)]; 
end

figure;
errorbar(projection_error_mean_std(:,1), projection_error_mean_std(:,2),'b');


end

% function T = p2T(x)
% 
% Rx = @(a)[1     0       0;
%           0     cos(a)  -sin(a);
%           0     sin(a)  cos(a)];
%       
% Ry = @(b)[cos(b)    0   sin(b);
%           0         1   0;
%           -sin(b)   0   cos(b)];
%       
% Rz = @(c)[cos(c)    -sin(c) 0;
%           sin(c)    cos(c)  0;
%           0         0       1];
% 
% Rot = @(x)Rz(x(3))*Rx(x(1))*Ry(x(2));  % SR4000 project; see euler_to_rot.m
% T = [Rot(x(4:6)) [x(1), x(2), x(3)]'; 0 0 0 1];
% 
% end