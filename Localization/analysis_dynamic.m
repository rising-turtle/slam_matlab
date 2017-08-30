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
nFrame = 5; %270; %540; %1000; %240; %60; %norminal frame
rFrame = 0;  %real frame
r2d=180.0/pi;
scale = 1;

image_name_list={'intensity','depth','fuse','fuse_std'};
data_name_list={'pitch', 'pan7', 'roll5','x2', 'y2', 'c1', 'c2','c3','c4','m','kinect_tum','loop_closure_10m'}; % 'x', 'y', 
% fe_name_list={'sift','sift_ransac_limit_14000_14','sift_ransac_stdcrt','sift_ransac_stdcrt_15p','sift_ransac_maxlimit','sift_ransac_20000','sift_ransac_stdctr_gc','sift_ransac_stdctr_stdev','sift_ransac_450','sift_ransac_350','sift_ransac_stable','surf','surf_ransac_limit_14000_11','surf_ransac_stdcrt','surf_ransac_stdctr_14p','surf_ransac_stdctr_stdev','surf_ransac_20000','surf_ransac_stdcrt_stdev_linear','surf_ransac_350','surf_ransac_300','surf_ransac_200','surf_ransac_stc_gc'};
% 'sift_int_ransac_stdcrt_iter_tictoc_total_th1',
% 
% 'sift_int_ransac_stdcrt_gc_num_em_error_class_tictoc_total','sift_int_ransac_stdcrt_iter_tictoc_total_confidence_iransacsvd'
% 'surf_int_ransac_stdcrt_iter_tictoc_total_confidence_icp6_intensity',
% 'int_tictoc_total_confidence_icp11_intensity',
% 'sift_int_histogramvoting_stdcrt_iter_tictoc_total_confidence_icp6_intensity',
% 'sift_int_ransac_stdcrt_gc_num_dynamic_thresh_error_class_tictoc_total_confidence_plus1'
% 'sift_int_ransac_stdcrt_iter_tictoc_total_confidence_nogaussian_adapthisteq','sift_int_ransac_stdcrt_iter_tictoc_total_confidence_nogaussian_adapthisteq_icp6',
fe_name_list_int={'sift_int_ransac_stdcrt_iter_tictoc_total_confidence_intensity_adapthisteq_nobcp','sift_int_ransac_stdcrt_iter_tictoc_total_confidence_intensity_adapthisteq_icp6_save_test','sift_int_ransac_stdcrt_iter_tictoc_total_confidence_intensity_adapthisteq_icp9_save_test','sift_int_ransac_stdcrt_iter_tictoc_total_confidence_intensity_adapthisteq_bootstrap_test','sift_int_ransac_stdcrt_iter_tictoc_total_confidence_intensity_adapthisteq','sift_int_ransac_stdcrt_iter_tictoc_total_confidence_intensity','sift_int_ransac_stdcrt_iter_tictoc_total_confidence_icp9_intensity','sift_int_ransac_stdcrt_iter_tictoc_total_confidence','sift_int_ransac_stdcrt_gc_num_em_error_class_tictoc_total_confidence','surf_int_ransac_stdcrt_iter_tictoc_total_thd_0001', 'sift_int_ransac_stdcrt_gc_num_em_error_class_tictoc_total','sift_int_ransac_stdcrt_iter_tictoc_total','sift_int_ransac_stdcrt_iter_tictoc_total_no_gaussian_range','sift_int_ransac_stdcrt_iter_tictoc_total','surf_int_ransac_stdcrt_iter_tictoc_total_thd_000001','sift_int_ransac_stdcrt_gc_num_em_error_class_tictoc_total','sift_int_ransac_stdcrt_gc_num_em_error_class_etime_total','sift_int_ransac_stdcrt_iter_etime_total','sift_int_ransac_stdcrt_confidence_etime_median','sift_int_ransac_stdcrt_gc_num_em_error_class_etime','sift_int_gc_num_em_error_class_etime','sift_int_ransac_stdcrt_gc_num_aa_error_etime', 'sift_int_ransac_3points_stdcrt_iter_etime','sift_int_ransac_3points_stdcrt', 'sift_int_gc_num_em_llthreshold_001', 'sift_int_ransac_stdcrt_icp_match','sift_int_ransac_stdcrt_12_kc','sift_int_ransac_stdcrt_gc_msdtc','surf_int','surf_int_ransac_stdcrt','surf_int_ransac_stdcrt_13','surfcpp_int','surfcpp_int_ransac_stdcrt'}; %'sift_int_ransac_350','surf_int_ransac_200'
filter_list={'none','median','gaussian','median5','gaussian5','gaussian_edge_std'};
boarder_cut_off = 0; %5;    % percentage of cut off in both horizaontal borders
value_list ={'int', 'double'};

