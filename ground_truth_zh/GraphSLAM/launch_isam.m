% launch isam and show the results
% Author : Soonhac Hong (sxhong1@ualr.edu)
% Date : 3/2/12

% Run VRO
graphslam_addpath;

run_convert = 1;
run_graphSLAM = 0;   % It should be zero due to the run-time error by system()
run_plot = 0;


file_index = 6;     % 5 = whitecane 6 = etas 7 = loops 8 = kinect_tum
dynamic_index = 3;     % 15:square_500, 16:square_700, 17:square_swing
etas_nFrame_list = [979 1479 621 1979 296]; %1889%979%299%659%[3rd_straight, 3rd_swing, 4th_straigth, 4th_swing, 5th_straight, 5th_swing]
loops_nFrame_list = [0 1359 2498 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2669]; %
kinect_tum_nFrame_list = [0 427 0 0];
m_nFrame_list = [0 5414 0 729];
compensation_option ={'Replace','Linear'};
compensation_index = 1;
etas_vro_size_list = [1974 0 1665 0 9490 0];
loops_vro_size_list = [0 13098 12476 0 0 0 0 0 0 0 0 0 0 0 0 0 0 26613]; %12476
kinect_tum_vro_size_list = [0 2135 0 0];
feature_flag = 0;       %0 = Exclude feature points into constraints, 1 = Include feature points constraints
dense_index  = 0;       %1 = dense constraints; 0 = sparse constraints
sparse_interval = 10;   % valid only if dense_index is zero
vro_dis = 1; % 1 = display vro, 0 = display no vro

switch file_index
    case 5       
        nFrame = m_nFrame_list(dynamic_index - 14);
        vro_size = 6992; %5382; %46; %5365; %5169;
    case 6
        nFrame = etas_nFrame_list(dynamic_index); %289; 5414; %46; %5468; %296; %46; %86; %580; %3920;
        vro_size = etas_vro_size_list(dynamic_index); %1951; 1942; %5382; %46; %5365; %5169;
    case 7
        nFrame = loops_nFrame_list(dynamic_index);
        vro_size = loops_vro_size_list(dynamic_index); 
    case 8
        nFrame = kinect_tum_nFrame_list(dynamic_index);
        vro_size = kinect_tum_vro_size_list(dynamic_index); 
end
    
if feature_flag == 1
    feature_pose_name = 'pose_feature';
else
    feature_pose_name = 'pose_zero';
end

if nFrame == 296
    index_interval = 580;
elseif nFrame == 18
    index_interval = 2480;    
else
    index_interval = 0;
end

[g2o_result_dir_name, isam_result_dir_name, vro_dir_name, dynamic_dir_name] = get_file_names(file_index, dynamic_index);

% Convert VRO to isam
if file_index >= 5
    if run_convert == 1
        [vro_size] = convert_vro_isam(file_index + 5, dynamic_index,nFrame,vro_dir_name, dynamic_dir_name, feature_pose_name, feature_flag, index_interval,compensation_option{compensation_index}, dense_index, sparse_interval, vro_dis);
    end
    opt_file_name = sprintf('%s%s_%s_%s_%d_isam.opt', isam_result_dir_name, dynamic_dir_name, compensation_option{compensation_index}, feature_pose_name, vro_size);
    isam_file_name = sprintf('%s%s_%s_%s_%d.sam', vro_dir_name, dynamic_dir_name, compensation_option{compensation_index}, feature_pose_name, vro_size);
    isp_file_name = sprintf('%s%s_%s_%s_%d.isp', vro_dir_name, dynamic_dir_name, compensation_option{compensation_index}, feature_pose_name, vro_size);
else
    opt_file_name = isam_result_dir_name;
    isam_file_name = vro_dir_name;
end


% Run isam
if run_graphSLAM == 1
    isam_command_line=sprintf('/home/soonhac/sw/isam/bin/isam -W %s %s', opt_file_name, isam_file_name);
    t_isam = tic;
    [s, r] = system(isam_command_line);
    t_isam = toc(t_isam);
end


% plot g2o
if run_plot == 1
    if file_index == 8
        opt_file_name = 'none';
        plot_kinect_tum(isp_file_name, opt_file_name, 'isam', dynamic_index);
    else
        plot_isam(isp_file_name, opt_file_name);
    end
end
