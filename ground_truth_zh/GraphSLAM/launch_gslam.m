% launch g2o and show the results
% Author : Soonhac Hong (sxhong1@ualr.edu)
% Date : 2/23/12

clear; 

% Run VRO

run_convert = 1;
run_graphSLAM = 0;
run_plot = 0;
plot_feature_flag = 0;

file_index = 6;     % 5 = whitecane 6 = etas
dynamic_index = 1;     % 15:square_500, 16:square_700, 17:square_swing
etas_nFrame_list = [979 0];
m_nFrame_list = [0 5414 0];

switch file_index
    case 5
        nFrame = m_nFrame_list(dynamic_index - 14);
        vro_size = 5382; %46; %5365; %5169;
    case 6
        nFrame = etas_nFrame_list(dynamic_index); %5414; %46; %5468; %296; %46; %86; %580; %3920;
        vro_size = 1942; %5382; %46; %5365; %5169;
end
    
feature_flag = 0;       % 0 = Exclude feature points into constraints, 1 = Include feature points constraints
index_interval = 0; %580;

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
        [vro_size] = run_gslam(file_index + 5, dynamic_index,nFrame,vro_dir_name, dynamic_dir_name, feature_flag, index_interval,1);
    end
    opt_file_name = sprintf('%s%s_%d.opt', g2o_result_dir_name, dynamic_dir_name, vro_size);
    g2o_file_name = sprintf('%s%s_%d.g2o', vro_dir_name, dynamic_dir_name, vro_size);
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
