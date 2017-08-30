% Batch computation of euler angle and translation for statistical analysis
% Origital code was statistics.m 
%
% Author : Soonhac Hong (sxhong1@ualr.edu)
% Date : 3/10/11

clear;
localization_addpath;

angle_interval = 3; % degree
translation_interval = 305; %mm
translation_interval_2 = 100; %mm
trnaslation_interval_2_correction = 0; %mm
% c1_movement={[-3 6 100],[-12 9 300],[-6 12 500]}; % [yaw pitch x] [degree mm mm]
% c2_movement={[-6 3 200],[-9 12 400],[-12 6 600]}; % [yaw pitch y] [degree mm mm]
% c3_movement={[3 12 100],[6 9 200],[9 6 300],[12,3,400]}; % [yaw pitch x] [degree mm mm]
% c4_movement={[-3 9 300]};% [yaw pitch y] [degree mm mm]
%Compensated by pan/tilt kinematics
c1_movement={[-3 6 101],[-12 9 304],[-6 12 501]}; % [yaw pitch x] [degree mm mm]
c2_movement={[-6 3 196],[-9 12 386],[-12 6 593]}; % [yaw pitch y] [degree mm mm]
c3_movement={[3 12 99],[6 9 198],[9 6 297],[12,3,395]}; % [yaw pitch x] [degree mm mm]
c4_movement={[-3 9 290]};% [yaw pitch y] [degree mm mm]

MAX_FRAME = 1000; %2000;
nFrame = 540; %1000; %240; %60; %norminal frame
rFrame = 0;  %real frame
r2d=180.0/pi;
scale = 1;

image_name_list={'intensity','depth','fuse','fuse_std'};
data_name_list={'pitch', 'pan', 'roll','x2', 'y2', 'c1', 'c2','c3','c4','m','etas','loops2','kinect_tum','sparse_feature','loops','swing','swing2','object_recognition','motive'}; % 'x', 'y', 
% fe_name_list={'sift','sift_ransac_limit_14000_14','sift_ransac_stdcrt','sift_ransac_stdcrt_15p','sift_ransac_maxlimit','sift_ransac_20000','sift_ransac_stdctr_gc','sift_ransac_stdctr_stdev','sift_ransac_450','sift_ransac_350','sift_ransac_stable','surf','surf_ransac_limit_14000_11','surf_ransac_stdcrt','surf_ransac_stdctr_14p','surf_ransac_stdctr_stdev','surf_ransac_20000','surf_ransac_stdcrt_stdev_linear','surf_ransac_350','surf_ransac_300','surf_ransac_200','surf_ransac_stc_gc'};
% 'sift_int_ransac_stdcrt_iter_tictoc_total_th1',
% 'sift_int_ransac_stdcrt_iter_tictoc_total_constraints_confidence'
% 'sift_int_ransac_stdcrt_gc_num_em_error_class_tictoc_total',
% 'sift_i_r_s_i_t_t_c_i_adapthisteq_cf_cov_featureidxfix_fast_fast_gframe'
% 'sift_i_r_s_i_t_t_c_i_a_c_c_r_cf05_icp9_batch_featureidxfix_tol01_maxstep_fast_fast_dist2_test',
% 'sift_i_r_s_i_t_t_c_i_a_c_c_featureidxfix_fast_fast_dist2_min40_histeq',
% 'sift_i_r_s_i_t_t_c_i_a_c_c_featureidxfix_fast_fast_dist2_min40_lc',
% 'sift_i_r_s_i_t_t_c_i_a_c_c_featureidxfix_fast_fast_dist2_nobpc_svde6'
fe_name_list_int={'sift_i_r_s_i_t_t_c_i_a_c_c_featureidxfix_fast_fast_dist2_nobpc','sift_i_r_s_i_t_t_c_i_a_c_c_r_cf05_icp6_featureidxfix_maxstep_fast_fast_dist2_loadicp','sift_i_r_s_i_t_t_c_i_a_c_c_r_cf05_icp9_batch_featureidxfix_tol04_maxstep_fast_fast_dist2_loadicp','sift_int_ransac_stdcrt_iter_tictoc_total_confidence_indexplus1_adapthisteq_cf_cov_ransac_cf05_icp6_featureidxfix_10step','sift_i_r_s_i_t_t_c_i_a_c_c_r_cf05_icp9_batch_featureidxfix_tol01_maxstep_fast_fast_dist','sift_int_ransac_stdcrt_iter_tictoc_total_confidence_indexplus1_adapthisteq_cf_cov','sift_int_ransac_stdcrt_iter_tictoc_total_confidence_indexplus1','sift_int_ransac_stdcrt_gc_num_aa_tictoc_total_constraints_confidence_indexplus1','int_tictoc_total_confidence_icp7_intensity','sift_int_ransac_stdcrt_gc_num_aa_tictoc_total_constraints_confidence_icp6_indexplus1','sift_int_ransac_stdcrt_gc_num_aa_tictoc_total_constraints_confidence_indexplus1_test','sift_int_ransac_stdcrt_gc_num_aa_tictoc_total_constraints_confidence','surf_int_ransac_stdcrt_iter_tictoc_total_thd_0001', 'sift_int_ransac_stdcrt_gc_num_em_error_class_tictoc_total','sift_int_ransac_stdcrt_iter_tictoc_total','sift_int_ransac_stdcrt_iter_tictoc_total_no_gaussian_range','sift_int_ransac_stdcrt_iter_tictoc_total','surf_int_ransac_stdcrt_iter_tictoc_total_thd_000001','sift_int_ransac_stdcrt_gc_num_em_error_class_tictoc_total','sift_int_ransac_stdcrt_gc_num_em_error_class_etime_total','sift_int_ransac_stdcrt_iter_etime_total','sift_int_ransac_stdcrt_confidence_etime_median','sift_int_ransac_stdcrt_gc_num_em_error_class_etime','sift_int_gc_num_em_error_class_etime','sift_int_ransac_stdcrt_gc_num_aa_error_etime', 'sift_int_ransac_3points_stdcrt_iter_etime','sift_int_ransac_3points_stdcrt', 'sift_int_gc_num_em_llthreshold_001', 'sift_int_ransac_stdcrt_icp_match','sift_int_ransac_stdcrt_12_kc','sift_int_ransac_stdcrt_gc_msdtc','surf_int','surf_int_ransac_stdcrt','surf_int_ransac_stdcrt_13','surfcpp_int','surfcpp_int_ransac_stdcrt'}; %'sift_int_ransac_350','surf_int_ransac_200'
%fe_name_list_int={'sift_i_r_s_i_t_t_c_i_a_c_c_featureidxfix_fast_fast_dist2_10step','sift_i_r_s_i_t_t_c_i_a_c_c_r_cf05_icp6_featureidxfix_maxstep_fast_fast_dist2_loadicp_10step','sift_i_r_s_i_t_t_c_i_a_c_c_r_cf05_icp9_batch_f_tol01_fast_fast_dist2_loadicp_10step'};
filter_list={'none','median','gaussian','median5','gaussian5','gaussian_edge_std'};
boarder_cut_off = 0; %;    % percentage of cut off in both horizaontal borders
value_list ={'int', 'double'};

