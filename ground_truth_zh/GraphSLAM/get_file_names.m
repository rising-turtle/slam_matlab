% Get file name, directory name and number of frame

function [g2o_result_dir_name, isam_result_dir_name, vro_dir_name, dynamic_dir_name, toro_dir_name] = get_file_names(dir_index, dynamic_index)

% Select Data Set
vro_file_name_list ={'data/2d/manhattan3500/manhattanOlson3500.g2o', 'data/2d/intel/intel.g2o','data/3d/sphere/sphere_bignoise_vertex3.g2o','data/3d/garage/parking-garage.g2o','data/3d/whitecane/','data/3d/whitecane/','data/3d/whitecane/','data/3d/whitecane/','data/3d/whitecane/','data/3d/whitecane/','data/3d/whitecane/','data/3d/whitecane/','data/3d/whitecane/','data/3d/whitecane/','data/3d/whitecane/','data/3d/whitecane/','data/3d/whitecane/'};
isam_result_file_name_list ={'results/isam/2d/manhattanOlson3500.opt','results/isam/2d/intel.opt','results/isam/3d/sphere_bignoise_vertex3.opt','results/isam/3d/parking-garage.opt','results/isam/3d/','results/isam/3d/','results/isam/3d/','results/isam/3d/','results/isam/3d/','results/isam/3d/','results/isam/3d/','results/isam/3d/','results/isam/3d/','results/isam/3d/','results/isam/3d/','results/isam/3d/','results/isam/3d/'};
g2o_result_file_name_list ={'results/g2o/2d/manhattanOlson3500.opt','results/g2o/2d/intel.opt','results/g2o/3d/sphere_bignoise_vertex3.opt','results/g2o/3d/parking-garage.opt','results/g2o/3d/','results/g2o/3d/','results/g2o/3d/','results/g2o/3d/','results/g2o/3d/','results/g2o/3d/','results/g2o/3d/','results/g2o/3d/','results/g2o/3d/','results/g2o/3d/','results/g2o/3d/','results/g2o/3d/','results/g2o/3d/'};
toro_file_name_list={'2D/w10000-odom','3D/sphere_smallnoise','3D/sphere_mednoise','3D/sphere_bignoise','data/3d/whitecane/','data/3d/whitecane/','data/3d/whitecane/','data/3d/whitecane/','data/3d/whitecane/','data/3d/whitecane/','data/3d/whitecane/','data/3d/whitecane/','data/3d/whitecane/','data/3d/whitecane/','data/3d/whitecane/','data/3d/whitecane/','data/3d/whitecane/'};

dynamic_name_list={'pitch_3degree','pitch_9degree','pan_3degree','pan_9degree','pan_30degree','pan_60degree','roll_3degree','roll_9degree','x_30mm','x_150mm','x_300mm','y_30mm','y_150mm','y_300mm','square_500','square_700','square_swing','square_1000','test'};
etas_name_list={'3th_straight','3th_swing','4th_straight','4th_swing','5th_straight','5th_swing'};
loops_name_list = {'bus','bus_3','bus_door_straight_150','bus_straight_150','data_square_small_100','eit_data_150','exp1','exp2','exp3','exp4','exp5','lab_80_dynamic_1','lab_80_swing_1','lab_it_80','lab_lookforward_4','s2','second_floor_150_not_square','second_floor_150_square','second_floor_small_80_swing','third_floor_it_150'};
kinect_tum_name_list = get_kinect_tum_dir_name();
loops2_name_list = get_loops2_filename();
sparse_feature_name_list = get_sparse_feature_filename();
swing_name_list = get_dir_name('swing'); %{'forward1','forward2','forward3','forward4','forward5','forward6'};
swing2_name_list = get_dir_name('swing2');
object_recognition_name_list = get_dir_name('object_recognition');
motive_name_list = get_dir_name('motive');
map_name_list=get_dir_name('map');

start_frame = [11 8 11 8 8 6 11 11 11 8 6 21 8 8 40 40 50 101];
finish_frame = [70 25 70 25 16 11 135 50 150 35 21 150 35 22 316 376 397 130]; %316
%nFrame = finish_frame(dynamic_data_index) - start_frame(dynamic_data_index) - 1;
%nFrame = 3920; %1253; %5468; %2399; %1253; %2440; %829; %270;

isam_result_dir_name = isam_result_file_name_list{dir_index};
g2o_result_dir_name = g2o_result_file_name_list{dir_index};
vro_dir_name = vro_file_name_list{dir_index};
toro_dir_name = toro_file_name_list{dir_index};

if dir_index == 5
    dynamic_dir_name = dynamic_name_list{dynamic_index};
elseif dir_index == 6
    dynamic_dir_name = etas_name_list{dynamic_index};
elseif dir_index == 7
    dynamic_dir_name = loops_name_list{dynamic_index};
elseif dir_index == 8
    dynamic_dir_name = kinect_tum_name_list{dynamic_index};
elseif dir_index == 9 || dir_index == 10
    dynamic_dir_name = loops2_name_list{dynamic_index};
elseif dir_index == 11
    dynamic_dir_name = sparse_feature_name_list{dynamic_index};
elseif dir_index == 12
    dynamic_dir_name = swing_name_list{dynamic_index};
elseif dir_index == 13
    dynamic_dir_name = swing2_name_list{dynamic_index};
elseif dir_index == 14
    dynamic_dir_name = motive_name_list{dynamic_index};
elseif dir_index == 15
    dynamic_dir_name = object_recognition_name_list{dynamic_index};
elseif dir_index == 16
    dynamic_dir_name = map_name_list{dynamic_index};
else
    dynamic_dir_name = 'none';
end
end