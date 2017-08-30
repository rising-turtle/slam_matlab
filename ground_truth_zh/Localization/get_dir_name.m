% Get directory name of each data se
%
% Author : Soonhac Hong (sxhong1@ualr.edu)
% Date : 4/4/13

function dir_name = get_dir_name(data_name)

switch data_name
    case'py_xy_data_sr4000'
        dir_name = {'0','y12_x-8_p-5.3_y5'};
    case 'c1'
        dir_name = {'0','y-3_p6_x100','y-12_p9_x300','y-6_p12_x500'};
    case 'c2'
        dir_name = {'0','y-6_p3_y200','y-9_p12_y400','y-12_p6_y600'};
    case 'c3'
        dir_name = {'0','y3_p12_x100','y6_p9_x200','y9_p6_x300','y12_p3_x400'};
    case 'c4'
        dir_name = {'0','y-3_p9_y300'};
    case 'm'
        dir_name={'pitch_3degree','pitch_9degree','pan_3degree','pan_9degree','pan_30degree','pan_60degree','roll_3degree','roll_9degree','x_30mm','x_150mm','x_300mm','y_30mm','y_150mm','y_300mm','square_500','square_700','square_swing','square_1000','test'};
    case 'etas'
        dir_name = {'3th_straight','3th_swing','4th_straight','4th_swing','5th_straight','5th_swing'};
    case 'loops'
        dir_name = {'bus','bus_3','bus_door_straight_150','bus_straight_150','data_square_small_100','eit_data_150','exp1','exp2','exp3','exp4','exp5','lab_80_dynamic_1','lab_80_swing_1','lab_it_80','lab_lookforward_4','s2','second_floor_150_not_square','second_floor_150_square','second_floor_small_80_swing','third_floor_it_150'};
    case 'loops2'
        dir_name = get_loops2_filename(); 
    case 'loops3'
        dir_name = {'exp1_etas_2nd','exp2_etas_2nd','exp3_biz_1st','exp4_biz_1st','exp5_biz_1st'}; 
    case 'sparse_feature'
        dir_name = get_sparse_feature_filename();
    case {'swing', 'swing2'}
        dir_name = get_swing_filename(); %{'forward1','forward2','forward3','forward4','forward5','forward6','forward7_10m','forward8_10m', 'forward9_10m','forward10_10m','forward11_10m','forward12_10m','forward13_10m','forward14_10m','forward15_10m','forward16_10m','revisiting1_10m','revisiting2_10m','revisiting3_10m'};
    case {'kinect_tum'}
        dir_name = get_kinect_tum_dir_name();
    case {'motive'}
        dir_name = get_motive_filename();
    case {'map'}
        dir_name = get_map_filename();
    case {'it'}
        dir_name = get_it_filename();
    case {'object_recognition'}
        dir_name = get_object_recognition_filename();
    otherwise
        dir_name = {'none'};
        
end

end