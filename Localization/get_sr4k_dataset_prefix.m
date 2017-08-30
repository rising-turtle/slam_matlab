function [prefix, confidence_read] = get_sr4k_dataset_prefix(data_name, dm)

% c1_dir_name = {'0','y-3_p6_x100','y-12_p9_x300','y-6_p12_x500'};
% c2_dir_name = {'0','y-6_p3_y200','y-9_p12_y400','y-12_p6_y600'};
% c3_dir_name = {'0','y3_p12_x100','y6_p9_x200','y9_p6_x300','y12_p3_x400'};
% c4_dir_name = {'0','y-3_p9_y300'};
% %m_dir_name={'x_500qc','pitch_10degree','pitch_3degree','pan_3degree','pan_10degree','x_1mm','x_10mm','x_5mm'}; %'pitch_500qc_700mm',
% m_dir_name={'pitch_3degree','pitch_9degree','pan_3degree','pan_9degree','pan_30degree','pan_60degree','roll_3degree','roll_9degree','x_30mm','x_150mm','x_300mm','y_30mm','y_150mm','y_300mm','square_500','square_700','square_swing','square_1000','test'};
% etas_dir_name = {'3th_straight','3th_swing','4th_straight','4th_swing','5th_straight','5th_swing'};
% loops_dir_name = {'bus','bus_3','bus_door_straight_150','bus_straight_150','data_square_small_100','eit_data_150','exp1','exp2','exp3','exp4','exp5','lab_80_dynamic_1','lab_80_swing_1','lab_it_80','lab_lookforward_4','s2','second_floor_150_not_square','second_floor_150_square','second_floor_small_80_swing','third_floor_it_150'};
% loops2_dir_name = get_loops2_filename(); %{'exp4_keyframes','bus','bus_3','bus_straight_150_keyframes'};
% sparse_feature_dir_name = get_sparse_feature_filename();

dir_name = get_dir_name(data_name);

