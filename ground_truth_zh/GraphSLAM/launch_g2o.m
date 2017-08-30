% launch g2o and show the results
% Author : Soonhac Hong (sxhong1@ualr.edu)
% Date : 2/23/12

clear; 

% Run VRO

run_convert = 0;
run_graphSLAM = 0;
run_plot = 1;
plot_feature_flag = 0;

file_index = 6;     % 5 = whitecane 6 = etas 7 = loops 8 = kinect_tum
dynamic_index = 1;     % 15:square_500, 16:square_700, 17:square_swing
etas_nFrame_list = [979 1479 979 1979 1889]; %[3rd_straight, 3rd_swing, 4th_straigth, 4th_swing, 5th_straight, 5th_swing]
loops_nFrame_list = [0 1359 2498 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2669];
m_nFrame_list = [0 5414 0 729];
compensation_option ={'Replace','Linear'};
compensation_index = 2;
etas_vro_size_list = [1260 0 1665 0 9490 0]; %1974
loops_vro_size_list = [0 13098 12476 0 0 0 0 0 0 0 0 0 0 0 0 0 0 26613];
kinect_tum_vro_size_list = [0 98 0 0];
feature_flag = 0;       % 0 = Exclude feature points into constraints, 1 = Include feature points constraints
dense_index  = 1;   %1 = dense constraints; 0 = sparse constraints
sparse_interval = 2;   % valid only if dense_index is zero
vro_dis = 0; % 1 = display vro, 0 = display no vro

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
    
index_interval = 0; %580;
if feature_flag == 1
    feature_pose_name = 'pose_feature';
else
    feature_pose_name = 'pose';
end

[g2o_result_dir_name, isam_result_dir_name, vro_dir_name, dynamic_dir_name] = get_file_names(file_index, dynamic_index);

% Select Data Set
%g2o_file_name_list ={'data/2d/manhattan3500/manhattanOlson3500.g2o', 'data/2d/intel/intel.g2o','data/3d/sphere/sphere_bignoise_vertex3.g2o','data/3d/garage/parking-garage.g2o','data/2d/whitecane/'};
%opt_file_name_list ={'results/g2o/2d/manhattanOlson3500.opt','results/g2o/2d/intel.opt','results/g2o/3d/sphere_bignoise_vertex3.opt','results/g2o/3d/parking-garage.opt','results/g2o/2d/'};
%file_index = 5;

% Convert VRO to g2o
%dir_name={'pitch_3degree','pitch_9degree','pan_3degree','pan_9degree','pan_30degree','pan_60degree','roll_3degree','roll_9degree','x_30mm','x_150mm','x_300mm','y_30mm','y_150mm','y_300mm','square_500','square_700','square_swing','test'};
%dir_index = 15;
%start_frame = [11 8 11 8 8 6 11 11 11 8 6 21 8 8 40 40 50 101];
%finish_frame = [70 25 70 25 16 11 135 50 150 35 21 150 35 22 316 376 397 130]; %316
%nFrame = finish_frame(dynamic_dload_graph_g2oata_index) - start_frame(dynamic_data_index) - 1;
%nFrame = 3920; %5468; %3920; %1133; %2399; %1253; %2440; %829; %270;


if file_index >= 5
    if run_convert == 1
        [vro_size] = convert_vro_g2o(file_index + 5, dynamic_index,nFrame,vro_dir_name, dynamic_dir_name, feature_flag, index_interval,compensation_option{compensation_index}, dense_index, sparse_interval, vro_dis);
    end
    opt_file_name = sprintf('%s%s_%s_%s_%d.opt', g2o_result_dir_name, dynamic_dir_name, compensation_option{compensation_index}, feature_pose_name, vro_size);
    g2o_file_name = sprintf('%s%s_%s_%s_%d.g2o', vro_dir_name, dynamic_dir_name, compensation_option{compensation_index}, feature_pose_name, vro_size);
else
    opt_file_name = g2o_result_dir_name;
    g2o_file_name = vro_dir_name;
end

% Run g2o
if run_graphSLAM == 1
    g2o_command_line=sprintf('/home/soonhac/sw/g2o/trunk/bin/g2o -o %s %s', opt_file_name, g2o_file_name);
    t_g2o = tic;
    [s, r] = system(g2o_command_line);
    t_g2o = toc(t_g2o);
end


% plot g2o
if run_plot == 1
    plot_g2o(g2o_file_name, opt_file_name, plot_feature_flag);
end
