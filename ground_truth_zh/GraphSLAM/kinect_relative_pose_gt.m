% Compute relative pose b/w two images from ground truth in kinect_tum
%
% Author : Soonhac Hong (sxhong1@ualr.edu)
% Date : 12/20/12
function kinect_relative_pose_gt(dir_index, depth_file_index_1, depth_file_index_2)

format LONGG;
addpath('D:\soonhac\Project\PNBD\SW\ASEE\slamtoolbox\slamToolbox_11_09_08\FrameTransforms\Rotations');
addpath('D:\soonhac\Project\PNBD\SW\ASEE\slamtoolbox\slamToolbox_11_09_08\DataManagement');

% Get time stamp of color files
fisrt_depth_file_time_stamps = get_timestamp_kinect_tum(dir_index,depth_file_index_1)
second_depth_file_time_stamps = get_timestamp_kinect_tum(dir_index,depth_file_index_2)

% Load ground truth
[gt rgbdslam rtime] = Load_kinect_gt(dir_index);

% Find first time stamp 
%first_timestamp = get_timestamp_kinect_tum(dir_index,file_index_1);
gt_first_index = find(gt(:,1) > fisrt_depth_file_time_stamps, 1);
if gt(gt_first_index,1) - fisrt_depth_file_time_stamps > fisrt_depth_file_time_stamps - gt(gt_first_index-1,1)
    gt_first_index = gt_first_index - 1;
end

% Find second time stamp
%second_timestamp = get_timestamp_kinect_tum(dir_index,file_index_2);
gt_second_index = find(gt(:,1) > second_depth_file_time_stamps, 1);
if gt(gt_second_index,1) - second_depth_file_time_stamps > second_depth_file_time_stamps - gt(gt_second_index-1,1)
    gt_second_index = gt_second_index - 1;
end

gt_first_tf =[q2R([gt(gt_first_index,5:8)]) [gt(gt_first_index,2:4)]'; 0 0 0 1];
gt_second_tf =[q2R([gt(gt_second_index,5:8)]) [gt(gt_second_index,2:4)]'; 0 0 0 1];

rgbdslam_first_tf =[q2R([rgbdslam(gt_first_index,5:8)]) [rgbdslam(gt_first_index,2:4)]'; 0 0 0 1];
rgbdslam_second_tf =[q2R([rgbdslam(gt_second_index,5:8)]) [rgbdslam(gt_second_index,2:4)]'; 0 0 0 1];

gt_relative_tf = inv(gt_first_tf) * gt_second_tf;
gt_translation = [gt_relative_tf(1,4) gt_relative_tf(2,4) gt_relative_tf(3,4)];
gt_euler = R2e(gt_relative_tf(1:3,1:3));

rgbdslam_relative_tf = inv(rgbdslam_first_tf) * rgbdslam_second_tf;
rgbdslam_translation = [rgbdslam_relative_tf(1,4) rgbdslam_relative_tf(2,4) rgbdslam_relative_tf(3,4)];
rgbdslam_euler = R2e(rgbdslam_relative_tf(1:3,1:3));

figure;
plot(gt_translation,'g*');
hold on;
plot(rgbdslam_translation,'rd');
hold off;

end