image_name = image_name_list{1}; 
data_name=data_name_list{12}  % 3
fe_name=fe_name_list_int{1}   % 2 
filter_name=filter_list{3};  % 1
value_type=value_list{1};
ransac_iteration_limit = 0; %20000; %14000; 0 = standard termination criterion
valid_ransac_num = 3;
long_format_name ='none'; %fe_name;
pose_std_on = 0;
feature_dis = 1; % 1 = display features; 0 = display no features
icp_mode = 'icp_ch'; %;'icp'
sequence_data = false;
is_10M_data = true;

switch data_name
    case {'pitch','pitch2'}
        maxData = 28; % 11
        inc_init = 5;
        inc_max = 6; %9; %9; %11;   % 3 * 11 = 33 << 34 degree of FOV
        unit='degree';
        interval = angle_interval;
    case {'pitch3'}
        maxData = 5; % 11
        inc_init = 1;
        inc_max = 4; %9; %9; %11;   % 3 * 11 = 33 << 34 degree of FOV
        unit='degree';
        interval = angle_interval;
    case {'pitch4'}
        maxData = 11; % 11
        inc_init = 5;
        inc_max = 7; %9; %9; %11;   % 3 * 11 = 33 << 34 degree of FOV
        unit='degree';
        interval = angle_interval;
    case {'pitch5'}
        maxData = 4; % 11
        inc_init = 1;
        inc_max = 3; %9; %9; %11;   % 3 * 11 = 33 << 34 degree of FOV
        unit='degree';
        interval = angle_interval;
    case {'pitch6'}
        maxData = 10; % 11
        inc_init = 5;
        inc_max = 8; %9; %9; %11;   % 3 * 11 = 33 << 34 degree of FOV
        unit='degree';
        interval = angle_interval;
    case {'pitch10'}
        maxData = 9; % 11
        inc_init = 5;
        inc_max = 9; %9; %9; %11;   % 3 * 11 = 33 << 34 degree of FOV
        unit='degree';
        interval = angle_interval;
    case {'pitch11'}
        maxData = 9; % 11
        inc_init = 1;
        inc_max = 6; %9; %9; %11;   % 3 * 11 = 33 << 34 degree of FOV
        unit='degree';
        interval = angle_interval;
    case {'pitch12'}
        maxData = 10; % 11
        inc_init = 5;
        inc_max = 6; %9; %9; %11;   % 3 * 11 = 33 << 34 degree of FOV
        unit='degree';
        interval = angle_interval;
    case 'pan'
        maxData = 29;
        inc_init = 1;
        inc_max = 11; %14;   % 3 * 14 = 42 << 43 degree of FOV
        unit='degree';
        interval =angle_interval;
    case 'pan2'
        maxData = 13;
        inc_init = 9;
        inc_max = 12; %14;   % 3 * 14 = 42 << 43 degree of FOV
        unit='degree';
        interval =angle_interval;
    case 'pan3'
        maxData = 15;
        inc_init = 3;
        inc_max = 7; %14;   % 3 * 14 = 42 << 43 degree of FOV
        unit='degree';
        interval =angle_interval;
    case 'pan4'
        maxData = 9;
        inc_init = 6;
        inc_max = 8; %14;   % 3 * 14 = 42 << 43 degree of FOV
        unit='degree';
        interval =angle_interval;
    case 'pan5'
        maxData = 14;
        inc_init = 1;
        inc_max = 10; %14;   % 3 * 14 = 42 << 43 degree of FOV
        unit='degree';
        interval =angle_interval;
    case 'pan7'
        maxData = 14;
        inc_init = 1;
        inc_max = 6; %14;   % 3 * 14 = 42 << 43 degree of FOV
        unit='degree';
        interval =angle_interval;
    case 'roll'
        maxData = 9;
        inc_init = 1;
        inc_max = 8; %6; %14;   % 3 * 14 = 42 << 43 degree of FOV
        unit='degree';
        interval = angle_interval;
    case 'roll3'
        maxData = 15;
        inc_init = 6;
        inc_max = 7; %6; %14;   % 3 * 14 = 42 << 43 degree of FOV
        unit='degree';
        interval = angle_interval;
    case 'roll4'
        maxData = 15;
        inc_init = 1;
        inc_max = 6; %6; %14;   % 3 * 14 = 42 << 43 degree of FOV
        unit='degree';
        interval = angle_interval;
    case 'roll5'
        maxData = 14;
        inc_init = 4;
        inc_max = 7; %6; %14;   % 3 * 14 = 42 << 43 degree of FOV
        unit='degree';
        interval = angle_interval;
    case 'x'
        maxData = 13;
        inc_init = 1;
        inc_max = 2; %maxData-1;'sift_int_ransac_stdcrt_icp'
        unit='mm';
        interval = translation_interval;
    case 'y'
        maxData = 11;
        inc_init = 1;
        inc_max = 2; %maxData-1;
        unit='mm'; %cputime - t_svd;
        interval = translation_interval;
    case 'x2'
        maxData = 9;
        inc_init = 1;
        inc_max = 7; %7; %maxData-1;
        unit='mm';
        interval = translation_interval_2;
    case 'y2'
        maxData = 9;
        inc_init = 1;
        inc_max = 8; %8; %maxData-1;
        unit='mm';
        interval = translation_interval_2;
    case 'c1'
        maxData = 4;
        inc_init = 1;
        inc_max = maxData-1;
        unit={'y-3_p6_x100','y-6_p12_x500','y-12_p9_x300'};
        interval = c1_movement;
    case 'c2'
        maxData = 4;
        inc_init = 1;
        inc_max = maxData-1;
        unit={'y-6_p3_y200','y-9_p12_y400','y-12_p6_y600'};
        interval = c2_movement;
    case 'c3'
        maxData = 5;
        inc_init = 1;
        inc_max = maxData-1;
        unit={'y3_p12_x100','y6_p9_x200','y9_p6_x300','y12_p3_x400'};
        interval = c3_movement;
    case 'c4'
        maxData = 2;
        inc_init = 1;
        inc_max = maxData-1;
        unit={'y-3_p9_y300'};
        interval = c4_movement;
    case 'm'
        maxData = 2;
        inc_init = 1;
        inc_max = maxData-1;
        %unit={'x_500qc','pitch_10degree','pitch_3degree','pan_3degree','pan_10degree','x_1mm','x_10mm','x_5mm'};
        unit={'pitch_3degree','pitch_9degree','pan_3degree','pan_9degree','pan_30degree','pan_60degree','roll_3degree','roll_9degree','x_30mm','x_150mm','x_300mm','y_30mm','y_150mm','y_300mm','square_500','square_700','square_swing','test'};
        %nFrame_list=[143 34 76 90 38 135 24 39];
        nFrame_list= [83 35 86 36 26 16 157 60 161 42 25 175 42 28 500 700 1000 140];
        start_frame = [11 8 11 8 8 6 11 11 11 8 6 21 8 8 40 40 50 101];
        finish_frame = [70 25 70 25 16 11 135 50 150 35 21 150 35 22 450 650 850 130];
        interval = 0;
        dynamic_data_index = 11; %15;
    case 'kinect_tum'
        maxData = 2;
        inc_init = 1;
        inc_max = maxData-1;
        %unit={'x_500qc','pitch_10degree','pitch_3degree','pan_3degree','pan_10degree','x_1mm','x_10mm','x_5mm'};
        unit=get_kinect_tum_dir_name();
        %nFrame_list=[143 34 76 90 38 135 24 39];
        nFrame_list= [798 1242 3359 5182];
        start_frame = [1 1 1 1];
        finish_frame = [30 1242 3359 5182];
        interval = 0;
        dynamic_data_index = 1; %15
     case 'loop_closure_10m'
        maxData = 3;
        inc_init = 1;
        inc_max = 2; %6; %14;   % 3 * 14 = 42 << 43 degree of FOV
        unit='degree';
        interval = angle_interval;
    otherwise
        disp('Data name is unknown.');
        return;