image_name = image_name_list{1}; 
data_name=data_name_list{19};  % 11 = 'etas', 12 = 'loops2', 13='kinect_tum', 14 = 'sparse_feature', 15='loops', 16='swing', 17='swing2', 18='object_recognition', 19='motive'
fe_name=fe_name_list_int{1};    %8
icp_mode = 'icp_ch'; %'icp_ch';'icp'; %
filter_name=filter_list{3};
value_type=value_list{1};
ransac_iteration_limit = 0; %20000; %14000; 0 = standard termination criterion
valid_ransac_num = 3;
long_format_name = 'none'; %fe_name;
loop_interval = 0; %580
feature_dis = 0; % 1 = display features; 0 = display no features
pose_std_on = 1; % 1 = save pose standard deviation on each estimation; 0 = don't save
max_constraints = 50; %200; %50; %30; %50; %7;
consecutive_error_count_threshold = 1; %190;
is_10M_data = 0; % 1 if 10M SR4000; 0 if 5M SR4000


switch data_name
    case {'pitch','pitch2'}
        maxData = 28; % 11
        inc_max = 6; %9; %9; %11;   % 3 * 11 = 33 << 34 degree of FOV
        unit='degree';
        interval = angle_interval;
        sequence_data = false;
    case 'pan'
        maxData = 29;
        inc_max = 6; %14;   % 3 * 14 = 42 << 43 degree of FOV
        unit='degree';
        interval =angle_interval;
        sequence_data = false;
    case 'roll'
        maxData = 9;
        inc_max = 6; %6; %14;   % 3 * 14 = 42 << 43 degree of FOV
        unit='degree';
        interval = angle_interval;
        sequence_data = false;
    case 'x'
        maxData = 13;
        inc_max = 2; %maxData-1;'sift_int_ransac_stdcrt_icp'
        unit='mm';
        interval = translation_interval;
        sequence_data = false;
    case 'y'
        maxData = 11;
        inc_max = 2; %maxData-1;
        unit='mm'; cputime - t_svd;
        interval = translation_interval;
        sequence_data = false;
    case 'x2'
        maxData = 9;
        inc_max = 5; %7; %maxData-1;
        unit='mm';
        interval = translation_interval_2;
        sequence_data = false;
    case 'y2'
        maxData = 9;
        inc_max = 5; %8; %maxData-1;
        unit='mm';
        interval = translation_interval_2;
        sequence_data = false;
    case 'c1'
        maxData = 4;
        inc_max = maxData-1;
        unit={'y-3_p6_x100','y-6_p12_x500','y-12_p9_x300'};
        sequence_data = false;
        interval = c1_movement;
    case 'c2'
        maxData = 4;
        inc_max = maxData-1;
        unit={'y-6_p3_y200','y-9_p12_y400','y-12_p6_y600'};
        sequence_data = false;
        interval = c2_movement;
    case 'c3'
        maxData = 5;
        inc_max = maxData-1;
        unit={'y3_p12_x100','y6_p9_x200','y9_p6_x300','y12_p3_x400'};
        sequence_data = false;
        interval = c3_movement;
    case 'c4'
        maxData = 2;
        inc_max = maxData-1;
        unit={'y-3_p9_y300'};
        sequence_data = false;
        interval = c4_movement;
    case 'm'
        maxData = 2;
        inc_max = maxData-1;
        %unit={'x_500qc','pitch_10degree','pitch_3degree','pan_3degree','pan_10degree','x_1mm','x_10mm','x_5mm'};
        unit={'pitch_3degree','pitch_9degree','pan_3degree','pan_9degree','pan_30degree','pan_60degree','roll_3degree','roll_9degree','x_30mm','x_150mm','x_300mm','y_30mm','y_150mm','y_300mm','square_500','square_700','square_swing','square_1000','test'};
        %nFrame_li289_frame_abs_intensity_sift_int_ransac_stdcrt_gc_num_aa_tictoc_total_constraints_confidence_gaussian_0st=[143 34 76 90 38 135 24 39];
        nFrame_list= [83 35 86 36 26 16 157 60 161 42 25 175 42 28 500 700 1000 1000 140];
        start_frame = [11 8 11 8 8 6 11 11 11 8 6 21 8 8 40 40 50 40 101];
        finish_frame = [70 25 70 25 16 11 135 50 150 35 21 150 35 22 450 650 850 770 130];
        interval = 0;
        dynamic_data_index = 18;            % 15:square_500, 16:square_700, 17:square_swing 18: square_1000
        sequence_data = true;
    case 'etas'
        maxData = 2;
        inc_max = maxData-1;
        %unit={'x_500qc','pitch_10degree','pitch_3degree','pan_3degree','pan_10degree','x_1mm','x_10mm','x_5mm'};
        unit={'3th_straight','3th_swing','4th_straight','4th_swing','5th_straight','5th_swing'};
        %nFrame_list=[143 34 76 90 38 135 2/media/Data/soonhac/Project/PNBD/SW/ASEE/GraphSLAM4 39];
        nFrame_list= [1000 1500 1000 2000 2000 2000];
        start_frame = [10 10 10 10 10 10];
        finish_frame = [990 1490 990 1990 1900 1900];
        interval = 0;
        dynamic_data_index =1;    % Remain : 2, 4, 5, 6  
        sequence_data = true;
    case 'loops'
        maxData = 2;
        inc_max = maxData-1;
        unit={'bus','bus_3','bus_door_straight_150','bus_straight_150','data_square_small_100','eit_data_150','exp1','exp2','exp3','exp4','exp5','lab_80_dynamic_1','lab_80_swing_1','lab_it_80','lab_lookforward_4','s2','second_floor_150_not_square','second_floor_150_square','second_floor_small_80_swing','third_floor_it_150'};
        nFrame_list= [2800 1400 2500 2500 1200 1250 1400 1750 1750 1750 1750 1600 534 1500 1800 1500 1300 2800 2400 2800];
        start_frame = [90 10 10 50 40 60 40 50 40 40 45 0 18 0 0 0 50 40 50 30];
        finish_frame = [2500 1370 2500 2500 1130 1250 1400 1640 1700 1670 1750 0 534 0 0 0 1250 2710 2390 2670];
        interval = 0;
        dynamic_data_index = 13;    % Remain : 2, 4, 5, 6  
        start_frame_interval = start_frame(dynamic_data_index) - 1;
        sequence_data = true;
    case 'loops2'
        maxData = 2;
        inc_max = maxData-1;
        unit=get_loops2_filename(); %{'exp4','bus','bus_3','bus_door_straight_150'};
        nFrame_list= [832 584 832 834 651 932 481 582 701 460 370 241];%[584 0 0 834];
        start_frame = [1 1 1 1 1 1 1 1 1 1 1 1 1];
        finish_frame = [832 584 832 834 651 932 481 582 701 460 370 241];%[584 0 0 834];
        interval = 0;
        dynamic_data_index = 11;     %7,10,11
        start_frame_interval = start_frame(dynamic_data_index) - 1;
        sequence_data = true;
    case 'sparse_feature'
        maxData = 2;
        inc_max = maxData-1;
        unit=get_sparse_feature_filename(); %{'exp4','bus','bus_3','bus_door_straight_150'};
        nFrame_list= [234 200 434 367 277 415 166 208 237 355 710 190];
        start_frame = [1 1 1 1 1 1 1 1 1 1 582 1];
        finish_frame = [234 200 434 367 277 415 166 208 237 355 710 190];%[584 0 0 834];
        interval = 0;
        dynamic_data_index = 11;     
        start_frame_interval = start_frame(dynamic_data_index) - 1;
        sequence_data = true;
    case 'swing' % subsampled by 3 step from original swing data
        maxData = 2;
        inc_max = maxData-1;
        unit=get_dir_name(data_name); %get_sparse_feature_filename(); %{'exp4','bus','bus_3','bus_door_straight_150'};
        nFrame_list= [271 324 600 534 530 334 381 381 381 381 381 301 367 250 247 251 222 247 251 304 401 391 491 448 385 488];
        start_frame = [1 275 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];
        finish_frame = [271 324 600 534 530 334 381 381 381 381 381 301 367 250 247 251 222 247 251 304 401 391 491 448 385 488];%[584 0 0 834];
        interval = 0;
        dynamic_data_index = 8;     %23,24,25,26
        start_frame_interval = start_frame(dynamic_data_index) - 1;
        sequence_data = true;
    case 'swing2'  % subsampled by 9 step from original swing data
        maxData = 2;
        inc_max = maxData-1;
        unit=get_dir_name(data_name); %get_sparse_feature_filename(); %{'exp4','bus','bus_3','bus_door_straight_150'};
        nFrame_list= [101 130 223 178 212 112];
        start_frame = [1 1 1 1 1 1];
        finish_frame = [101 130 223 178 212 112];%[584 0 0 834];
        interval = 0;
        dynamic_data_index = 3;     
        start_frame_interval = start_frame(dynamic_data_index) - 1;
        sequence_data = true;
    case 'object_recognition'
        maxData = 2;
        inc_max = maxData-1;
        unit=get_dir_name(data_name); %get_sparse_feature_filename(); %{'exp4','bus','bus_3','bus_door_straight_150'};
        nFrame_list= [1000 500 500 500 400 400 400 850 850 800 850];
        start_frame = [1 347 1 1 1 1 1 1 1 1 1];
        finish_frame = [1000 500 500 500 400 400 400 850 850 800 850];%[584 0 0 834];
        interval = 0;
        dynamic_data_index = 11;  % 9, 10, 11   
        start_frame_interval = start_frame(dynamic_data_index) - 1;
        sequence_data = true;
    case 'motive'  % subsampled by 9 step from original swing data
        maxData = 2;
        inc_max = maxData-1;
        unit=get_dir_name(data_name); %get_sparse_feature_filename(); %{'exp4','bus','bus_3','bus_door_straight_150'};
        nFrame_list= [84 147 0 0 0 0 0 0 0 0 0 186];
        start_frame = [1 1 1 1 1 1 1 1 1 1 1 1];
        finish_frame = [84 147 0 0 0 0 0 0 0 0 0 186];%[584 0 0 834];
        interval = 0;
        dynamic_data_index = 12;     
        start_frame_interval = start_frame(dynamic_data_index) - 1;
        sequence_data = true;
    case 'kinect_tum'
        maxData = 2;
        inc_init = 1;
        inc_max = maxData-1;
        %unit={'x_500qc','pitch_10degree','pitch_3degree','pan_3degree','pan_10degree','x_1mm','x_10mm','x_5mm'};
        unit=get_kinect_tum_dir_name();
        %nFrame_list=[143 34 76 90 38 135 24 39];
        nFrame_list= [798 1245 3359 5182];
        start_frame = [1 1 1 1];
        finish_frame = [798 1245 3359 5182];
        interval = 0;
        dynamic_data_index = 2; %15;
        sequence_data = true;
    otherwise
        disp('Data name is unknown.');
        return;