confidence_read = 1;
global g_data_dir;
global g_data_prefix g_vo_data_dir
switch data_name
    case 'pitch'
        [prefix, err] = sprintf('../data/pitch_3_interval/d%d_%d/d%d',dm,dm*3-43,dm);
        %[prefix, err] = sprintf('../data/pitch_3_interval/d%d_%d',dm,dm*3-43);
    case 'pitch2'
        [prefix, err] = sprintf('../data/pitch2_3_interval/d%d_%d/d%d',dm,dm*3-15,dm);
    case 'pitch3'
        [prefix, err] = sprintf('../data/pitch3_3_interval_tilt_meter/d%d/d%d',dm,dm);
    case 'pitch4'
        [prefix, err] = sprintf('E:/data/pitch4_3_interval_vfless/d%d_%d/d%d',dm,dm*3-53,dm);
    case 'pitch5'
        [prefix, err] = sprintf('E:/data/pitch5_3_interval_vfless/d%d_%d/d%d',dm,dm*3-56,dm);
    case 'pitch6'
        [prefix, err] = sprintf('E:/data/pitch6_3_interval_vfless/d%d_%d/d%d',dm,dm*3-63,dm);
    case 'pitch8'
        [prefix, err] = sprintf('E:/data/pitch8_3_interval_vfless/d%d_%d/d%d',dm,dm*3-3,dm);
    case 'pitch9'
        [prefix, err] = sprintf('E:/data/pitch9_3_interval_vfless/d%d_%d/d%d',dm,dm*3-18,dm);
    case 'pitch10'
        [prefix, err] = sprintf('E:/data/pitch10_3_interval_vfless/d%d_%d/d%d',dm,dm*3-18,dm);
    case 'pitch11'
        [prefix, err] = sprintf('E:/data/pitch11_3_interval_vfless/d%d_%d/d%d',dm,dm*3-18,dm);
    case 'pitch12'
        [prefix, err] = sprintf('E:/data/pitch12_3_interval_vfless/d%d_%d/d%d',dm,dm*3-18,dm);
    case 'pitch_2_interval_blackout_noae'
        [prefix, err] = sprintf('F:/Soonhac/data/pitch_2_interval_blackout_noae/d%d_%d/d%d',dm,dm*2+8,dm);
    case 'pan'
        [prefix, err] = sprintf('../data/pan_3_interval/d%d_%d/d%d',dm,44-(dm-1)*3,dm);
    case 'pan2'
        [prefix, err] = sprintf('E:/data/pan2_3_interval_vfless/d%d_%d/d%d',dm,dm*3-24,dm);
    case 'pan3'
        [prefix, err] = sprintf('E:/data/pan3_3_interval_vfless/d%d_%d/d%d',dm,21-(dm-1)*3,dm);
    case 'pan4'
        [prefix, err] = sprintf('E:/data/pan4_3_interval_vfless/d%d_%d/d%d',dm,10-(dm-1)*3,dm);
    case 'pan5'
        [prefix, err] = sprintf('E:/data/pan5_3_interval_vfless/d%d_%d/d%d',dm,20-(dm-1)*3,dm);
    case 'pan7'
        [prefix, err] = sprintf('E:/data/pan7_3_interval_vfless/d%d_%d/d%d',dm,21-(dm-1)*3,dm);
    case 'roll'
        [prefix, err] = sprintf('../data/roll_3_interval/d%d_%d/d%d',dm,-9+(dm-1)*3,dm);
    case 'roll2'
        [prefix, err] = sprintf('E:/data/roll2_3_interval_vfless/d%d_%d/d%d',dm,21-(dm-1)*3,dm);
    case 'roll3'
        [prefix, err] = sprintf('E:/data/roll3_3_interval_vfless/d%d_%d/d%d',dm,-21+(dm-1)*3,dm);
    case 'roll4'
        [prefix, err] = sprintf('E:/data/roll4_3_interval_vfless/d%d_%d/d%d',dm,-20+(dm-1)*3,dm);
    case 'roll5'
        [prefix, err] = sprintf('E:/data/roll5_3_interval_vfless/d%d_%d/d%d',dm,-21+(dm-1)*3,dm);
    case 'x'
        [prefix, err] = sprintf('../data/x/x%d/frm',dm);
    case 'y'
        [prefix, err] = sprintf('../data/y/y%d/frm',dm);
    case 'x2'
        [prefix, err] = sprintf('../data/x2/d%d_%d/d%d',dm,100*(dm-1),dm);
    case 'y2'
        [prefix, err] = sprintf('../data/y2/d%d_%d/d%d',dm,100*(dm-1),dm);
    case 'c1'
        [prefix, err] = sprintf('../data/c1/d%d_%s/d%d',dm,dir_name{dm},dm);
    case 'c2'
        [prefix, err] = sprintf('../data/c2/d%d_%s/d%d',dm,dir_name{dm},dm);
    case 'c3'
        [prefix, err] = sprintf('../data/c3/d%d_%s/d%d',dm,dir_name{dm},dm);
    case 'c4'
        [prefix, err] = sprintf('../data/c4/d%d_%s/d%d',dm,dir_name{dm},dm);
    case 'py_xy_data_sr4000'
        file_prefix={'org','xypy'};
        [prefix, err] = sprintf('E:/Ye/py_xy_data_sr4000/d%d_%s/%s',dm,dir_name{dm},file_prefix{dm});
    case 'm'
        [prefix, err] = sprintf('../data/dynamic/%s/d1',dir_name{dm});
        if dm < 15
            confidence_read = 0;
        end
    case 'etas'
        [prefix, err] = sprintf('E:/data/etas/%s/d1',dir_name{dm});
    case 'loops'
        [prefix, err] = sprintf('E:/data/loops/%s/processed_data/d1',dir_name{dm});
    case 'loops2'
        [prefix, err] = sprintf('E:/data/Amir/processed_data/%s/d1',dir_name{dm});
    case 'loops3'
        [prefix, err] = sprintf('G:/Soonhac/data/loops3_original/%s/d1',dir_name{dm});
    case 'sparse_feature'
        [prefix, err] = sprintf('E:/data/sparse_feature/%s/processed_data/d1',dir_name{dm});
        %[prefix, err] = sprintf('E:/data/sparse_feature/%s/d1',dir_name{dm});
    case 'swing'
        %[prefix, err] = sprintf('E:/data/swing/%s/processed_data/d1',dir_name{dm});
        %[prefix, err] = sprintf('E:/data/swing/%s/d1',dir_name{dm});
        [prefix, err] = sprintf('D:/Soonhac/Data/sr4k/swing/%s/d1',dir_name{dm});
    case 'swing2'
        [prefix, err] = sprintf('E:/data/swing/%s/processed_data_9/d1',dir_name{dm});
    case 'motive'
        %[prefix, err] = sprintf('E:/data/motive/%s/d1',dir_name{dm});
        %[prefix, err] = sprintf('E:/data/motive/%s/processed_data/d1',dir_name{dm});
        [prefix, err] = sprintf('D:/Soonhac/Data/sr4k/motive/%s/d1',dir_name{dm});
    case 'creative' 
        [prefix, err] = sprintf(strcat(g_data_dir, strcat('/',g_data_prefix))); % for running demo
    case 'vro_test'
        [prefix, err] = sprintf(strcat(g_vo_data_dir, strcat('/', g_data_prefix)));
    case 'smart_cane'
        %[prefix, err] = sprintf('D:/Soonhac/Data/sr4k/smart_cane/exp1/d1');
        %[prefix, err] = sprintf('D:/Soonhac/Data/sr4k/smart_cane/exp2/d1'); % for running demo
        %[prefix, err] = sprintf('F:/co-worker/soonhac/workstation_8.10.2014/d1'); % for running demo
 
        [prefix, err] = sprintf(strcat(g_data_dir, strcat('/',g_data_prefix))); % for running demo
        %[prefix, err] = sprintf('D:/Soonhac/Data/sr4k/smart_cane/example/d1');
        %[prefix, err] = sprintf('C:/SC-DATA-TRANSFER/d1');  % Speed up using SSD
        %[prefix, err] = sprintf('D:/Soonhac/Data/sr4k/smart_cane/binary_data/d1');
    case 'map'
        %[prefix, err] = sprintf('D:/Soonhac/Data/sr4k/smart_cane/exp1/d1');
        [prefix, err] = sprintf('D:/Soonhac/Data/sr4k/map/%s/d1',dir_name{dm});
    case 'it'
        %[prefix, err] = sprintf('D:/Soonhac/Data/sr4k/smart_cane/exp1/d1');
        [prefix, err] = sprintf('D:/Soonhac/Data/sr4k/it/%s/d1',dir_name{dm});
    case 'object_recognition'
        [prefix, err] = sprintf('E:/data/object_recognition/%s/f1',dir_name{dm});
    case 'seg_ex'
        [prefix, err] = sprintf('../Segmentation/data/example');
    case 'sample'
        [prefix, err] = sprintf('../data/sample/test/t1');
    case 'chansic'
        [prefix, err] = sprintf('D:/soonhac/Private/David/photo/chansic');
    otherwise
        disp('Data cannot be found');
        return;
end

end