end

for inc = inc_init : inc_max
    %inc
    %inc=input('Enter interval (n -- 3*n degree):');
    %pfp=fopen('pose.dat', 'w');
    %efp=fopen('error.dat', 'w');
    maxDegree = 1; %maxData - inc; %inc * 3;
    if maxDegree < 1 %inc*floor(maxData/inc)'sift_int_ransac_stdcrt_iter_tictoc_total_constraints'
        fprintf('WARNING : Interval is out of range [0 - %d]\n',maxData-1);  %maxDegree = inc*floor(maxData/inc)-1;
        return;
    end
        
    if strcmp(data_name, 'm') || strcmp(data_name, 'kinect_tum')
%         nFrame = nFrame_list(dynamic_data_index) - 1;
          nFrame = finish_frame(dynamic_data_index) - start_frame(dynamic_data_index) - 1;
    end
    
    for k=1:maxDegree
        nk=k; %(k-1)/inc+1
        rFrame = 0;
        if strcmp(data_name, 'm') || strcmp(data_name, 'kinect_tum')
            k = dynamic_data_index;
        end
        pose_std = [];
        feature_points={};
        for j=1:MAX_FRAME %(nFrame + addFrame)
            [inc, k, j]
            if strcmp(data_name, 'm')
                if dynamic_data_index >= 15
                    sframe = start_frame(dynamic_data_index) + j;
                    next_frame = 1;
                else
                    sframe = start_frame(dynamic_data_index);
                    next_frame = j;
                end
            else
                sframe = 1;
                next_frame = j;
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
                case {'sift_int_ransac_stdcrt_iter_tictoc_total_confidence_intensity_adapthisteq_test','sift_int_ransac_stdcrt_iter_tictoc_total_confidence_intensity', 'sift_int_ransac_stdcrt_iter_tictoc_total_confidence', 'sift_int_ransac_stdcrt_iter_tictoc_total_th4','sift_int_ransac_stdcrt_iter_tictoc_total_th1','sift_int_ransac_stdcrt_iter_tictoc_total_no_gaussian_range', 'sift_int_ransac_stdcrt_iter_tictoc_total', 'sift_int_ransac_stdcrt_iter_etime_total','sift_int_ransac_3points_stdcrt_iter_etime','sift_int_ransac_stdcrt_iter_etime','sift_int_ransac_3points_stdcrt_etime','sift_int_ransac_stdcrt_etime','sift_ransac_limit_14000_14','sift_ransac_stdcrt','sift_ransac_stdcrt_15p','sift_ransac_maxlimit','sift_ransac_20000','sift_ransac_stdctr_gc','sift_ransac_stdctr_stdev','sift_ransac_450','sift_ransac_350','sift_ransac_stable','sift_int_ransac_stdcrt','sift_int_ransac_350','sift_int_ransac_stdcrt_12','sift_int_ransac_stdcrt_12_kc','sift_int_ransac_3points_stdcrt'}
                     switch image_name
                        case {'depth','intensity'}
                            [phi(j), theta(j), psi(j), trans(:,j), error(j), elapsed(:,j), match_num(:,j), feature_points{j}, pose_std(:,j)]=localization_sift_ransac_limit(image_name, data_name, filter_name, boarder_cut_off, ransac_iteration_limit, valid_ransac_num, scale, value_type, k, inc, next_frame, sframe, feature_dis);
                        case {'fuse','fuse_std'}
                            [phi(j), theta(j), psi(j), trans(:,j), error(j), elapsed(:,j), match_num(:,j)]=localization_fuse_sift(image_name, data_name, filter_name, boarder_cut_off, ransac_iteration_limit, valid_ransac_num, scale, value_type, k, inc, next_frame, sframe); %(image_name, data_name, filter_name, boarder_cut_off, k, inc, j);
                     end
                case {'sift_int_ransac_stdcrt_iter_tictoc_total_confidence_intensity_adapthisteq_nobcp'}
                    [phi(j), theta(j), psi(j), trans(:,j), error(j), elapsed(:,j), match_num(:,j), feature_points{j}, pose_std(:,j)]=localization_sift_ransac_limit_cov_fast_fast_dist2_nobpc(image_name, data_name, filter_name, boarder_cut_off, ransac_iteration_limit, valid_ransac_num, scale, value_type, k, inc, next_frame, sframe, sequence_data, is_10M_data, feature_dis);
                case {'sift_int_ransac_stdcrt_iter_tictoc_total_confidence_intensity_adapthisteq_bootstrap_test'}
                    [phi(j), theta(j), psi(j), trans(:,j), error(j), elapsed(:,j), match_num(:,j), feature_points{j}, pose_std(:,j)]=localization_sift_ransac_limit_cov_dist(image_name, data_name, filter_name, boarder_cut_off, ransac_iteration_limit, valid_ransac_num, scale, value_type, k, inc, next_frame, sframe);
                case {'sift_int_ransac_stdcrt_iter_tictoc_total_confidence_intensity_adapthisteq','sift_int_ransac_stdcrt_iter_tictoc_total_confidence_nogaussian_adapthisteq','sift_int_ransac_stdcrt_iter_tictoc_total_confidence_nogaussian'}
                    [phi(j), theta(j), psi(j), trans(:,j), error(j), elapsed(:,j), match_num(:,j), feature_points{j}, pose_std(:,j)]=localization_sift_ransac_limit_cov_dist2(image_name, data_name, filter_name, boarder_cut_off, ransac_iteration_limit, valid_ransac_num, scale, value_type, k, inc, next_frame, sframe, feature_dis);
                case {'int_tictoc_total_confidence_icp11_intensity','int_tictoc_total_confidence_icp8_intensity','int_tictoc_total_confidence_icp7_intensity'}
                    [phi(j), theta(j), psi(j), trans(:,j), error(j), elapsed(:,j), match_num(:,j)]=localization_icp(image_name, data_name, filter_name, boarder_cut_off, ransac_iteration_limit, valid_ransac_num, scale, value_type, k, inc, next_frame, sframe);
                case {'int_tictoc_total_confidence_icp12_intensity'}
                    [phi(j), theta(j), psi(j), trans(:,j), error(j), elapsed(:,j), match_num(:,j)]=localization_icp2(image_name, data_name, filter_name, boarder_cut_off, ransac_iteration_limit, valid_ransac_num, scale, value_type, k, inc, next_frame, sframe);
                case {'sift_int_ransac_stdcrt_iter_tictoc_total_confidence_intensity_adapthisteq_bootstrap_icp9'}
                    [phi(j), theta(j), psi(j), trans(:,j), error(j), elapsed(:,j), match_num(:,j), feature_points{j}, pose_std(:,j)]=localization_sift_ransac_limit_icp2_cov_fast_fast_dist(image_name, data_name, filter_name, boarder_cut_off, ransac_iteration_limit, valid_ransac_num, scale, value_type, k, inc, next_frame, sframe, icp_mode, feature_dis);
                case {'sift_int_ransac_stdcrt_gc_num_dynamic_thresh_error_class_tictoc_total_confidence_plus1', 'sift_int_ransac_stdcrt_gc_num_em_error_class_tictoc_total_confidence', 'sift_int_ransac_stdcrt_gc_num_em_error_class_tictoc_total','sift_int_ransac_stdcrt_gc_num_em_error_class_etime_total','sift_int_ransac_stdcrt_confidence_etime_median','sift_int_ransac_stdcrt_gc_num_em_error_ll001_etime', 'sift_int_ransac_stdcrt_gc_num_aa_error_etime','sift_int_ransac_stdcrt_gc_num_em_error_class_etime', 'sift_int_gc_num_em_error_class_etime', 'sift_int_ransac_stdcrt_gc_num', 'sift_int_ransac_stdcrt_gc', 'sift_int_ransac_stdcrt_gc_msdtc'}
                    [phi(j), theta(j), psi(j), trans(:,j), error(j), elapsed(:,j), match_num(:,j)] = localization_sift_ransac_gc_msdtc(image_name, data_name, filter_name, boarder_cut_off, ransac_iteration_limit, valid_ransac_num, scale, value_type, k, inc, next_frame, sframe);
                case {'sift_int_ransac_stdcrt_iter_tictoc_total_confidence_intensity_adapthisteq_icp9','sift_int_ransac_stdcrt_iter_tictoc_total_confidence_nogaussian_adapthisteq_icp6','sift_int_ransac_stdcrt_iter_tictoc_total_confidence_nogaussian_icp6','sift_int_ransac_stdcrt_iter_tictoc_total_confidence_intensity_adapthisteq_icp6','sift_int_ransac_stdcrt_iter_tictoc_total_confidence_icp13_intensity','sift_int_ransac_stdcrt_iter_tictoc_total_confidence_icp6_intensity','sift_int_ransac_stdcrt_iter_tictoc_total_confidence_icp9_intensity','sift_int_ransac_stdcrt_iter_tictoc_total_confidence_icp4_intensity','sift_int_ransac_stdcrt_iter_tictoc_total_confidence_icp3_intensity', 'sift_int_ransac_stdcrt_iter_tictoc_total_confidence_icp2_intensity','sift_int_ransac_stdcrt_iter_tictoc_total_confidence_icp_intensity','sift_int_ransac_stdcrt_iter_tictoc_total_confidence_icp', 'sift_int_ransac_stdcrt_icp',  'sift_int_ransac_stdcrt_icp_match'}  
                    %[phi(j), theta(j), psi(j), trans(:,j), error(j), elapsed(:,j), match_num(:,j)] = localization_sift_ransac_limit_icp(image_name, data_name, filter_name, boarder_cut_off, ransac_iteration_limit, valid_ransac_num, scale, value_type, k, inc, j);
                    [phi(j), theta(j), psi(j), trans(:,j), error(j), elapsed(:,j), match_num(:,j)]=localization_sift_ransac_limit_icp2(image_name, data_name, filter_name, boarder_cut_off, ransac_iteration_limit, valid_ransac_num, scale, value_type, k, inc, next_frame, sframe);
                case {'sift_int_ransac_stdcrt_iter_tictoc_total_confidence_intensity_adapthisteq_icp6_save_test','sift_int_ransac_stdcrt_iter_tictoc_total_confidence_intensity_adapthisteq_icp9_save_test'}
                    [phi(j), theta(j), psi(j), trans(:,j), error(j), elapsed(:,j), match_num(:,j), feature_points{j}, pose_std(:,j)]=localization_sift_ransac_limit_icp2_cov_fast_fast_dist2(image_name, data_name, filter_name, boarder_cut_off, ransac_iteration_limit, valid_ransac_num, scale, value_type, k, inc, next_frame, sframe, icp_mode, feature_dis);
                case {'sift_int_histogramvoting_stdcrt_iter_tictoc_total_confidence_icp6_intensity'}
                    [phi(j), theta(j), psi(j), trans(:,j), error(j), elapsed(:,j), match_num(:,j)]=localization_sift_histogramvoting_limit_icp2(image_name, data_name, filter_name, boarder_cut_off, ransac_iteration_limit, valid_ransac_num, scale, value_type, k, inc, next_frame, sframe);
                case {'surf_int_ransac_stdcrt_iter_tictoc_total_confidence_icp6_intensity'}  
                    %[phi(j), theta(j), psi(j), trans(:,j), error(j), elapsed(:,j), match_num(:,j)] = localization_sift_ransac_limit_icp(image_name, data_name, filter_name, boarder_cut_off, ransac_iteration_limit, valid_ransac_num, scale, value_type, k, inc, j);
                    [phi(j), theta(j), psi(j), trans(:,j), error(j), elapsed(:,j), match_num(:,j)]=localization_surf_ransac_limit_icp2(image_name, data_name, filter_name, boarder_cut_off, ransac_iteration_limit, valid_ransac_num, scale, value_type, k, inc, next_frame, sframe);
                
                case {'sift_int_ransac_stdcrt_iter_tictoc_total_confidence_iransacsvd'}
                    [phi(j), theta(j), psi(j), trans(:,j), error(j), elapsed(:,j), match_num(:,j)]=localization_sift_ransac_limit_iransacsvd(image_name, data_name, filter_name, boarder_cut_off, ransac_iteration_limit, valid_ransac_num, scale, value_type, k, inc, next_frame, sframe);
                otherwise
                    disp('Feature extractor name is unknown.');
                    return;
            end
            tr =[phi; theta; psi; trans; elapsed; match_num; error]';
            if pose_std_on == 1
                tr_pose_std=[pose_std; error]';
            end
            if error(j) == 0 
                rFrame = rFrame + 1;
                if rFrame >= nFrame
                    break;
                end
            end
            %fprintf(efp, '%4d', error(nk,j));
        end
        %fprintf(efp, '\n');
        %fprintf(pfp, '%12.8f %12.8f[phi, theta, psi, trans, error, elapsed, match_num] = localization_sift_ransac_limit_icp(image_name, data_name, filter_name, boarder_cut_off, ransac_iteration_limit, valid_ransac, scale, value_type, dm, inc, j, dis) %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f\n', tr);
        
        %delete the row having errors
        if strcmp(fe_name,long_format_name)      % feature points and compuational time of gc is added
            e = tr(:,19) ~= 0;
        else
            e = tr(:,17) ~= 0;
        end
        tr(e,:)=[];
        
        if pose_std_on == 1
            unit_tr_pose_std=[tr_pose_std];
        end
        if pose_std_on == 1
            save_tr_pose_std = unit_tr_pose_std;
        end
        if pose_std_on == 1
            save_tr_pose_std(e,:)=[];
        end
            
        size(tr)
        