end

for inc = 1: inc_max
    inc
    %inc=input('Enter interval (n -- 3*n degree):');
    %pfp=fopen('pose.dat', 'w');
    %efp=fopen('error.dat', 'w');
    maxDegree = 1; %maxData - inc; %inc * 3;
    if maxDegree < 1 %inc*floor(maxData/inc)'sift_int_ransac_stdcrt_iter_tictoc_total_constraints'
        fprintf('WARNING : Interval is out of range [0 - %d]\n',maxData-1);  %maxDegree = inc*floor(maxData/inc)-1;
        return;
    end
    
    %if strcmp(data_name, 'm') || strcmp(data_name, 'etas') || strcmp(data_name, 'loops') || strcmp(data_name, 'kinect_tum') || strcmp(data_name, 'loops2') || strcmp(data_name, 'sparse_feature') || strcmp(data_name, 'swing')
    if sequence_data == true
        %         nFrame = nFrame_list(dynamic_data_index) - 1;
        nFrame = finish_frame(dynamic_data_index) - start_frame(dynamic_data_index) - 1 - loop_interval;
        %nFrame = 10; %35;
    end
    
    for k=1:maxDegree
        nk=k; %(k-1)/inc+1
        
        %if strcmp(data_name, 'm') || strcmp(data_name, 'etas') || strcmp(data_name, 'loops') || strcmp(data_name, 'kinect_tum') || strcmp(data_name, 'loops2') || strcmp(data_name, 'sparse_feature') || strcmp(data_name, 'swing')
        if sequence_data == true
            k = dynamic_data_index;
        end
        
        switch data_name
            case {'c1', 'c2', 'c3', 'c4'}
                error_file_name = sprintf('result/%s/%s/%d_frame_abs_%s_%s_%s_%d.dat',data_name,unit{inc},rFrame,image_name,fe_name,filter_name,boarder_cut_off);
                std_file_name = sprintf('result/%s/%s/%d_frame_abs_%s_%s_%s_%d_std.dat',data_name,unit{inc},rFrame,image_name,fe_name,filter_name,boarder_cut_off);
            case {'m'}
                error_file_name = sprintf('result/%s/%s/%d_frame_abs_%s_%s_%s_%d.dat',data_name,unit{dynamic_data_index},nFrame,image_name,fe_name,filter_name,boarder_cut_off);
                feature_points_file_name = sprintf('result/%s/%s/%d_frame_abs_%s_%s_%s_%d_feature_points.dat',data_name,unit{dynamic_data_index},nFrame,image_name,fe_name,filter_name,boarder_cut_off);
            case {'etas','loops','kinect_tum','loops2','sparse_feature','swing','swing2','object_recognition','motive'}
                error_file_name = sprintf('result/%s/%s/%d_frame_abs_%s_%s_%s_%d.dat',data_name,unit{dynamic_data_index},nFrame,image_name,fe_name,filter_name,boarder_cut_off);
                pose_std_file_name = sprintf('result/%s/%s/%d_frame_abs_%s_%s_%s_%d_pose_std.dat',data_name,unit{dynamic_data_index},nFrame,image_name,fe_name,filter_name,boarder_cut_off);
                feature_points_file_name = sprintf('result/%s/%s/%d_frame_abs_%s_%s_%s_%d_feature_points.dat',data_name,unit{dynamic_data_index},nFrame,image_name,fe_name,filter_name,boarder_cut_off);
            otherwise
                error_file_name = sprintf('result/%s/%d_%s/%d_frame_abs_%s_%s_%s_%d.dat',data_name,inc*interval,unit,rFrame,image_name,fe_name,filter_name,boarder_cut_off);
                std_file_name = sprintf('result/%s/%d_%s/%d_frame_abs_%s_%s_%s_%d_std.dat',data_name,inc*interval,unit,rFrame,image_name,fe_name,filter_name,boarder_cut_off);
        end
        
        efd = fopen(error_file_name,'w');
        fp_fd = fopen(feature_points_file_name,'w');
        if pose_std_on == 1
            efd_pose_std = fopen(pose_std_file_name,'w');
        end
        
        
        total_tr = [];
        for s = 1 : nFrame
            rFrame = 0;
            frame_index = [];
            phi=[];
            theta=[];
            psi=[];
            trans=[];
            error=[];
            elapsed=[];
            match_num=[];
            feature_points={};
            pose_std = [];
            consecutive_error_count = 0;
            for j=1:MAX_FRAME %(nFrame + addFrame)
                [k, s, j]
