% Generate *.ply files for visualization
%
% Author : Soonhac Hong (sxhong1@ualr.edu)
% Date : 6/5/14

function generate_map()
graphslam_addpath;

file_index = 12; %16; % 5 = whitecane 6 = etas 7 = loops 8 = kinect_tum 9 = loops2 10= amir_vro 11 = sparse_feature 12 = swing 13 = swing2 14 = motive 15 = object_recognition 16=map 17=it
dynamic_index = 25; %5; 
isgframe='none';
vro_name='vro';

%gtsam_isp_file_name='data\3d\whitecane\revisiting2_10m_Replace_pose_zero_411_vro_gtsam.isp';
%gtsam_opt_file_name='results\isam\3d\map5_Replace_pose_zero_3842_vro_gtsam.opt';

%gtsam_opt_file_name='results/isam/3d/revisiting2_10m_Replace_pose_zero_411_vro_gtsam.opt'; %18
%gtsam_opt_file_name='results/isam/3d/revisiting6_10m_Replace_pose_zero_910_vro_gtsam.opt'; %22
gtsam_opt_file_name='results/isam/3d/revisiting9_10m_Replace_pose_zero_827_vro_gtsam.opt';  %25
%gtsam_opt_file_name='results/isam/3d/revisiting8_10m_Replace_pose_zero_1084_vro_gtsam.opt';  %24

% VRO trajectory
%convert_isp2ply(gtsam_isp_file_name, file_index, dynamic_index, isgframe, vro_name);

% PGO trajectory and its map
convert_isp2ply(gtsam_opt_file_name, file_index, dynamic_index, isgframe, vro_name);
    
end