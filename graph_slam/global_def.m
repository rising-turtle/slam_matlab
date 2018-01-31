%
% David Z, Jan 22th, 2015
% global variables 
%

global g_ws_dir;        %% the root module dir, ./GraphSLAM ./Localization etc.
global g_data_dir;      %% the root of the data dir 
global g_data_prefix;   %% the prefix of the data files, e.g. 'd1' 'Data2' 'bb2mb'
global g_data_suffix;   %% the suffix of the data files, e.g. 'dat' 'bdat'
global g_camera_type;   %% load method differs according to different camera type

g_ws_dir = 'D:/work/SLAM/soonhac/';
% g_ws_dir = 'D:/work/soonhac';


% g_data_dir = 'D:/work/SLAM/soonhac/workstation_8.10.2014';
% g_data_dir = 'D:/work/SLAM/data2';
% g_data_dir = 'D:/work/data/l2o';
% g_data_dir = 'D:/work/data/Creative/data1';

% g_data_dir = 'D:/work/SLAM/soonhac/exp2_etas523_hallway_exp3';
% g_data_dir = 'D:/work/SLAM/soonhac/workstation_8.10.2014';
% g_data_dir = 'D:/work/data/SLAM/SR4000/workstation_8.10.2014';

% g_data_dir = 'D:/work/data/SLAM/Creative/dataset_5';
% g_data_dir = 'D:/work/data/Creative/data1';
g_data_dir = 'D:/work/data/sr4000/dataset_21';  

%% total number of frames 
global g_total_frames g_start_frame g_step_frame
g_start_frame = 1;
g_total_frames = 2030; 
g_step_frame = 3;

% g_data_prefix = 'x';
g_data_prefix = 'd1';
% g_data_prefix = 'Data2';
% g_data_prefix = 'bb2mb';
% g_data_prefix = 'l2o';

% !! notice, the data 'bdat' is binary file while 'dat' is not, 
% so call different function to read these two kinds of file in
% line 43,45 and 129, 131 in
% localization_sift_ransac_limit_cov_fast_fast_dist2_nobpc_binary
% or just call localization_sift_ransac_limit_cov_fast_fast_dist2_nobpc 
% wait!, these two have implemented different functions and flows, what'
% the mess! so, now I just change the load_sr_data method in 43, 45, 129,
% 131 in the lo***binary.m
g_data_suffix = 'bdat';
% g_data_suffix = 'dat'; 

% currently, smart_cane: SR, creative 
g_camera_type = 'smart_cane';  % this is also the data_name
% g_camera_type = 'creative';

global g_filter_type % filter the input camera data 
g_filter_type = 'gaussian';

global g_sift_threshold % sift detector threshold 
g_sift_threshold = 0 ; % not use any threshold in sift detection

%% display trajectory area [xmin xmax] ~ [ymin ymax]
global g_display g_dis_x_min g_dis_x_max g_dis_y_min g_dis_y_max 
g_display = true;
g_dis_x_min = -1; %-10; % -7 -15
g_dis_x_max = 40; % 10;  % 15  5
g_dis_y_min = -20; %-5;
g_dis_y_max = 20 ;%15; 

%% weather to delete previous files or use middle result
% : features, matched points ... 
global g_delete_previous_data 
g_delete_previous_data = false; 

%% ransac parameters 
global g_ransac_iteration_limit g_minimum_ransac_num
g_ransac_iteration_limit = 0;
g_minimum_ransac_num = 12; % minimum feature as input to ransac

%% depth filter parameter 
global g_depth_filter_max % max depth value for a camera frame
g_depth_filter_max = 8;  % 10, or 5 in different camera model

%% weather to compute the computational time 
global g_measure_ct 
g_measure_ct = false; 

%% video parameter 
global g_video_name g_record_video
g_video_name = 'results/david_z_eit.avi';
g_record_video = false;

%% middle data dir: feature, pose_std, matched_pointss
global g_feature_dir g_matched_dir g_pose_std_dir 
g_feature_dir = 'visual_feature_zh';
g_matched_dir = 'matched_points_zh';
g_pose_std_dir = 'pose_std_zh';