%                 if s == 212
%                     disp('debug');
%                 end
                %s = 709
                %j = 9
                %if strcmp(data_name, 'm') || strcmp(data_name, 'etas') || strcmp(data_name, 'loops') || strcmp(data_name, 'kinect_tum') || strcmp(data_name, 'loops2') || strcmp(data_name, 'sparse_feature') || strcmp(data_name, 'swing')
                if sequence_data == true
                    %jFrame = finish_frame(dynamic_data_indexlocalization_sift_ransac_limit) - start_frame(dynamic_data_index) - 1 - (s-1);
                    if nFrame - s > max_constraints
                        jFrame = max_constraints;
                    else
                        jFrame = nFrame-s;
                    end
                    
                    %if dynamic_data_index == 15
                    sframe = start_frame(dynamic_data_index) + s - 1;
                    %else
                    %    sframe = start_frame(dynamic_data_index);
                    %end
                    next_frame = j + loop_interval; % + 580;
                else
                    sframe = 1;
                end
                switch fe_name
                    case {'sift', 'sift_int'}
                        switch image_name
                            case {'depth','intensity'}
                                [phi(j), theta(j), psi(j), trans(:,j), error(j), elapsed(:,j), match_num(:,j)]=localization_sift(image_name, data_name, filter_name, boarder_cut_off, scale, value_type, k, inc, j);
                            case {'fuse','fuse_std'}
                                [phi(j), theta(j), psi(j), trans(:,j), error(j), elapsed(:,j), match_num(:,j)]=localization_fuse_sift(image_name, data_name, filter_name, boarder_cut_off, ransac_iteration_limit, valid_ransac_num, scale, value_type, k, inc, j); %(image_name, data_name, filter_name, boarder_cut_off, k, inc, j);
                        end
                    case {'surf','surf_int'}
                        [phi(j), theta(j), psi(j), trans(:,j), error(j), elapsed(:,j), match_num(:,j)]=localization_surf(image_name, data_name, filter_name, boarder_cut_off, scale, value_type, k, inc, j);
                    case {'surfcpp_int','surfcpp_int_ransac_stdcrt'}
                        [phi(j), theta(j), psi(j), trans(:,j), error(j), elapsed(:,j), match_num(:,j)]=localization_surfcpp_ransac_limit(image_name, data_name, filter_name, boarder_cut_off, ransac_iteration_limit, scale, value_type, k, inc, j);
                    case {'surf_int_ransac_stdcrt_iter_tictoc_total_thd_000001','surf_int_ransac_stdcrt_iter_tictoc_total_thd_0001','surf_int_ransac_stdcrt_iter_tictoc_total','surf_ransac_limit_14000_11','surf_ransac_stdctr_14p','surf_ransac_stdcrt','surf_ransac_stdctr_stdev','surf_ransac_stdctr_stdev','surf_ransac_20000','surf_ransac_stdcrt_stdev_linear','surf_ransac_350','surf_ransac_300','surf_ransac_200','surf_ransac_stc_gc','surf_int_ransac_stdcrt','surf_int_ransac_200','surf_int_ransac_stdcrt_13','surf_int_ransac_stdcrt_t2'}
                        [phi(j), theta(j), psi(j), trans(:,j), error(j), elapsed(:,j), match_num(:,j)]=localization_surf_ransac_limit(image_name, data_name, filter_name, boarder_cut_off, ransac_iteration_limit, valid_ransac_num, scale, value_type, k, inc, j);
                    case {'sift_int_ransac_stdcrt_iter_tictoc_total_confidence_indexplus1','sift_int_ransac_stdcrt_iter_tictoc_total_constraints_confidence_intensity_test', 'sift_int_ransac_stdcrt_iter_tictoc_total_constraints_confidence_intensity', 'sift_int_ransac_stdcrt_iter_tictoc_total_constraints','sift_int_ransac_stdcrt_iter_tictoc_total_th4','sift_int_ransac_stdcrt_iter_tictoc_total_th1','sift_int_ransac_stdcrt_iter_tictoc_total_no_gaussian_range', 'sift_int_ransac_stdcrt_iter_tictoc_total', 'sift_int_ransac_stdcrt_iter_etime_total','sift_int_ransac_3points_stdcrt_iter_etime','sift_int_ransac_stdcrt_iter_etime','sift_int_ransac_3points_stdcrt_etime','sift_int_ransac_stdcrt_etime','sift_ransac_limit_14000_14','sift_ransac_stdcrt','sift_ransac_stdcrt_15p','sift_ransac_maxlimit','sift_ransac_20000','sift_ransac_stdctr_gc','sift_ransac_stdctr_stdev','sift_ransac_450','sift_ransac_350','sift_ransac_stable','sift_int_ransac_stdcrt','sift_int_ransac_350','sift_int_ransac_stdcrt_12','sift_int_ransac_stdcrt_12_kc','sift_int_ransac_3points_stdcrt'}
                        switch image_name
                            case {'depth','intensity'}
                                [phi(j), theta(j), psi(j), trans(:,j), error(j), elapsed(:,j), match_num(:,j), feature_points{j}]=localization_sift_ransac_limit(image_name, data_name, filter_name, boarder_cut_off, ransac_iteration_limit, valid_ransac_num, scale, value_type, k, inc, next_frame, sframe, feature_dis);
                            case {'fuse','fuse_std'}
                                [phi(j), theta(j), psi(j), trans(:,j), error(j), elapsed(:,j), match_num(:,j)]=localization_fuse_sift(image_name, data_name, filter_name, boarder_cut_off, ransac_iteration_limit, valid_ransac_num, scale, value_type, k, inc, j, sframe); %(image_name, data_name, filter_name, boarder_cut_off, k, inc, j);
                        end
                    case {'sift_int_ransac_stdcrt_iter_tictoc_total_confidence_indexplus1_adapthisteq_cf_cov_featureidxfix_fast','sift_int_ransac_stdcrt_iter_tictoc_total_confidence_indexplus1_adapthisteq_cf_cov_featureidxfix_fast_maxstep','sift_int_ransac_stdcrt_iter_tictoc_total_confidence_indexplus1_adapthisteq_cf_cov_maxstep_featureidxfix', 'sift_int_ransac_stdcrt_iter_tictoc_total_confidence_indexplus1_adapthisteq_cf_cov'}
                        [phi(j), theta(j), psi(j), trans(:,j), error(j), elapsed(:,j), match_num(:,j), feature_points{j}, pose_std(:,j)]=localization_sift_ransac_limit_cov_fast(image_name, data_name, filter_name, boarder_cut_off, ransac_iteration_limit, valid_ransac_num, scale, value_type, k, inc, next_frame, sframe, feature_dis);
                    case {'sift_i_r_s_i_t_t_c_i_adapthisteq_cf_cov_featureidxfix_fast_fast'}
                        [phi(j), theta(j), psi(j), trans(:,j), error(j), elapsed(:,j), match_num(:,j), feature_points{j}, pose_std(:,j)]=localization_sift_ransac_limit_cov_fast_fast(image_name, data_name, filter_name, boarder_cut_off, ransac_iteration_limit, valid_ransac_num, scale, value_type, k, inc, next_frame, sframe, feature_dis);
                    case {'sift_i_r_s_i_t_t_c_i_adapthisteq_cf_cov_featureidxfix_fast_fast_gframe'}
                        [phi(j), theta(j), psi(j), trans(:,j), error(j), elapsed(:,j), match_num(:,j), feature_points{j}, pose_std(:,j)]=localization_sift_ransac_limit_cov_fast_fast_gframe(image_name, data_name, filter_name, boarder_cut_off, ransac_iteration_limit, valid_ransac_num, scale, value_type, k, inc, next_frame, sframe, feature_dis);
                    case {'sift_i_r_s_i_t_t_c_i_a_c_c_featureidxfix_fast_fast_dist_min40','sift_i_r_s_i_t_t_c_i_a_c_c_featureidxfix_fast_fast_dist_lc_min40','sift_i_r_s_i_t_t_c_i_a_c_c_featureidxfix_fast_fast_dist'}
                        [phi(j), theta(j), psi(j), trans(:,j), error(j), elapsed(:,j), match_num(:,j), feature_points{j}, pose_std(:,j)]=localization_sift_ransac_limit_cov_fast_fast_dist(image_name, data_name, filter_name, boarder_cut_off, ransac_iteration_limit, valid_ransac_num, scale, value_type, k, inc, next_frame, sframe, feature_dis);
                    case {'sift_i_r_s_i_t_t_c_i_a_c_c_featureidxfix_fast_fast_dist2_min40_histeq','sift_i_r_s_i_t_t_c_i_a_c_c_featureidxfix_fast_fast_dist2_min40_lc','sift_i_r_s_i_t_t_c_i_a_c_c_featureidxfix_fast_fast_dist2_min40', 'sift_i_r_s_i_t_t_c_i_a_c_c_featureidxfix_fast_fast_dist2_10step'}
                        [phi(j), theta(j), psi(j), trans(:,j), error(j), elapsed(:,j), match_num(:,j), feature_points{j}, pose_std(:,j)]=localization_sift_ransac_limit_cov_fast_fast_dist2(image_name, data_name, filter_name, boarder_cut_off, ransac_iteration_limit, valid_ransac_num, scale, value_type, k, inc, next_frame, sframe, sequence_data, is_10M_data, feature_dis);
                    case {'sift_i_r_s_i_t_t_c_i_a_c_c_featureidxfix_fast_fast_dist2_nobpc'}
                        [phi(j), theta(j), psi(j), trans(:,j), error(j), elapsed(:,j), match_num(:,j), feature_points{j}, pose_std(:,j)]=localization_sift_ransac_limit_cov_fast_fast_dist2_nobpc(image_name, data_name, filter_name, boarder_cut_off, ransac_iteration_limit, valid_ransac_num, scale, value_type, k, inc, next_frame, sframe, sequence_data, is_10M_data, feature_dis);
                    case {'sift_i_r_s_i_t_t_c_i_a_c_c_featureidxfix_fast_fast_dist2_nobpc_svde6'}
                        [phi(j), theta(j), psi(j), trans(:,j), error(j), elapsed(:,j), match_num(:,j), feature_points{j}, pose_std(:,j)]=localization_sift_ransac_limit_cov_fast_fast_dist2_nobpc_svde6(image_name, data_name, filter_name, boarder_cut_off, ransac_iteration_limit, valid_ransac_num, scale, value_type, k, inc, next_frame, sframe, sequence_data, is_10M_data, feature_dis);
                    case {'sift_i_r_s_i_t_t_c_i_adapthisteq_cf_cov_ransac_cf05_icp9_batch_featureidxfix_tol01_maxstep','sift_int_ransac_stdcrt_iter_tictoc_total_confidence_indexplus1_adapthisteq_cf_cov_ransac_cf05_icp6_featureidxfix_10step'}
                        [phi(j), theta(j), psi(j), trans(:,j), error(j), elapsed(:,j), match_num(:,j), feature_points{j}, pose_std(:,j)]=localization_sift_ransac_limit_icp2_cov_fast(image_name, data_name, filter_name, boarder_cut_off, ransac_iteration_limit, valid_ransac_num, scale, value_type, k, inc, next_frame, sframe, icp_mode, feature_dis);
                    case {'sift_i_r_s_i_t_t_c_i_adapthisteq_cf_cov_ransac_cf05_icp9_batch_featureidxfix_tol01_maxstep_fast_fast'}
                        [phi(j), theta(j), psi(j), trans(:,j), error(j), elapsed(:,j), match_num(:,j), feature_points{j}, pose_std(:,j)]=localization_sift_ransac_limit_icp2_cov_fast_fast(image_name, data_name, filter_name, boarder_cut_off, ransac_iteration_limit, valid_ransac_num, scale, value_type, k, inc, next_frame, sframe, icp_mode, feature_dis);
                    case {'sift_i_r_s_i_t_t_c_i_a_c_c_r_cf05_icp9_batch_featureidxfix_tol01_maxstep_fast_fast_dist'}
                        [phi(j), theta(j), psi(j), trans(:,j), error(j), elapsed(:,j), match_num(:,j), feature_points{j}, pose_std(:,j)]=localization_sift_ransac_limit_icp2_cov_fast_fast_dist(image_name, data_name, filter_name, boarder_cut_off, ransac_iteration_limit, valid_ransac_num, scale, value_type, k, inc, next_frame, sframe, icp_mode, feature_dis);
                    case {'sift_i_r_s_i_t_t_c_i_a_c_c_r_cf05_icp6_featureidxfix_maxstep_fast_fast_dist2_amd','sift_i_r_s_i_t_t_c_i_a_c_c_r_cf05_icp9_batch_featureidxfix_tol04_maxstep_fast_fast_dist2'}
                        [phi(j), theta(j), psi(j), trans(:,j), error(j), elapsed(:,j), match_num(:,j), feature_points{j}, pose_std(:,j)]=localization_sift_ransac_limit_icp2_cov_fast_fast_dist2(image_name, data_name, filter_name, boarder_cut_off, ransac_iteration_limit, valid_ransac_num, scale, value_type, k, inc, next_frame, sframe, icp_mode, feature_dis);
                    case {'sift_i_r_s_i_t_t_c_i_a_c_c_r_cf05_icp6_featureidxfix_maxstep_fast_fast_dist2_loadicp_10step','sift_i_r_s_i_t_t_c_i_a_c_c_r_cf05_icp9_batch_f_tol01_fast_fast_dist2_loadicp_10step'}
                        [phi(j), theta(j), psi(j), trans(:,j), error(j), elapsed(:,j), match_num(:,j), feature_points{j}, pose_std(:,j)]=localization_sift_ransac_limit_icp2_cov_fast_fast_dist2_loadicp(image_name, data_name, filter_name, boarder_cut_off, ransac_iteration_limit, valid_ransac_num, scale, value_type, k, inc, next_frame, sframe, icp_mode, feature_dis);
                    case {'sift_int_ransac_stdcrt_gc_num_aa_tictoc_total_constraints_confidence_indexplus1_test','sift_int_ransac_stdcrt_gc_num_aa_tictoc_total_constraints_confidence_indexplus1','sift_int_ransac_stdcrt_gc_num_aa_tictoc_total_constraints_confidence_indexplus1','sift_int_ransac_stdcrt_gc_num_aa_tictoc_total_constraints_confidence','sift_int_ransac_stdcrt_gc_num_em_error_class_tictoc_total_confidence','sift_int_ransac_stdcrt_gc_num_em_error_class_tictoc_total','sift_int_ransac_stdcrt_gc_num_em_error_class_etime_total','sift_int_ransac_stdcrt_confidence_etime_median','sift_int_ransac_stdcrt_gc_num_em_error_ll001_etime', 'sift_int_ransac_stdcrt_gc_num_aa_error_etime','sift_int_ransac_stdcrt_gc_num_em_error_class_etime', 'sift_int_gc_num_em_error_class_etime', 'sift_int_ransac_stdcrt_gc_num', 'sift_int_ransac_stdcrt_gc', 'sift_int_ransac_stdcrt_gc_msdtc'}
                        [phi(j), theta(j), psi(j), trans(:,j), error(j), elapsed(:,j), match_num(:,j), feature_points{j}] = localization_sift_ransac_gc_msdtc(image_name, data_name, filter_name, boarder_cut_off, ransac_iteration_limit, valid_ransac_num, scale, value_type, k, inc, next_frame, sframe, feature_dis);
                    case {'sift_int_ransac_stdcrt_gc_num_aa_tictoc_total_constraints_confidence_icp6_indexplus1','sift_int_ransac_stdcrt_gc_num_aa_tictoc_total_constraints_confidence_icp'}
                        [phi(j), theta(j), psi(j), trans(:,j), error(j), elapsed(:,j), match_num(:,j), feature_points{j}] = localization_sift_ransac_gc_msdtc_icp(image_name, data_name, filter_name, boarder_cut_off, ransac_iteration_limit, valid_ransac_num, scale, value_type, k, inc, next_frame, sframe);
                    case {'int_tictoc_total_confidence_icp7_intensity'}
                        [phi(j), theta(j), psi(j), trans(:,j), error(j), elapsed(:,j), match_num(:,j)]=localization_icp(image_name, data_name, filter_name, boarder_cut_off, ransac_iteration_limit, valid_ransac_num, scale, value_type, k, inc, next_frame, sframe);
                    case {'sift_int_ransac_stdcrt_icp',  'sift_int_ransac_stdcrt_icp_match'}
                        [phi(j), theta(j), psi(j), trans(:,j), error(j), elapsed(:,j), match_num(:,j)] = localization_sift_ransac_limit_icp(image_name, data_name, filter_name, boarder_cut_off, ransac_iteration_limit, valid_ransac_num, scale, value_type, k, inc, j);
                    otherwise
                        disp('Feature extractor name is unknown.');
                        return;
                end
                tr =[phi; theta; psi; trans; elapsed; match_num; error]';
                if pose_std_on == 1
                    tr_pose_std=[pose_std; error]';
                end
                frame_index = [frame_index; s+start_frame_interval s+next_frame+start_frame_interval];
                %if error(j) == 0
                if error(j) > 0
                    consecutive_error_count = consecutive_error_count + 1;
                else
                    consecutive_error_count = 0;
                end
                rFrame = rFrame + 1;
                if rFrame >= jFrame || consecutive_error_count >= consecutive_error_count_threshold
                    break;
                end
                %end
                %fprintf(efp, '%4d', error(nk,j));
            end
            %total_tr = [total_tr; frame_index tr];
            unit_tr = [frame_index tr];
            if pose_std_on == 1
                unit_tr_pose_std=[frame_index tr_pose_std];
            end
            %Write datat into file
            %end
            %fprintf(efp, '\n');
            %fprintf(pfp, '%12.8f %12.8f[phi, theta, psi, trans, error, elapsed, match_num] = localization_sift_ransac_limit_icp(image_name, data_name, filter_name, boarder_cut_off, ransac_iteration_limit, valid_ransac, scale, value_type, dm, inc, j, dis) %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f\n', tr);
            
            %delete the row having errors
            save_tr = unit_tr;
            if pose_std_on == 1
                save_tr_pose_std = unit_tr_pose_std;
            end
            if strcmp(fe_name,long_format_name)      % feature points and compuational time of gc is added
                e = save_tr(:,21) ~= 0;
            else
                e = save_tr(:,19) ~= 0;
            end
            save_tr(e,:)=[];
            if pose_std_on == 1
                save_tr_pose_std(e,:)=[];
            end
            
            if ~isempty(feature_points)
                for n=1:size(e,1)
                    if e(n) == 1
                        feature_points{n}=[];
                    else
                        feature_points{n}=[repmat(frame_index(n,:),[size(feature_points{n},1) 1]) feature_points{n}];
                    end
                end
            end
            
            %size(total_tr)
            
            %        mv(nk,:)=mean(tr);
            %        mv(nk,:)=median(tr);
            %        stdv(nk,:)=std(tr);
            %     end
            %fclose(pfp);
            %fclose(efp);
            %********************************************************************
            %fid=fopen('mean_std.dat', 'w');elapsed
            %fprintf(fid, '%%mean values: pitch interval - 6 degree\n');
            %fprintf(fid, '%12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f\n', mv');
            %fprintf(fid, '\n%%standard deviation\n');
            %fprintf(fid, '%12.8f %12.8f %12.interval = c4_movement;979_frame_abs_intensity_sift_int_ransac_stdcrt_gc_num_aa_tictoc_total_constraints_confidence_gaussian_08f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f\n', stdv');
            %fclose(fid);
            
            %Added by soonhac @ 3/8
            %show error
            %Unit : degree for phi, theta, psi
            %       mm for x,y,z
            %     switch data_name
            %         case {'pitch', 'pitch2'}
            %             if strcmp(fe_name,long_format_name)      % feature points and compuational time of gc is added
            %                 ground_truth = [0 angle_interval*inc 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];   %phi, theta, psi, x, y, z, times... error
            %             else
            %                 ground_truth = [0 angle_interval*inc 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];   %phi, theta, psi, x, y, z, times... error
            %             end
            %         case 'pan'
            %             if strcmp(fe_name,long_format_name)      % feature points and compuational time of gc is added
            %                 ground_truth = [0 0 (-1)*angle_interval*inc 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];   %phi, theta, psi, x, y, z, times... error
            %             elseinterval = c4_movement;979_frame_abs_intensity_sift_int_ransac_stdcrt_gc_num_aa_tictoc_total_constraints_confidence_gaussian_0
            %                 ground_truth = [0 0 (-1)*angle_interval*inc 0 0 0 0 0 0 0 0 0 0 0 0 0 0];   %phi, theta, psi, x, y, z, times... error
            %             end
            %         case 'roll'
            %             ground_trutsift_int_ransac_stdcrt_gc_num_em_fixh = [(-1)*angle_interval*inc 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];   %phi, theta, psi, x, y, z, times... error
            %         case 'x'                    break;
            
            %             ground_truth = [0 0 0 translation_interval*inc 0 0 0 0 0 0 0 0 0 0 0 0 0];   %phi, theta, psi, x, y, z, times... error
            %         case 'y'
            %             ground_truth = [0 0 0 0 translation_interval*inc 0 0 0 0 0 0 0 0 0 0 0 0];   %phi, theta, psi, x, y, z, times... error
            %       total_tr  case 'x2'
            %             ground_truth = [0 0 0 elapsed(translation_interval_2+trnaslation_interval_2_correction)*inc 0 0 0 0 0 0 0 0 0 0 0 0 0];   %phi, theta, psi, x, y, z, times... error
            %         case 'y2'
            %             ground_truth = [0 0 0 0 (translation_interval_2+trnaslation_interval_2_correction)*inc 0 0 0 0 0 0 0 0 0 0 0 0];   %phi, theta, psi, x, y, z, times... error
            %         case {'c1','c3'}
            %             grouinterval = c4_movement;979_frame_abs_intensity_sift_int_ransac_stdcrt_gc_num_aa_tictoc_total_constraints_confidence_gaussian_0nd_truth = [0 interval{inc}(2) interval{inc}(1) interval{inc}(3) 0 0 0 0 0 0 0 0 0 0 0 0 0];   %phi, theta, psi, x, y, z, times... error
            %         case {'c2','c4'}
            %             ground_truth = [0 interval{inc}(2) interval{inc}(1) 0 interval{inc}(3) 0 0 0 0 0 0 0 0 0 0 0 0];   %phi, theta, psi, x, y, z, times... error
            %         otherwise
            %             disp('Data name is unknown.');
            %             return;
            %     end                    break;
            
            %     mv_size = size(mv);elapsed
            %     mv(:,1:3) = mv(:,1:3) * 180/pi; % convert from radian to degree
            %     mv(:,4:6) = mv(:,4:6) * 1000;   % convert from meter to millimeter
            %     for k=1:mv_size(1)
            %         abs_error(k,:) = abs(mv(k,:) - ground_truth);
            %     end
            
            
            if strcmp(fe_name,long_format_name)  % feature points and compuational time of gc is added
                fprintf(efd,'%d %d %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f\n', save_tr');
            else
                fprintf(efd,'%d %d %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f\n', save_tr');
                if pose_std_on == 1
                    fprintf(efd_pose_std,'%d %d %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f\n', save_tr_pose_std');
                end
            end
            
            for n=1:size(feature_points,2)
                fpts_unit_data = feature_points{n};
                if ~isempty(fpts_unit_data)
                    fprintf(fp_fd,'%d %d %d %f %f %f %f %f\n',fpts_unit_data');
                end
            end
            
        end
        
        fclose(efd);
        fclose(fp_fd);
        if pose_std_on == 1
            fclose(efd_pose_std);
        end
    end
    
    
    %     sfd = fopen(std_file_name,'w');
    %     if strcmp(fe_name,long_format_name)  % feature points and compuational time of gc is added
    %         fprintf(sfd,'%12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f\n', stdv');
    %     else
    %         fprintf(sfd,'%12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f\n', stdv');
    %     end
    %     fclose(sfd);
end

%plot_errors(error_file_name);