%        mv(nk,:)=mean(tr);
%        mv(nk,:)=median(tr);
%        stdv(nk,:)=std(tr);
%     end
    %fclose(pfp);
    %fclose(efp);
    %********************************************************************
    %fid=fopen('mean_std.dat', 'w');
    %fprintf(fid, '%%mean values: pitch interval - 6 degree\n');
    %fprintf(fid, '%12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f\n', mv');
    %fprintf(fid, '\n%%standard deviation\n');
    %fprintf(fid, '%12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f\n', stdv');
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
%             else
%                 ground_truth = [0 0 (-1)*angle_interval*inc 0 0 0 0 0 0 0 0 0 0 0 0 0 0];   %phi, theta, psi, x, y, z, times... error
%             end
%         case 'roll'
%             ground_trutsift_int_ransac_stdcrt_gc_num_em_fixh = [(-1)*angle_interval*inc 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];   %phi, theta, psi, x, y, z, times... error
%         case 'x'
%             ground_truth = [0 0 0 translation_interval*inc 0 0 0 0 0 0 0 0 0 0 0 0 0];   %phi, theta, psi, x, y, z, times... error
%         case 'y'
%             ground_truth = [0 0 0 0 translation_interval*inc 0 0 0 0 0 0 0 0 0 0 0 0];   %phi, theta, psi, x, y, z, times... error
%         case 'x2'
%             ground_truth = [0 0 0 (translation_interval_2+trnaslation_interval_2_correction)*inc 0 0 0 0 0 0 0 0 0 0 0 0 0];   %phi, theta, psi, x, y, z, times... error
%         case 'y2'
%             ground_truth = [0 0 0 0 (translation_interval_2+trnaslation_interval_2_correction)*inc 0 0 0 0 0 0 0 0 0 0 0 0];   %phi, theta, psi, x, y, z, times... error
%         case {'c1','c3'}
%             ground_truth = [0 interval{inc}(2) interval{inc}(1) interval{inc}(3) 0 0 0 0 0 0 0 0 0 0 0 0 0];   %phi, theta, psi, x, y, z, times... error
%         case {'c2','c4'}
%             ground_truth = [0 interval{inc}(2) interval{inc}(1) 0 interval{inc}(3) 0 0 0 0 0 0 0 0 0 0 0 0];   %phi, theta, psi, x, y, z, times... error
%         otherwise
%             disp('Data name is unknown.');
%             return;
%     end
%     mv_size = size(mv);
%     mv(:,1:3) = mv(:,1:3) * 180/pi; % convert from radian to degree
%     mv(:,4:6) = mv(:,4:6) * 1000;   % convert from meter to millimeter
%     for k=1:mv_size(1)
%         abs_error(k,:) = abs(mv(k,:) - ground_truth);
%     end
    
    switch data_name 
        case {'c1', 'c2', 'c3', 'c4'}
            error_file_name = sprintf('result/%s/%s/%d_frame_abs_%s_%s_%s_%d.dat',data_name,unit{inc},rFrame,image_name,fe_name,filter_name,boarder_cut_off);    
            std_file_name = sprintf('result/%s/%s/%d_frame_abs_%s_%s_%s_%d_std.dat',data_name,unit{inc},rFrame,image_name,fe_name,filter_name,boarder_cut_off);
        case {'m','kinect_tum'} 
            error_file_name = sprintf('result/%s/%s/%d_frame_abs_%s_%s_%s_%d.dat',data_name,unit{dynamic_data_index},rFrame,image_name,fe_name,filter_name,boarder_cut_off);    
        otherwise
            error_file_name = sprintf('result/%s/%d_%s/%d_frame_abs_%s_%s_%s_%d.dat',data_name,inc*interval,unit,rFrame,image_name,fe_name,filter_name,boarder_cut_off);    
            std_file_name = sprintf('result/%s/%d_%s/%d_frame_abs_%s_%s_%s_%d_std.dat',data_name,inc*interval,unit,rFrame,image_name,fe_name,filter_name,boarder_cut_off);
    end
    
    efd = fopen(error_file_name,'w');
    if strcmp(fe_name,long_format_name)  % feature points and compuational time of gc is added
        fprintf(efd,'%12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f\n', tr');
    else
        fprintf(efd,'%12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f\n', tr');
    end
    
    end
    fclose(efd);
    
    if pose_std_on == 1
        pose_std_file_name = sprintf('result/%s/%d_%s/%d_frame_abs_%s_%s_%s_%d_pose_std.dat',data_name,inc*interval,unit,rFrame,image_name,fe_name,filter_name,boarder_cut_off);
        efd_pose_std = fopen(pose_std_file_name,'w');
        fprintf(efd_pose_std,'%12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f\n', save_tr_pose_std');
        fclose(efd_pose_std);
    end
    
    %Release variables
    tr=[];
    phi = [];
    theta =[]; 
    psi = []; 
    trans = []; 
    elapsed =[]; 
    match_num = []; 
    error = [];
    
%     sfd = fopen(std_file_name,'w');
%     if strcmp(fe_name,long_format_name)  % feature points and compuational time of gc is added
%         fprintf(sfd,'%12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f\n', stdv');
%     else
%         fprintf(sfd,'%12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f\n', stdv');
%     end
%     fclose(sfd);
end

%plot_errors(error_file_name);
