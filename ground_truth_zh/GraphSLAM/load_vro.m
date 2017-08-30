% Conver the results of VRO to the vertex and edges for g2o 
%
% Author : Soonhac Hong (sxhong1@ualr.edu)
% Date : 2/22/12

function [f_index t_pose o_pose feature_points, pose_std, icp_ct] = load_vro(data_index, dynamic_data_index, nFrame, feature_flag, vro_cpp, vro_name, pose_std_flag, isgframe, min_matched_points, with_lc_flag)

angle_interval = 3; % degree
translation_interval = 305; % mm
translation_interval_2 = 100; %mm

%Compensated by pan/tilt kinematics
c1_movement={[-3 6 101],[-12 9 304],[-6 12 501]}; % [yaw pitch x] [degree mm mm]
c2_movement={[-6 3 196],[-9 12 386],[-12 6 593]}; % [yaw pitch y] [degree mm mm]
c3_movement={[3 12 99],[6 9 198],[9 6 297],[12,3,395]}; % [yaw pitch x] [degree mm mm]
c4_movement={[-3 9 290]};% [yaw pitch y] [degree mm mm]
% trnaslation_interval_2_correction = 1.5; %mm
%nFrame = 540; %240; %240; %60;
r2d=180.0/pi;
cut_off = 0;
nFrame_list= [83 35 86 36 26 16 157 60 161 42 25 175 42 28 500 700 1000 140];
inc_min = 1;

%data_index = 10; %1='pitch',2='pan',3='roll', 4='x2' 5='y2', 6='c1', 7='c2', 8 ='c3', 9 ='c4', 10='m'
gt_file = 0; % Existence of ground truth; 0 = None, 1 = Exist
data_name = get_data_name_list();%{'pitch','pan','roll','x2','y2','c1','c2', 'c3', 'c4','m','etas','loops','kinect_tum','loops2','amir_vro','sparse_feature','swing','swing2','motive','object_recognition'};
filter_list={'gaussian'}; %,'median'
image_name = {'intensity'}; %,'fuse'}; %,'depth','fuse_std'};
%image_name = {'depth'};
consensus_name={'ransac'}; %'ransac','ggc_10p'}; %,'gc_30p','gc_40p'}; %,'gc_min'};

fe_selection_name = {'sift','surf','sift/surf'};
fe_selection = 4;
% fe_name = {'sift','sift_ransac_stdcrt','sift_ransac_stdctr_stdev'};%,'surf_ransac_limit_14000_11'}; % feature extractor name
% fe_name ={'surf','surf_ransac_stdcrt','surf_ransac_stdcrt_stdev_linear'}; %'surf_ransac_20000',
% fe_name ={'sift','surf','sift_ransac_20000','surf_ransac_20000'};
% fe_name ={'sift_ransac_stdcrt','sift_ransac_stdctr_stdev','surf_ransac_stdcrt','surf_ransac_stdcrt_stdev_linear'};
% 'sift_int_ransac_stdcrt_gc_num','sift_int_ransac_stdcrt_gc_num_em_llthreshold_001'
% 'sift_int_ransac_3points_stdcrt_iter_etime''sift_int_ransac_stdcrt_confidence_etime_median','sift_int_ransac_stdcrt_gc_num_em_error_class_etime'
% 'sift_int_ransac_stdcrt_iter_etime_total','sift_int_ransac_stdcrt_gc_num_em_error_class_etime_total'
% 'sift_int_ransac_stdcrt_iter_tictoc_total'
% 'sift_int_ransac_stdcrt_iter_tictoc_total_constraints'
%fe_name_set ={{'sift_int_ransac_stdcrt_gc_num_aa_tictoc_total_constraints_confidence'},{'surf_int_ransac_stdcrt','surfcpp_int'},{'sift_int_ransac_stdcrt','surf_int_ransac_stdcrt'}}; %,'surf_int','surf_int_ransac_stdcrt','sift_int_ransac_stdcrt','sift_int_ransac_350'}; %{'sift_ransac_350','sift_int_ransac_350'}; %{'sift_ransac_stdcrt', 'sift_int_ransac_stdcrt'}; %{'sift','sift_int'}; %'sift_ransac_stdcrt','sift_ransac_stable'}; %,'sift_ransac_stdcrt','sift_ransac_350'}; %,'sift_ransac_350'
%,'surf_int_ransac_stdcrt','surf_int_ransac_200'}; %{'surf_ransac_200','surf_int_ransac_200'};%{'surf_ransac_stdcrt','surf_int_ransac_stdcrt'}; %{'surf','surf_int'}; %'surf_ransac_stdcrt','sift_ransac_stable'}; %,'surf_ransac_stdcrt','surf_ransac_200'}; %,,'surf_ransac_stdcrt'
%fe_name = fe_name_set{fe_selection};
%if %nFrame == 5468
    %fe_name = 'sift_int_ransac_stdcrt_iter_tictoc_total_constraints';
    %long_format = 0;
if data_index == 11 % etas
    switch vro_name
        case 'vro'
            fe_name = 'sift_i_r_s_i_t_t_c_i_a_c_c_f_fast_fast_dist2_30step_nobpc';
        case 'vro_icp_ch'
            fe_name = 'sift_i_r_s_i_t_t_c_i_a_c_c_r_cf05_icp9_batch_f_tol01_fast_fast_dist2_loadicp_30step_nobpc';
    end
    long_format = 0;
elseif data_index == 12  % loops
    fe_name = 'sift_i_r_s_i_t_t_c_i_adapthisteq_cf_cov_featureidxfix_fast_fast';
    long_format = 0;
elseif data_index == 13  % kinect_tum
    %fe_name = 'sift_int_ransac_stdcrt_gc_num_aa_tictoc_total_constraints_confidence_indexplus1'; %'sift_int_ransac_stdcrt_iter_tictoc_total_constraints_confidence';
    if vro_cpp == 1
        fe_name = 'SIFT_SIFT';
        long_format = 0;
    else
        fe_name = 'sift_int_ransac_stdcrt_gc_num_aa_tictoc_total_constraints_confidence_indexplus1'; %'sift_int_ransac_stdcrt_iter_tictoc_total_confidence_indexplus1'; %'sift_int_ransac_stdcrt_gc_num_aa_tictoc_total_constraints_confidence_indexplus1'; %'sift_int_ransac_stdcrt_iter_tictoc_total_confidence_indexplus1';
        long_format = 1;
    end
elseif data_index == 14  % loops2
    switch vro_name
        case 'vro'
            if dynamic_data_index == 1 || dynamic_data_index == 3 || dynamic_data_index == 6
                if strcmp(isgframe, 'gframe')
                    fe_name = 'sift_i_r_s_i_t_t_c_i_adapthisteq_cf_cov_featureidxfix_fast_fast_gframe';
                else
                    %fe_name = 'sift_i_r_s_i_t_t_c_i_a_c_c_featureidxfix_fast_fast_dist2_nobpc';
                    fe_name = 'sift_i_r_s_i_t_t_c_i_a_c_c_f_fast_fast_dist2_30step_nobpc';
                    %fe_name = 'sift_i_r_s_i_t_t_c_i_a_c_c_featureidxfix_fast_fast_dist2_min13';
                    %fe_name = 'sift_i_r_s_i_t_t_c_i_a_c_c_featureidxfix_fast_fast_dist2';
                    %fe_name = 'sift_i_r_s_i_t_t_c_i_a_c_c_featureidxfix_fast_fast_dist';
                    %fe_name = 'sift_i_r_s_i_t_t_c_i_a_cf_cov_featureidxfix_fast_fast'; %; %'sift_i_r_s_i_t_t_c_i_a_cf_cov_featureidxfix_fast_fast'; % %'sift_int_ransac_stdcrt_iter_tictoc_total_confidence_indexplus1_adapthisteq_cf_cov_featureidxfix_fast'; %; 
                    %fe_name = 'sift_int_ransac_stdcrt_iter_tictoc_total_confidence_indexplus1_adapthisteq_cf_cov_maxstep_featureidx';
                end
            else
                %fe_name = 'sift_i_r_s_i_t_t_c_i_a_c_c_featureidxfix_fast_fast_dist2_nobpc';
                fe_name = 'sift_i_r_s_i_t_t_c_i_a_c_c_f_fast_fast_dist2_30step_nobpc';
                %fe_name = 'sift_i_r_s_i_t_t_c_i_a_c_c_featureidxfix_fast_fast_dist2';
                %fe_name = 'sift_i_r_s_i_t_t_c_i_a_c_c_featureidxfix_fast_fast_dist2_min13';
                %fe_name = 'sift_i_r_s_i_t_t_c_i_a_c_c_featureidxfix_fast_fast_dist3';
                %fe_name = 'sift_i_r_s_i_t_t_c_i_a_c_c_featureidxfix_fast_fast_dist';
                %fe_name = 'sift_i_r_s_i_t_t_c_i_a_cf_cov_featureidxfix_fast_fast'; %'sift_int_ransac_stdcrt_iter_tictoc_total_confidence_indexplus1_adapthisteq_cf_cov_maxstep_featureidxfix'; %'sift_int_ransac_stdcrt_iter_tictoc_total_confidence_indexplus1_adapthisteq_cf_cov_maxstep_featureidxfix';  %%'sift_int_ransac_stdcrt_iter_tictoc_total_confidence_indexplus1_adapthisteq_cf'; % %'sift_int_ransac_stdcrt_iter_tictoc_total_confidence_indexplus1_adapthisteq'; %'sift_int_ransac_stdcrt_iter_tictoc_total_confidence_indexplus1_adapthisteq_cf'; %'sift_int_ransac_stdcrt_iter_tictoc_total_confidence_indexplus1_adapthisteq';
                %fe_name = 'sift_int_ransac_stdcrt_iter_tictoc_total_confidence_indexplus1_adapthisteq_cf_cov_maxstep_featureidx';
                %fe_name = 'sift_int_ransac_stdcrt_iter_tictoc_total_confidence_indexplus1_adapthisteq_cf_cov_maxstep_featureidxfix';
            end
        case 'vro_icp'
            %fe_name = 'sift_int_ransac_stdcrt_iter_tictoc_total_confidence_indexplus1_adapthisteq_cf_cov_ransac_cf05_icp6_featureidxfix_10step'; %'sift_int_ransac_stdcrt_iter_tictoc_total_confidence_indexplus1_adapthisteq_cf_cov_noransac_icp6'; %'sift_int_ransac_stdcrt_iter_tictoc_total_confidence_icp6_indexplus1_adapthisteq_cf';
            if dynamic_data_index == 12
                fe_name = 'sift_i_r_s_i_t_t_c_i_a_c_c_r_cf05_icp6_featureidxfix_maxstep_fast_fast_dist2_loadicp';
            else
                fe_name = 'sift_int_ransac_stdcrt_iter_tictoc_total_confidence_indexplus1_adapthisteq_cf_cov_ransac_cf05_icp6_featureidxfix';
            end
        case 'vro_icp_ch'
            if dynamic_data_index == 1 || dynamic_data_index == 5
                fe_name = 'sift_i_r_s_i_t_t_c_i_a_c_c_r_cf05_icp9_batch_f_tol01_fast_fast_dist2_loadicp_30step_nobpc';
                %fe_name = 'sift_i_r_s_i_t_t_c_i_a_c_c_r_cf05_icp9_batch_featureidxfix_tol01_maxstep_fast_fast_dist2_min19';
                %fe_name = 'sift_i_r_s_i_t_t_c_i_a_c_c_r_cf05_icp9_batch_featureidxfix_tol01_maxstep_fast_fast_dist';
                %fe_name = 'sift_i_r_s_i_t_t_c_i_a_cf_cov_ransac_cf05_icp9_featureidxfix_tol01_maxstep_fast_fast'; %'sift_i_r_s_i_t_t_c_i_a_cf_cov_ransac_cf05_icp9_featureidxfix_tol01_maxstep_fast_fast_original';% %'sift_i_r_s_i_t_t_c_i_adapthisteq_cf_cov_ransac_cf05_icp9_batch_featureidxfix_tol01_maxstep_original'; % % % % %
                %fe_name = 'sift_i_r_s_i_t_t_c_i_a_cf_cov_ransac_cf05_icp9_featureidxfix_tol01_maxstep';
                %fe_name = 'sift_i_r_s_i_t_t_c_i_adapthisteq_cf_cov_ransac_cf05_icp9_batch_featureidxfix_tol01_maxstep';
            elseif dynamic_data_index == 12
                fe_name = 'sift_i_r_s_i_t_t_c_i_a_c_c_r_cf05_icp9_batch_featureidxfix_tol01_maxstep_fast_fast_dist2_loadicp';    
            else
                fe_name = 'sift_i_r_s_i_t_t_c_i_a_c_c_r_cf05_icp9_batch_f_tol01_fast_fast_dist2_loadicp_30step_nobpc';
                %fe_name = 'sift_i_r_s_i_t_t_c_i_a_c_c_r_cf05_icp9_batch_featureidxfix_tol01_maxstep_fast_fast_dist';
                %fe_name = 'sift_i_r_s_i_t_t_c_i_a_cf_cov_ransac_cf05_icp9_featureidxfix_tol01_maxstep_fast_fast'; 
                %fe_name = 'sift_i_r_s_i_t_t_c_i_a_cf_cov_ransac_cf05_icp9_featureidxfix_tol01_maxstep'; %'sift_i_r_s_i_t_t_c_i_a_cf_cov_ransac_cf05_icp9_featureidxfix_tol01_maxstep_fast_fast'; %;%'sift_i_r_s_i_t_t_c_i_adapthisteq_cf_cov_ransac_cf05_icp9_batch_featureidxfix_tol01_10step';% 'sift_i_r_s_i_t_t_c_i_adapthisteq_cf_cov_ransac_cf05_icp9_batch_featureidxfix_tol01_10step'; %'sift_int_ransac_stdcrt_iter_tictoc_total_confidence_indexplus1_adapthisteq_cf_cov_ransac_cf05_icp9_featureidxfix_maxstep'; %'sift_int_ransac_stdcrt_iter_tictoc_total_confidence_indexplus1_adapthisteq_cf_cov_ransac_cf05_icp9_featureidxfix_tol01'; %'sift_i_r_s_i_t_t_c_i_a_cf_cov_ransac_cf05_icp9_featureidxfix_tol01'; %'sift_int_ransac_stdcrt_iter_tictoc_total_confidence_indexplus1_adapthisteq_cf_cov_noransac_icp9'; %'sift_int_ransac_stdcrt_iter_tictoc_total_confidence_icp9_indexplus1_adapthisteq_cf';
            end
        case 'icp'
    end
    long_format = 0;
elseif data_index == 16  % sparse_feature
    switch vro_name
        case 'vro'
%             if dynamic_data_index == 1 || dynamic_data_index == 3 || dynamic_data_index == 5 || dynamic_data_index == 9 || dynamic_data_index == 11
%                 if strcmp(isgframe, 'gframe')
%                     fe_name = 'sift_i_r_s_i_t_t_c_i_adapthisteq_cf_cov_featureidxfix_fast_fast_gframe'; % single step size
%                 else
%                     fe_name = 'sift_i_r_s_i_t_t_c_i_a_c_c_featureidxfix_fast_fast_dist2_10step';
%                     %fe_name = 'sift_int_ransac_stdcrt_iter_tictoc_total_confidence_indexplus1_adapthisteq_cf_cov_featureidxfix_fast';
%                     
%                 end
%             elseif dynamic_data_index == 6
%                 fe_name = 'sift_i_r_s_i_t_t_c_i_a_c_c_featureidxfix_fast_fast_dist2_10step';
%             else
%                 %fe_name = 'sift_i_r_s_i_t_t_c_i_a_c_c_featureidxfix_fast_fast_dist2_min13';
%                 %fe_name = 'sift_i_r_s_i_t_t_c_i_a_c_c_featureidxfix_fast_fast_dist3';
%                 fe_name = 'sift_i_r_s_i_t_t_c_i_a_c_c_featureidxfix_fast_fast_dist';
%                 %fe_name = 'sift_i_r_s_i_t_t_c_i_a_cf_cov_featureidxfix_fast_fast'; %'sift_int_ransac_stdcrt_iter_tictoc_total_confidence_indexplus1_adapthisteq_cf_cov_maxstep_featureidxfix'; %'sift_int_ransac_stdcrt_iter_tictoc_total_confidence_indexplus1_adapthisteq_cf_cov_maxstep_featureidxfix';  %%'sift_int_ransac_stdcrt_iter_tictoc_total_confidence_indexplus1_adapthisteq_cf'; % %'sift_int_ransac_stdcrt_iter_tictoc_total_confidence_indexplus1_adapthisteq'; %'sift_int_ransac_stdcrt_iter_tictoc_total_confidence_indexplus1_adapthisteq_cf'; %'sift_int_ransac_stdcrt_iter_tictoc_total_confidence_indexplus1_adapthisteq';
%                 %fe_name = 'sift_int_ransac_stdcrt_iter_tictoc_total_confidence_indexplus1_adapthisteq_cf_cov_maxstep_featureidx';
%                 %fe_name = 'sift_int_ransac_stdcrt_iter_tictoc_total_confidence_indexplus1_adapthisteq_cf_cov_maxstep_featureidxfix';
%             end
            fe_name = 'sift_i_r_s_i_t_t_c_i_a_c_c_f_fast_fast_dist2_30step_nobpc';
        case 'vro_icp'
            if dynamic_data_index == 6 || dynamic_data_index == 5 || dynamic_data_index == 9 || dynamic_data_index == 11
                fe_name = 'sift_i_r_s_i_t_t_c_i_a_c_c_r_cf05_icp6_featureidxfix_maxstep_fast_fast_dist2_loadicp_10step';
            else
            %fe_name = 'sift_int_ransac_stdcrt_iter_tictoc_total_confidence_indexplus1_adapthisteq_cf_cov_ransac_cf05_icp6_featureidxfix'; % single step size
            fe_name = 'sift_i_r_s_i_t_t_c_i_a_c_c_r_cf05_icp6_featureidxfix_10step';
            %fe_name = 'sift_int_ransac_stdcrt_iter_tictoc_total_confidence_indexplus1_adapthisteq_cf_cov_ransac_cf05_icp6_featureidxfix_10step';
            %fe_name = 'sift_int_ransac_stdcrt_iter_tictoc_total_confidence_indexplus1_adapthisteq_cf_cov_ransac_cf05_icp6_featureidxfix_10step'; %'sift_int_ransac_stdcrt_iter_tictoc_total_confidence_indexplus1_adapthisteq_cf_cov_noransac_icp6'; %'sift_int_ransac_stdcrt_iter_tictoc_total_confidence_icp6_indexplus1_adapthisteq_cf';
            %fe_name = 'sift_int_ransac_stdcrt_iter_tictoc_total_confidence_indexplus1_adapthisteq_cf_cov_ransac_cf05_icp6_featureidxfix';
            end
        case 'vro_icp_ch'
%             if dynamic_data_index == 1 || dynamic_data_index == 3 
%                 %fe_name = 'sift_i_r_s_i_t_t_c_i_a_c_c_r_cf05_icp9_batch_featureidxfix_tol03_maxstep_fast_fast_dist2_loadicp_10step';
%                 %fe_name = 'sift_i_r_s_i_t_t_c_i_a_c_c_r_cf05_icp9_featureidxfix_tol01_10step';
%                 fe_name = 'sift_i_r_s_i_t_t_c_i_adapthisteq_cf_cov_ransac_cf05_icp9_batch_featureidxfix_tol01_10step';
%                 %fe_name = 'sift_i_r_s_i_t_t_c_i_a_c_c_r_cf05_icp9_featureidxfix_tol01'; % single step size
%                 %fe_name = 'sift_i_r_s_i_t_t_c_i_a_c_c_r_cf05_icp9_batch_featureidxfix_tol01_maxstep_fast_fast_dist2_min19';
%                 %fe_name = 'sift_i_r_s_i_t_t_c_i_a_c_c_r_cf05_icp9_batch_featureidxfix_tol01_maxstep_fast_fast_dist';
%                 %fe_name = 'sift_i_r_s_i_t_t_c_i_a_cf_cov_ransac_cf05_icp9_featureidxfix_tol01_maxstep_fast_fast'; %'sift_i_r_s_i_t_t_c_i_a_cf_cov_ransac_cf05_icp9_featureidxfix_tol01_maxstep_fast_fast_original';% %'sift_i_r_s_i_t_t_c_i_adapthisteq_cf_cov_ransac_cf05_icp9_batch_featureidxfix_tol01_maxstep_original'; % % % % %
%                 %fe_name = 'sift_i_r_s_i_t_t_c_i_a_cf_cov_ransac_cf05_icp9_featureidxfix_tol01_maxstep';
%                 %fe_name = 'sift_i_r_s_i_t_t_c_i_adapthisteq_cf_cov_ransac_cf05_icp9_batch_featureidxfix_tol01_maxstep';
%             elseif dynamic_data_index == 8
%                 %fe_name = 'sift_i_r_s_i_t_t_c_i_a_c_c_r_cf05_icp9_batch_featureidxfix_tol03_maxstep_fast_fast_dist2_loadicp_10step';
%                 fe_name = 'sift_i_r_s_i_t_t_c_i_a_c_c_r_cf05_icp9_batch_f_tol01_fast_fast_dist2_loadicp_10step_wicp6';
%             elseif dynamic_data_index == 11
%                 fe_name = 'sift_i_r_s_i_t_t_c_i_a_c_c_r_cf05_icp9_batch_f_tol01_fast_fast_dist2_loadicp_10step';
%                 %708_frame_abs_intensity_sift_i_r_s_i_t_t_c_i_a_c_c_r_cf05_icp9_batch_f_tol01_fast_fast_dist2_loadicp_10step
%             else
%                 fe_name = 'sift_i_r_s_i_t_t_c_i_a_c_c_r_cf05_icp9_batch_featureidxfix_tol02_maxstep_fast_fast_dist';
%                 %fe_name = 'sift_i_r_s_i_t_t_c_i_a_cf_cov_ransac_cf05_icp9_featureidxfix_tol01_maxstep_fast_fast'; 
%                 %fe_name = 'sift_i_r_s_i_t_t_c_i_a_cf_cov_ransac_cf05_icp9_featureidxfix_tol01_maxstep'; %'sift_i_r_s_i_t_t_c_i_a_cf_cov_ransac_cf05_icp9_featureidxfix_tol01_maxstep_fast_fast'; %;%'sift_i_r_s_i_t_t_c_i_adapthisteq_cf_cov_ransac_cf05_icp9_batch_featureidxfix_tol01_10step';% 'sift_i_r_s_i_t_t_c_i_adapthisteq_cf_cov_ransac_cf05_icp9_batch_featureidxfix_tol01_10step'; %'sift_int_ransac_stdcrt_iter_tictoc_total_confidence_indexplus1_adapthisteq_cf_cov_ransac_cf05_icp9_featureidxfix_maxstep'; %'sift_int_ransac_stdcrt_iter_tictoc_total_confidence_indexplus1_adapthisteq_cf_cov_ransac_cf05_icp9_featureidxfix_tol01'; %'sift_i_r_s_i_t_t_c_i_a_cf_cov_ransac_cf05_icp9_featureidxfix_tol01'; %'sift_int_ransac_stdcrt_iter_tictoc_total_confidence_indexplus1_adapthisteq_cf_cov_noransac_icp9'; %'sift_int_ransac_stdcrt_iter_tictoc_total_confidence_icp9_indexplus1_adapthisteq_cf';
%             end
            fe_name = 'sift_i_r_s_i_t_t_c_i_a_c_c_r_cf05_icp9_batch_f_tol01_fast_fast_dist2_loadicp_30step_nobpc';
        case 'icp'
    end
    long_format = 0;
elseif data_index == 17  % swing
    %fe_name = 'sift_i_r_s_i_t_t_c_i_a_cf_cov_featureidxfix_fast_fast';
    switch vro_name
        case 'vro'
            %fe_name = 'sift_i_r_s_i_t_t_c_i_a_c_c_f_fast_fast_dist2_30step_nobpc';
            %fe_name = 'sift_i_r_s_i_t_t_c_i_a_c_c_featureidxfix_fast_fast_dist2';
            fe_name = 'sift_i_r_s_i_t_t_c_i_a_c_c_featureidxfix_fast_fast_dist2_nobpc';
            %fe_name = 'sift_i_r_s_i_t_t_c_i_a_c_c_featureidxfix_fast_fast_dist2_nobpc_svde6';
%             if dynamic_data_index == 1 || dynamic_data_index == 2
%                 
%                 fe_name = 'sift_i_r_s_i_t_t_c_i_a_c_c_featureidxfix_fast_fast_dist2_min40'
%                 fe_name = 'sift_i_r_s_i_t_t_c_i_adapthisteq_cf_cov_featureidxfix_fast_fast';
%                 fe_name = 'sift_i_r_s_i_t_t_c_i_a_c_c_featureidxfix_fast_fast_dist';
%                 fe_name = 'sift_i_r_s_i_t_t_c_i_a_c_c_featureidxfix_fast_fast_dist2_min19';
%                 fe_name = 'sift_i_r_s_i_t_t_c_i_a_c_c_featureidxfix_fast_fast_dist_min40';
%                 fe_name = 'sift_i_r_s_i_t_t_c_i_a_c_c_featureidxfix_fast_fast_dist_lc_min40';
%                 fe_name = 'sift_i_r_s_i_t_t_c_i_a_c_c_featureidxfix_fast_fast_dist2_min19_lc';
%             else
%                 fe_name = 'sift_i_r_s_i_t_t_c_i_a_c_c_featureidxfix_fast_fast_dist2_min40_histeq_lc';
%                 fe_name = 'sift_i_r_s_i_t_t_c_i_a_c_c_featureidxfix_fast_fast_dist2_min40_histeq_server';
%                 fe_name = 'sift_i_r_s_i_t_t_c_i_a_c_c_featureidxfix_fast_fast_dist2_min40_lc';
%                 fe_name = 'sift_i_r_s_i_t_t_c_i_a_c_c_featureidxfix_fast_fast_dist2_min40'
%                 fe_name = 'sift_i_r_s_i_t_t_c_i_a_c_c_featureidxfix_fast_fast_dist2_min13';
%                 fe_name = 'sift_i_r_s_i_t_t_c_i_a_c_c_featureidxfix_fast_fast_dist';
%             end
        case 'vro_icp'
            fe_name = 'sift_i_r_s_i_t_t_c_i_a_c_c_r_cf05_icp6_featureidxfix_maxstep_fast_fast_dist2';
        case 'vro_icp_ch'
            fe_name = 'sift_i_r_s_i_t_t_c_i_a_c_c_r_cf05_icp9_batch_featureidxfix_tol04_maxstep_fast_fast_dist2';
    end
    long_format = 0;
elseif data_index == 18  % swing2
    %fe_name = 'sift_i_r_s_i_t_t_c_i_a_cf_cov_featureidxfix_fast_fast';
    switch vro_name
        case 'vro'
            fe_name = 'sift_i_r_s_i_t_t_c_i_a_c_c_featureidxfix_fast_fast_dist2';         
        case 'vro_icp'
            fe_name = 'sift_i_r_s_i_t_t_c_i_a_c_c_r_cf05_icp6_featureidxfix_maxstep_fast_fast_dist2_loadicp';
        case 'vro_icp_ch'
            fe_name = 'sift_i_r_s_i_t_t_c_i_a_c_c_r_cf05_icp9_batch_featureidxfix_tol01_maxstep_fast_fast_dist2_loadicp';
    end
    long_format = 0;
elseif data_index == 19  % motive
    %fe_name = 'sift_i_r_s_i_t_t_c_i_a_cf_cov_featureidxfix_fast_fast';
    switch vro_name
        case 'vro'
            fe_name = 'sift_i_r_s_i_t_t_c_i_a_c_c_featureidxfix_fast_fast_dist2_nobpc';         
            %fe_name = 'sift_i_r_s_i_t_t_c_i_a_c_c_featureidxfix_fast_fast_dist2_nobpc_10m';         
        case 'vro_icp'
            fe_name = 'sift_i_r_s_i_t_t_c_i_a_c_c_r_cf05_icp6_featureidxfix_maxstep_fast_fast_dist2_loadicp';
        case 'vro_icp_ch'
            %fe_name = 'sift_i_r_s_i_t_t_c_i_a_c_c_r_cf05_icp9_batch_featureidxfix_tol01_maxstep_fast_fast_dist2_loadicp';
            fe_name = 'sift_i_r_s_i_t_t_c_i_a_c_c_r_cf05_icp9_batch_f_tol01_fast_fast_dist2_loadicp_30step_nobpc';
    end
    long_format = 0;    
elseif data_index == 20  % object_recognition
    %fe_name = 'sift_i_r_s_i_t_t_c_i_a_cf_cov_featureidxfix_fast_fast';
    switch vro_name
        case 'vro'
            %fe_name = 'sift_i_r_s_i_t_t_c_i_a_c_c_featureidxfix_fast_fast_dist2_nobpc_20st';     
            fe_name = 'sift_i_r_s_i_t_t_c_i_a_c_c_featureidxfix_fast_fast_dist2_nobpc';
        case 'vro_icp'
            fe_name = 'sift_i_r_s_i_t_t_c_i_a_c_c_r_cf05_icp6_featureidxfix_maxstep_fast_fast_dist2_loadicp';
        case 'vro_icp_ch'
            fe_name = 'sift_i_r_s_i_t_t_c_i_a_c_c_r_cf05_icp9_batch_featureidxfix_tol01_maxstep_fast_fast_dist2_loadicp';
    end
    long_format = 0;
elseif data_index == 21  % map
    %fe_name = 'sift_i_r_s_i_t_t_c_i_a_cf_cov_featureidxfix_fast_fast';
    switch vro_name
        case 'vro'
            fe_name = 'sift_i_r_s_i_t_t_c_i_a_c_c_featureidxfix_fast_fast_dist2_nobpc';         
        case 'vro_icp'
            fe_name = 'sift_i_r_s_i_t_t_c_i_a_c_c_r_cf05_icp6_featureidxfix_maxstep_fast_fast_dist2_loadicp';
        case 'vro_icp_ch'
            fe_name = 'sift_i_r_s_i_t_t_c_i_a_c_c_r_cf05_icp9_batch_f_tol01_fast_fast_dist2_loadicp_30step_nobpc';
    end
    long_format = 0;
elseif data_index == 15  % amir_vro
    switch vro_name
        case 'vro'
            fe_name = 'amir_vro'; %'sift_int_ransac_stdcrt_iter_tictoc_total_confidence_indexplus1_adapthisteq_cf'; % %'sift_int_ransac_stdcrt_iter_tictoc_total_confidence_indexplus1_adapthisteq'; %'sift_int_ransac_stdcrt_iter_tictoc_total_confidence_indexplus1_adapthisteq_cf'; %'sift_int_ransac_stdcrt_iter_tictoc_total_confidence_indexplus1_adapthisteq';
        case 'vro_icp'
            fe_name = 'amir_vro_icp6'; %'sift_int_ransac_stdcrt_iter_tictoc_total_confidence_indexplus1_adapthisteq_cf_cov_noransac_icp6'; %'sift_int_ransac_stdcrt_iter_tictoc_total_confidence_icp6_indexplus1_adapthisteq_cf';
        case 'vro_icp_ch'
            fe_name = 'amir_vro_icp9'; %'sift_int_ransac_stdcrt_iter_tictoc_total_confidence_indexplus1_adapthisteq_cf_cov_noransac_icp9'; %'sift_int_ransac_stdcrt_iter_tictoc_total_confidence_icp9_indexplus1_adapthisteq_cf';
        case 'icp'
    end
    long_format = 0;
% elseif nFrame == 659
%     fe_name = 'sift_int_ransac_stdcrt_gc_num_aa_tictoc_total_constraints_confidence_icp5_intensity';
%     long_format = 1; %1; % 1 = geometric constraints; 0=Others
% elseif nFrame == 427
%     fe_name = 'sift_int_ransac_stdcrt_gc_num_aa_tictoc_total_constraints_confidence_indexplus1';
%     long_format =1;
% elseif nFrame == 118 || nFrame == 108
%     fe_name = 'sift_int_ransac_stdcrt_gc_num_aa_tictoc_total_constraints_confidence_indexplus1_minlength';
%     long_format =1;
% elseif nFrame == 249
%     fe_name = 'int_tictoc_total_confidence_icp7_intensity';
%     long_format =0;
else
    fe_name = 'sift_int_ransac_stdcrt_gc_num_aa_tictoc_total_constraints_confidence'; %'sift_int_ransac_stdcrt_gc_num_aa_tictoc_total_constraints_confidence_icp6_indexplus1'; % %; % %; % % % % %
    long_format = 1; %1; % 1 = geometric constraints; 0=Others
end
legend_name_set={{'SIFT'},{'SURF Gaussian ', 'SURF cpp'},{'SIFT Gaussian', 'SURF Gaussian'}}; %,'SIFT 400ms'}; %{'SIFT 400ms', 'SIFT INT 400ms'}; %{'SIFT STC','SIFT INT STC'}; %{'SIFT 700','SIFT INT 700'}; %'SIFT STC','SIFT STEV'}; %,'SIFT STC','SIFT 400ms'}; %,'SIFT 400ms' 'surf ransac 20000', 'surf ransac stdcrt'{'sift','sift ransac std crt','sift inlier driven'};%,'surf inlier driven'}; %consensus_name; %fe_name; %image_name; %filter_list;
%, 'SURF STC', 'SURF 400ms'}; %{'SURF 400ms', 'SURF INT 400ms'}; %{'SURF STC', 'SURF INT STC'}; %{'SURF', 'SURF INT'}; %'SURF STC','SURF STDEV'}; %,'SURF STC','SURF 400ms'}; % ,,'SURF STC'
number_long_format = 2; % Number of long format
is_frame_index = 1;  % 0 : frame index does not exist, 1: frame index exists

switch data_name{data_index}
    case {'pitch', 'pitch2'}
        maxData = 28; % 11
        inc_max = 9; %6; %9; %11;   % 3 * 11 = 33 << 34 degree of FOV
        interval = angle_interval;
        unit='degree';
        movement_name = 'Pitch';
    case 'pan'
        maxData = 29;
        inc_max = 11; %14;   % 3 * 14 = 42 << 43 degree of FOV
        interval = angle_interval;
        unit='degree';
        movement_name = 'Yaw';
    case 'roll'
        maxData = 9;
        inc_max = 6;
        interval = angle_interval;
        unit='degree';
        movement_name = 'Roll';
    case 'x'
        maxData = 13;
        inc_max = 2; %3; %maxData-1;
        interval = translation_interval;
        unit='mm';
        movement_name = 'X';
    case 'y'
        maxData = 11;
        inc_max = 2; %maxData-3; %maxData-1;
        interval = translation_interval;
        unit='mm';
        movement_name = 'Y';
    case 'x2'
        maxData = 6;
        inc_max = 5; %maxData-1;
        unit='mm';
        interval = translation_interval_2;
        movement_name = 'X';
    case 'y2'
        maxData = 9;
        inc_max = 6; %maxData-1;
        unit='mm';
        interval = translation_interval_2;
        movement_name = 'Y';
    case 'c1'
        maxData = 4;
        inc_max = 1;
        unit='degree degree mm';
        dir_name = {'y-3_p6_x100','y-6_p12_x500','y-12_p9_x300'};
        interval = c1_movement;
        movement_name = 'Yaw,Pitch and X';
    case 'c2'
        maxData = 4;
        inc_max = maxData-1;
        unit='degree degree mm';
        dir_name = {'y-6_p3_y200','y-9_p12_y400','y-12_p6_y600'};
        interval = c2_movement;
        movement_name = 'Yaw,Pitch and Y';
    case 'c3'
        maxData = 5;
        inc_max = maxData-1;
        unit='degree degree mm';
        dir_name = {'y3_p12_x100','y6_p9_x200','y9_p6_x300','y12_p3_x400'};
        interval = c3_movement;
        movement_name = 'Yaw,Pitch and X';
    case 'c4'
        maxData = 2;convert_vro_g2o(data_index, dis)
        inc_max = maxData-1;
        unit='degree degree mm';
        dir_name = {'y-3_p9_y300'};
        interval = c4_movement;
        movement_name = 'Yaw,Pitch and Y';
    case 'm'
        inc_max = 1; 
        inc_min = inc_max;
        %nFrame = nFrame_list(dynamic_data_index) - 1;
        unit = 'degree';
        %dir_name = {'x_500qc','pitch_10degree','pitch_3degree','pan_3degree','pan_10degree','x_1mm','x_10mm','x_5mm'};
        dir_name={'pitch_3degree','pitch_9degree','pan_3degree','pan_9degree','pan_30degree','pan_60degree','roll_3degree','roll_9degree','x_30mm','x_150mm','x_300mm','y_30mm','y_150mm','y_300mm','square_500','square_700','square_swing','square_1000','test'};
        interval = 0;
        movement_name = 'pitch';
        %velocity = [3 9 3 9 3 9 1 5 10 1 5 10]
        start_frame = [11 8 11 8 8 6 11 11 11 8 6 21 8 8 40 40 50 101];
        finish_frame = [70 25 70 25 16 11 135 50 150 35 21 150 35 22 316 376 397 130]; %316
        %nFrame = finish_frame(dynamic_data_index) - start_frame(dynamic_data_index) - 1;
        %nFrame = 829; %270;
    case 'etas'
        inc_max = 1; 
        inc_min = inc_max;
        %nFrame = nFrame_list(dynamic_data_index) - 1;
        unit = 'degree';
        %dir_name = {'x_500qc','pitch_10degree','pitch_3degree','pan_3degree','pan_10degree','x_1mm','x_10mm','x_5mm'};
        dir_name={'3th_straight','3th_swing','4th_straight','4th_swing','5th_straight','5th_swing'};
        interval = 0;
    case 'loops'
        inc_max = 1; 
        inc_min = inc_max;
        %nFrame = nFrame_list(dynamic_data_index) - 1;
        unit = 'degree';
        %dir_name = {'x_500qc','pitch_10degree','pitch_3degree','pan_3degree','pan_10degree','x_1mm','x_10mm','x_5mm'};
        dir_name={'bus','bus_3','bus_door_straight_150','bus_straight_150','data_square_small_100','eit_data_150','exp1','exp2','exp3','exp4','exp5','lab_80_dynamic_1','lab_80_swing_1','lab_it_80','lab_lookforward_4','s2','second_floor_150_not_square','second_floor_150_square','second_floor_small_80_swing','third_floor_it_150'};
        interval = 0;
     case {'loops2','amir_vro'}
        inc_max = 1; 
        inc_min = inc_max;
        %nFrame = nFrame_list(dynamic_data_index) - 1;
        unit = 'degree';
        %dir_name = {'x_500qc','pitch_10degree','pitch_3degree','pan_3degree','pan_10degree','x_1mm','x_10mm','x_5mm'};
        dir_name= get_loops2_filename(); %{'exp4','bus_','bus_3','bus_door_straight_150'};
        interval = 0;
    case {'sparse_feature'}
        inc_max = 1; 
        inc_min = inc_max;
        %nFrame = nFrame_list(dynamic_data_index) - 1;
        unit = 'degree';
        %dir_name = {'x_500qc','pitch_10degree','pitch_3degree','pan_3degree','pan_10degree','x_1mm','x_10mm','x_5mm'};
        dir_name= get_sparse_feature_filename(); %{'exp4','bus_','bus_3','bus_door_straight_150'};
        interval = 0;
    case {'swing'}
        inc_max = 1; 
        inc_min = inc_max;
        %nFrame = nFrame_list(dynamic_data_index) - 1;
        unit = 'degree';
        %dir_name = {'x_500qc','pitch_10degree','pitch_3degree','pan_3degree','pan_10degree','x_1mm','x_10mm','x_5mm'};
        dir_name= get_dir_name(data_name{data_index}); %{'exp4','bus_','bus_3','bus_door_straight_150'};
        interval = 0;
    case {'swing2'}
        inc_max = 1; 
        inc_min = inc_max;
        %nFrame = nFrame_list(dynamic_data_index) - 1;
        unit = 'degree';
        %dir_name = {'x_500qc','pitch_10degree','pitch_3degree','pan_3degree','pan_10degree','x_1mm','x_10mm','x_5mm'};
        dir_name= get_dir_name(data_name{data_index}); %{'exp4','bus_','bus_3','bus_door_straight_150'};
        interval = 0;
     case {'motive'}
        inc_max = 1; 
        inc_min = inc_max;
        %nFrame = nFrame_list(dynamic_data_index) - 1;
        unit = 'degree';
        %dir_name = {'x_500qc','pitch_10degree','pitch_3degree','pan_3degree','pan_10degree','x_1mm','x_10mm','x_5mm'};
        dir_name= get_dir_name(data_name{data_index}); %{'exp4','bus_','bus_3','bus_door_straight_150'};
        interval = 0;
    case {'object_recognition'}
        inc_max = 1; 
        inc_min = inc_max;
        %nFrame = nFrame_list(dynamic_data_index) - 1;
        unit = 'degree';
        %dir_name = {'x_500qc','pitch_10degree','pitch_3degree','pan_3degree','pan_10degree','x_1mm','x_10mm','x_5mm'};
        dir_name= get_dir_name(data_name{data_index}); %{'exp4','bus_','bus_3','bus_door_straight_150'};
        interval = 0;
    case {'map'}
        inc_max = 1; 
        inc_min = inc_max;
        %nFrame = nFrame_list(dynamic_data_index) - 1;
        unit = 'degree';
        %dir_name = {'x_500qc','pitch_10degree','pitch_3degree','pan_3degree','pan_10degree','x_1mm','x_10mm','x_5mm'};
        dir_name= get_dir_name(data_name{data_index}); %{'exp4','bus_','bus_3','bus_door_straight_150'};
        interval = 0;
    case 'kinect_tum'
        inc_max = 1; 
        inc_min = inc_max;
        %nFrame = nFrame_list(dynamic_data_index) - 1;
        unit = 'degree';
        %dir_name = {'x_500qc','pitch_10degree','pitch_3degree','pan_3degree','pan_10degree','x_1mm','x_10mm','x_5mm'};
        if vro_cpp == 1
            dir_name=get_kinect_tum_dir_name_vro_cpp();
        else
            dir_name=get_kinect_tum_dir_name();
        end
        
        interval = 0;
    otherwise
        disp('Data name is unknown.');
        return;
end


abs_error=cell(inc_max*length(image_name)*length(filter_list)*length(consensus_name),1);

% o_y_label = {'Relative Angle [degree]', 'Standard Deviation [degree]','Error with Standard Deviation [degree]'};
% t_y_label = {'Relative translation [mm]', 'Standard Deviation [mm]','Error with Standard Deviation [mm]'};

%Read the result file.
file_index = 1;
for img_index = 1:length(image_name)
    for filter_index=1:length(filter_list)
        for fe_index=1:1
            for con_index=1:length(consensus_name)
                for inc = inc_min: inc_max
%                     if inc == 1 && fe_index ==2
%                         nFrame = 10; %322; %530; %19;
%                     elseif inc == 2 && fe_index ==2
%                         nFrame = 130; %540;
%                     elseif inc == 3 && fe_index ==2
%                         nFrame = 540;
%                     elseif inc == 4 && fe_index ==2
%                         nFrame = 38; %540;
%                     end
%                     elseif inc == 6 && fe_index ==2
%                         nFrame = 247;
%                     end
                    switch image_name{img_index}
                        case 'intensity'
                            switch filter_list{filter_index}
                               case 'none'
                                    switch consensus_name
                                        case 'ransac'
                                            if data_index == 3 || nFrame == 1000
                                                % new file name format
                                                error_file_name = sprintf('result/%s/%d_%s/%d_frame_abs_%s_%s_%s_%d.dat',data_name{data_index},inc*interval,unit,nFrame,image_name{img_index},fe_name{fe_index},filter_list{filter_index},cut_off);
                                                %error_std_file_name = sprintf('result/%s/%d_%s/%d_frame_abs_%s_%s_%s_%d_std.dat',data_name{data_index},inc*interval,unit,nFrame,image_name{img_index},fe_name{fe_index},filter_list{filter_index},cut_off);
                                            else
                                                switch fe_name{fe_index}
                                                    case {'sift','surf'}
                                                        %old file name format
                                                        error_file_name = sprintf('result/%s/%d_%s/%d_frame_abs_%s.dat',data_name{data_index},inc*interval,unit,nFrame,fe_name{fe_index});
                                                        %error_std_file_name = sprintf('result/%s/%d_%s/%d_frame_abs_%s_std.dat',data_name{data_index},inc*interval,unit,nFrame,fe_name{fe_index});
                                                    case {'surf_nolimit','surf_ransac_limit_14000_11','sift_ransac_limit_14000_14','sift_ransac_std_crt','sift_ransac_stdcrt','sift_ransac_20000','sift_ransac_stdcrt_15p','sift_ransac_stdctr_stdev','surf_ransac_20000', 'surf_ransac_stdcrt','surf_ransac_stdctr_stdev','surf_ransac_stdcrt_stdev_linear','sift_ransac_450','surf_ransac_350','surf_ransac_300','sift_ransac_350','surf_ransac_200','sift_ransac_stable','sift_int','sift_int_ransac_stdcrt','sift_int_ransac_350','surf_int','surf_int_ransac_stdcrt','surf_int_ransac_200','surfcpp_int','surf_int_ransac_stdcrt_12','surf_int_ransac_stdcrt_t2','sift_int_ransac_stdcrt_gc_msdtc','sift_int_ransac_stdcrt_gc_num'}
                                                        % new file name format
                                                        error_file_name = sprintf('result/%s/%d_%s/%d_frame_abs_%s_%s_%s_%d.dat',data_name{data_index},inc*interval,unit,nFrame,image_name{img_index},fe_name{fe_index},filter_list{filter_index},cut_off);
                                                        %error_convert_vro_g2o(data_index, dis)std_file_name = sprintf('result/%s/%d_%s/%d_frame_abs_%s_%s_%s_%d_std.dat',data_name{data_index},inc*interval,unit,nFrame,image_name{img_index},fe_name{fe_index},filter_list{filter_index},cut_off);
                                                end
                                            end
                                        case {'gc','gc_30p','gc_20p','gc_40p','ggc_10p'}
%                                             switch error_std_index
%                                                 case 1
                                                    error_file_name = sprintf('result/%s/%d_%s/%d_frame_abs_%s_%s_%s_%d_%s.dat',data_name{data_index},inc*interval,unit,nFrame,image_name{img_index},fe_name{fe_index},filter_list{filter_index},cut_off); %,consensus_name{con_index});
%                                                 case 2
                                                   %error_std_file_name = sprintf('result/%s/%d_%s/%d_frame_abs_%s_%s_%s_%d_%s_std.dat',data_name{data_index},inc*interval,unit,nFrame,image_name{img_index},fe_name{fe_index},filter_list{filter_index},cut_off); %,consensus_name{con_index});
                                    end         
                                case {'median','gaussian','median5','gaussian5'}
                                    switch data_name{data_index}
                                        case {'c1', 'c2', 'c3', 'c4'} 
                                           error_file_name = sprintf('result/%s/%s/%d_frame_abs_%s_%s_%s_%d.dat',data_name{data_index},dir_name{inc},nFrame,image_name{img_index},fe_name{fe_index},filter_list{filter_index},cut_off);
                                            %error_std_file_nconvert_vro_g2o(data_index, dis)ame = sprintf('result/%s/%s/%d_frame_abs_%s_%s_%s_%d_std.dat',data_name{data_index},dir_name{inc},nFrame,image_name{img_index},fe_name{fe_index},filter_list{filter_index},cut_off);    
                                        case {'m','etas','loops','kinect_tum','loops2','amir_vro','sparse_feature','swing','swing2','motive','object_recognition','map'}
                                            if vro_cpp == 1
                                                error_file_name = sprintf('D:/soonhac/Project/PNBD/SW/ubuntu_backup/vro_result/%s/vro_cpp_%d_%s.dat',dir_name{dynamic_data_index},nFrame,fe_name);
                                            elseif with_lc_flag == 1  % typical LC
%                                                 error_file_name = sprintf('../Localization/result/%s/%s/%d_frame_abs_%s_%s_%s_%d_with_lc.dat',data_name{data_index},dir_name{dynamic_data_index},nFrame,image_name{img_index},fe_name,filter_list{filter_index},cut_off);
%                                                 feature_file_name = sprintf('../Localization/result/%s/%s/%d_frame_abs_%s_%s_%s_%d_feature_points_with_lc.dat',data_name{data_index},dir_name{dynamic_data_index},nFrame,image_name{img_index},fe_name,filter_list{filter_index},cut_off);
%                                                 pose_std_file_name = sprintf('../Localization/result/%s/%s/%d_frame_abs_%s_%s_%s_%d_pose_std_with_lc.dat',data_name{data_index},dir_name{dynamic_data_index},nFrame,image_name{img_index},fe_name,filter_list{filter_index},cut_off);
                                                
                                                error_file_name = sprintf('../Localization/result/%s/%s/%d_frame_abs_%s_%s_%s_%d_with_lc_2nghbr.dat',data_name{data_index},dir_name{dynamic_data_index},nFrame,image_name{img_index},fe_name,filter_list{filter_index},cut_off);
                                                feature_file_name = sprintf('../Localization/result/%s/%s/%d_frame_abs_%s_%s_%s_%d_feature_points_with_lc_2nghbr.dat',data_name{data_index},dir_name{dynamic_data_index},nFrame,image_name{img_index},fe_name,filter_list{filter_index},cut_off);
                                                pose_std_file_name = sprintf('../Localization/result/%s/%s/%d_frame_abs_%s_%s_%s_%d_pose_std_with_lc_2nghbr.dat',data_name{data_index},dir_name{dynamic_data_index},nFrame,image_name{img_index},fe_name,filter_list{filter_index},cut_off);
                                                
%                                                 error_file_name = sprintf('../Localization/result/%s/%s/%d_frame_abs_%s_%s_%s_%d_with_lc_2nghbr_20th.dat',data_name{data_index},dir_name{dynamic_data_index},nFrame,image_name{img_index},fe_name,filter_list{filter_index},cut_off);
%                                                 feature_file_name = sprintf('../Localization/result/%s/%s/%d_frame_abs_%s_%s_%s_%d_feature_points_with_lc_2nghbr_20th.dat',data_name{data_index},dir_name{dynamic_data_index},nFrame,image_name{img_index},fe_name,filter_list{filter_index},cut_off);
%                                                 pose_std_file_name = sprintf('../Localization/result/%s/%s/%d_frame_abs_%s_%s_%s_%d_pose_std_with_lc_2nghbr_20th.dat',data_name{data_index},dir_name{dynamic_data_index},nFrame,image_name{img_index},fe_name,filter_list{filter_index},cut_off);
%                                                 
%                                                 error_file_name = sprintf('../Localization/result/%s/%s/%d_frame_abs_%s_%s_%s_%d_with_lc_3nghbr.dat',data_name{data_index},dir_name{dynamic_data_index},nFrame,image_name{img_index},fe_name,filter_list{filter_index},cut_off);
%                                                 feature_file_name = sprintf('../Localization/result/%s/%s/%d_frame_abs_%s_%s_%s_%d_feature_points_with_lc_3nghbr.dat',data_name{data_index},dir_name{dynamic_data_index},nFrame,image_name{img_index},fe_name,filter_list{filter_index},cut_off);
%                                                 pose_std_file_name = sprintf('../Localization/result/%s/%s/%d_frame_abs_%s_%s_%s_%d_pose_std_with_lc_3nghbr.dat',data_name{data_index},dir_name{dynamic_data_index},nFrame,image_name{img_index},fe_name,filter_list{filter_index},cut_off);
                                                
%                                                 error_file_name = sprintf('../Localization/result/%s/%s/%d_frame_abs_%s_%s_%s_%d_with_lc_2nghbr_long_term.dat',data_name{data_index},dir_name{dynamic_data_index},nFrame,image_name{img_index},fe_name,filter_list{filter_index},cut_off);
%                                                 feature_file_name = sprintf('../Localization/result/%s/%s/%d_frame_abs_%s_%s_%s_%d_feature_points_with_lc_2nghbr_long_term.dat',data_name{data_index},dir_name{dynamic_data_index},nFrame,image_name{img_index},fe_name,filter_list{filter_index},cut_off);
%                                                 pose_std_file_name = sprintf('../Localization/result/%s/%s/%d_frame_abs_%s_%s_%s_%d_pose_std_with_lc_2nghbr_long_term.dat',data_name{data_index},dir_name{dynamic_data_index},nFrame,image_name{img_index},fe_name,filter_list{filter_index},cut_off);
%                                                 
                                                min_match_points_file_name = sprintf('../Localization/result/%s/%s/min_match_points_%d_with_lc.mat',data_name{data_index},dir_name{dynamic_data_index}, min_matched_points);
                                            elseif with_lc_flag == 2  % typical LC with neighbors
                                                error_file_name = sprintf('../Localization/result/%s/%s/%d_frame_abs_%s_%s_%s_%d_with_lc_wn.dat',data_name{data_index},dir_name{dynamic_data_index},nFrame,image_name{img_index},fe_name,filter_list{filter_index},cut_off);
                                                feature_file_name = sprintf('../Localization/result/%s/%s/%d_frame_abs_%s_%s_%s_%d_feature_points_with_lc_wn.dat',data_name{data_index},dir_name{dynamic_data_index},nFrame,image_name{img_index},fe_name,filter_list{filter_index},cut_off);
                                                pose_std_file_name = sprintf('../Localization/result/%s/%s/%d_frame_abs_%s_%s_%s_%d_pose_std_with_lc_wn.dat',data_name{data_index},dir_name{dynamic_data_index},nFrame,image_name{img_index},fe_name,filter_list{filter_index},cut_off);
                                                min_match_points_file_name = sprintf('../Localization/result/%s/%s/min_match_points_%d_with_lc_wn.mat',data_name{data_index},dir_name{dynamic_data_index}, min_matched_points);
                                            elseif with_lc_flag == 3  % fast LC
%                                                 error_file_name = sprintf('../Localization/result/%s/%s/%d_frame_abs_%s_%s_%s_%d_with_fast4_lc.dat',data_name{data_index},dir_name{dynamic_data_index},nFrame,image_name{img_index},fe_name,filter_list{filter_index},cut_off);
%                                                 feature_file_name = sprintf('../Localization/result/%s/%s/%d_frame_abs_%s_%s_%s_%d_feature_points_with_fast4_lc.dat',data_name{data_index},dir_name{dynamic_data_index},nFrame,image_name{img_index},fe_name,filter_list{filter_index},cut_off);
%                                                 pose_std_file_name = sprintf('../Localization/result/%s/%s/%d_frame_abs_%s_%s_%s_%d_pose_std_with_fast4_lc.dat',data_name{data_index},dir_name{dynamic_data_index},nFrame,image_name{img_index},fe_name,filter_list{filter_index},cut_off);
                                                
                                                error_file_name = sprintf('../Localization/result/%s/%s/%d_frame_abs_%s_%s_%s_%d_with_fast4_lc_2nghbr.dat',data_name{data_index},dir_name{dynamic_data_index},nFrame,image_name{img_index},fe_name,filter_list{filter_index},cut_off);
                                                feature_file_name = sprintf('../Localization/result/%s/%s/%d_frame_abs_%s_%s_%s_%d_feature_points_with_fast4_lc_2nghbr.dat',data_name{data_index},dir_name{dynamic_data_index},nFrame,image_name{img_index},fe_name,filter_list{filter_index},cut_off);
                                                pose_std_file_name = sprintf('../Localization/result/%s/%s/%d_frame_abs_%s_%s_%s_%d_pose_std_with_fast4_lc_2nghbr.dat',data_name{data_index},dir_name{dynamic_data_index},nFrame,image_name{img_index},fe_name,filter_list{filter_index},cut_off);
                                              
%                                                 error_file_name = sprintf('../Localization/result/%s/%s/%d_frame_abs_%s_%s_%s_%d_with_fast4_lc_2nghbr_20th.dat',data_name{data_index},dir_name{dynamic_data_index},nFrame,image_name{img_index},fe_name,filter_list{filter_index},cut_off);
%                                                 feature_file_name = sprintf('../Localization/result/%s/%s/%d_frame_abs_%s_%s_%s_%d_feature_points_with_fast4_lc_2nghbr_20th.dat',data_name{data_index},dir_name{dynamic_data_index},nFrame,image_name{img_index},fe_name,filter_list{filter_index},cut_off);
%                                                 pose_std_file_name = sprintf('../Localization/result/%s/%s/%d_frame_abs_%s_%s_%s_%d_pose_std_with_fast4_lc_2nghbr_20th.dat',data_name{data_index},dir_name{dynamic_data_index},nFrame,image_name{img_index},fe_name,filter_list{filter_index},cut_off);
                                                
                                                min_match_points_file_name = sprintf('../Localization/result/%s/%s/min_match_points_%d_with_fast4_lc.mat',data_name{data_index},dir_name{dynamic_data_index}, min_matched_points);
                                            elseif with_lc_flag == 4 % long-term LC
                                                error_file_name = sprintf('../Localization/result/%s/%s/%d_frame_abs_%s_%s_%s_%d_with_lc_2nghbr_long_term.dat',data_name{data_index},dir_name{dynamic_data_index},nFrame,image_name{img_index},fe_name,filter_list{filter_index},cut_off);
                                                feature_file_name = sprintf('../Localization/result/%s/%s/%d_frame_abs_%s_%s_%s_%d_feature_points_with_lc_2nghbr_long_term.dat',data_name{data_index},dir_name{dynamic_data_index},nFrame,image_name{img_index},fe_name,filter_list{filter_index},cut_off);
                                                pose_std_file_name = sprintf('../Localization/result/%s/%s/%d_frame_abs_%s_%s_%s_%d_pose_std_with_lc_2nghbr_long_term.dat',data_name{data_index},dir_name{dynamic_data_index},nFrame,image_name{img_index},fe_name,filter_list{filter_index},cut_off);      
                                                min_match_points_file_name = sprintf('../Localization/result/%s/%s/min_match_points_%d_with_lc.mat',data_name{data_index},dir_name{dynamic_data_index}, min_matched_points);                                        
                                            else
                                                error_file_name = sprintf('../Localization/result/%s/%s/%d_frame_abs_%s_%s_%s_%d.dat',data_name{data_index},dir_name{dynamic_data_index},nFrame,image_name{img_index},fe_name,filter_list{filter_index},cut_off);
                                                feature_file_name = sprintf('../Localization/result/%s/%s/%d_frame_abs_%s_%s_%s_%d_feature_points.dat',data_name{data_index},dir_name{dynamic_data_index},nFrame,image_name{img_index},fe_name,filter_list{filter_index},cut_off);
                                                pose_std_file_name = sprintf('../Localization/result/%s/%s/%d_frame_abs_%s_%s_%s_%d_pose_std.dat',data_name{data_index},dir_name{dynamic_data_index},nFrame,image_name{img_index},fe_name,filter_list{filter_index},cut_off);
                                                
%                                                 error_file_name = sprintf('../Localization/result/%s/%s/%d_frame_abs_%s_%s_%s_%d_cull_2.dat',data_name{data_index},dir_name{dynamic_data_index},nFrame,image_name{img_index},fe_name,filter_list{filter_index},cut_off);
%                                                 feature_file_name = sprintf('../Localization/result/%s/%s/%d_frame_abs_%s_%s_%s_%d_cull_2_feature_points.dat',data_name{data_index},dir_name{dynamic_data_index},nFrame,image_name{img_index},fe_name,filter_list{filter_index},cut_off);
%                                                 pose_std_file_name = sprintf('../Localization/result/%s/%s/%d_frame_abs_%s_%s_%s_%d_cull_2_pose_std.dat',data_name{data_index},dir_name{dynamic_data_index},nFrame,image_name{img_index},fe_name,filter_list{filter_index},cut_off);
                                                min_match_points_file_name = sprintf('../Localization/result/%s/%s/min_match_points_%d.mat',data_name{data_index},dir_name{dynamic_data_index}, min_matched_points);
%                                                 error_file_name = sprintf('../Localization/result/%s/%s/%d_frame_abs_%s_%s_%s_%d_2nghbr.dat',data_name{data_index},dir_name{dynamic_data_index},nFrame,image_name{img_index},fe_name,filter_list{filter_index},cut_off);
%                                                 feature_file_name = sprintf('../Localization/result/%s/%s/%d_frame_abs_%s_%s_%s_%d_feature_points_2nghbr.dat',data_name{data_index},dir_name{dynamic_data_index},nFrame,image_name{img_index},fe_name,filter_list{filter_index},cut_off);
%                                                 pose_std_file_name = sprintf('../Localization/result/%s/%s/%d_frame_abs_%s_%s_%s_%d_pose_std_2nghbr.dat',data_name{data_index},dir_name{dynamic_data_index},nFrame,image_name{img_index},fe_name,filter_list{filter_index},cut_off);
% % %                                                 
%                                                 error_file_name = sprintf('../Localization/result/%s/%s/%d_frame_abs_%s_%s_%s_%d_3nghbr.dat',data_name{data_index},dir_name{dynamic_data_index},nFrame,image_name{img_index},fe_name,filter_list{filter_index},cut_off);
%                                                 feature_file_name = sprintf('../Localization/result/%s/%s/%d_frame_abs_%s_%s_%s_%d_feature_points_3nghbr.dat',data_name{data_index},dir_name{dynamic_data_index},nFrame,image_name{img_index},fe_name,filter_list{filter_index},cut_off);
%                                                 pose_std_file_name = sprintf('../Localization/result/%s/%s/%d_frame_abs_%s_%s_%s_%d_pose_std_3nghbr.dat',data_name{data_index},dir_name{dynamic_data_index},nFrame,image_name{img_index},fe_name,filter_list{filter_index},cut_off);
                                                
%                                                 min_match_points_file_name = sprintf('../Localization/result/%s/%s/min_match_points_%d.mat',data_name{data_index},dir_name{dynamic_data_index}, min_matched_points);
%                                                 
                                                if strcmp(data_name{data_index}, 'm') == 1 && gt_file == 1
                                                    time_stamp_name = sprintf('../data/dynamic/%s/d1_timestamp.dat',dir_name{dynamic_data_index});
                                                    gt_name = sprintf('../data/dynamic/%s/d1_gt.dat',dir_name{dynamic_data_index});
                                                end
                                            end
                                        otherwise
                                            if vro_cpp == 1
                                                error_file_name = sprintf('D:/soonhac/Project/PNBD/SW/ubuntu_backup/vro_result/%s/%d_%s/vro_cpp_%d_%s.dat',data_name{data_index},inc*interval,unit,nFrame,fe_name{fe_index});
                                            else
                                                error_file_name = sprintf('result/%s/%d_%s/%d_frame_abs_%s_%s_%s_%d.dat',data_name{data_index},inc*interval,unit,nFrame,image_name{img_index},fe_name{fe_index},filter_list{filter_index},cut_off);
                                                %error_std_file_name = sprintf('result/%s/%d_%s/%d_frame_abs_%s_%s_%s_%d_std.dat',data_name{data_index},inc*interval,unit,nFrame,image_name{img_index},fe_name{fe_index},filter_list{filter_index},cut_off);
                                            end
                                    end
                            end
                        case 'depth'
%                             switch error_std_index
%                                 case 1
                                    %error_file_name = sprintf('result/%s/%d_%s/%d_frame_abs_%s_%s_%s_%d.dat',data_name{data_index},inc*interval,unit,nFrame,image_name{img_index},fe_name{fe_index},filter_list{filter_index},cut_off);
%                                 case 2
                                    %error_std_file_name = sprintf('result/%s/%d_%s/%d_frame_abs_%s_%s_%s_%d_std.dat',data_name{data_index},inc*interval,unit,nFrame,image_name{img_index},fe_name{fe_index},filter_list{filter_index},cut_off);
%                             end
                             error_file_name = sprintf('../Localization/result/%s/%s/%d_frame_abs_%s_%s_%s_%d.dat',data_name{data_index},dir_name{dynamic_data_index},nFrame,image_name{img_index},fe_name,filter_list{filter_index},cut_off);
                             feature_file_name = sprintf('../Localization/result/%s/%s/%d_frame_abs_%s_%s_%s_%d_feature_points.dat',data_name{data_index},dir_name{dynamic_data_index},nFrame,image_name{img_index},fe_name,filter_list{filter_index},cut_off);
                             pose_std_file_name = sprintf('../Localization/result/%s/%s/%d_frame_abs_%s_%s_%s_%d_pose_std.dat',data_name{data_index},dir_name{dynamic_data_index},nFrame,image_name{img_index},fe_name,filter_list{filter_index},cut_off);
                             min_match_points_file_name = sprintf('../Localization/result/%s/%s/min_match_points_%d.mat',data_name{data_index},dir_name{dynamic_data_index}, min_matched_points);
                             if strcmp(data_name{data_index}, 'm') == 1 && gt_file == 1
                                 time_stamp_name = sprintf('../data/dynamic/%s/d1_timestamp.dat',dir_name{dynamic_data_index});
                                 gt_name = sprintf('../data/dynamic/%s/d1_gt.dat',dir_name{dynamic_data_index});
                             end

                        case {'fuse','fuse_std'}
                             switch data_name{data_index}
                                 case {'m'}
                                     error_file_name = sprintf('result/%s/%s/%d_frame_abs_%s_%s_%s_%d.dat',data_name{data_index},dir_name{dynamic_data_index},nFrame,image_name{img_index},fe_name{fe_index},filter_list{filter_index},cut_off);
                                     time_stamp_name = sprintf('../data/dynamic/%s/d1_timestamp.dat',dir_name{dynamic_data_index});
                                     gt_name = sprintf('../data/dynamic/%s/d1_gt.dat',dir_name{dynamic_data_index});
                                 otherwise
                                    error_file_name = sprintf('result/%s/%d_%s/%d_frame_abs_%s_%s_%s_%d.dat',data_name{data_index},inc*interval,unit,nFrame,image_name{img_index},fe_name{fe_index},filter_list{filter_index},cut_off);
%                                 case 2
                                    %error_std_file_name = sprintf('result/%s/%d_%s/%d_frame_abs_%s_%s_%s_%d_std.dat',data_name{data_index},inc*interval,unit,nFrame,image_name{img_index},fe_name{fe_index},filter_list{filter_index},cut_off);
                             end
                        otherwise
                            disp('Data name is unknown.');
                            return;
                    end
%                     abs_error((img_index-1)*inc_max*length(filter_list)*length(fe_index)+(filter_index-1)*inc_max*length(fe_name)+(fe_index-1)*inc_max+inc,1) = {load(error_file_name)};
                    abs_error(file_index,1) = {load(error_file_name)};
                    if feature_flag == 1 && fileExists(feature_file_name)
                        feature_points_cell(file_index,1) = {load(feature_file_name)};
                        %feature_flag = 1;
                    else
                        feature_points_cell(file_index,1) = {[]};
                        feature_flag = 0;
                    end
                    
                    if pose_std_flag == 1
                        pose_std_cell(file_index,1) = {load(pose_std_file_name)};
                    else
                        pose_std_cell(file_index,1) = {[]};
                    end
                    
                    if strcmp(data_name{data_index}, 'm') == 1 && gt_file == 1
                        %abs_error_std(file_index,1) = {load(error_std_file_name)};
                    %else
                        time_stamp(file_index,1) = {load(time_stamp_name)};
                        gt(file_index,1) = {load(gt_name)};
                    end
                    file_index = file_index + 1;
                end
            end
        end
    end
end

%plot orientation error
kinect_depth_file_num=[];
t_error=[];
o_error=[];
f_index=[];
icp_ct=[];
valid_count = 0;
index_max = inc_max * length(image_name) * length(filter_list) * length(consensus_name)
for inc = 1: index_max
    unit_abs_error = abs_error{inc,1};
    if pose_std_flag == 1
        unit_pose_std = pose_std_cell{inc,1};
    end
    
    % Filter by number of matched points
%     if is_frame_index == 0
%         if long_format == 0
%             match_index = 17;
%         else
%             match_index = 18;
%         end
%     else
%         if vro_cpp == 1
%             match_index = 19;
%         else
%             if long_format == 0
%                 match_index = 18;
%             else
%                 match_index = 20;
%             end
%         end
%     end
%     
%     e = unit_abs_error(:,match_index) < min_matched_points;
%     temp_size = size(unit_abs_error,1);
%     unit_abs_error(e,:)=[];
%     eliminated_size = temp_size - size(unit_abs_error,1)
%     if pose_std_flag == 1
%         unit_pose_std(e,:)=[];
%     end
    
    
    %size(unit_abs_error)
    if is_frame_index == 0
        if long_format == 0
            error_index = 17;
        else
            error_index = 19;
        end
    else
        if vro_cpp == 1
            error_index = 20;
        else
            if long_format == 0
                error_index = 19;
            else
                error_index = 21;
            end
        end
    end
    
% Apply only dataset 1 in etas    
%     if strcmp(data_name{data_index}, 'etas') == 1
%         unit_abs_error(:,1:2) = unit_abs_error(:,1:2) - 9; 
%     end
    
    % Analyze nMatch
    %analyze_nMatch(unit_abs_error, error_index);
    
    if strcmp(data_name{data_index}, 'amir_vro') == 0
        % Delete invalid data
        e = unit_abs_error(:,error_index) ~= 0;
        unit_abs_error(e,:)=[];
        if pose_std_flag == 1
            unit_pose_std(e,:)=[];
        end
        
        if strcmp(vro_name, 'vro') == 1
            e = unit_abs_error(:,error_index-1) < min_matched_points;
            %save index of matched points; number of which is less than min_matched_points
            temp_f_index = unit_abs_error(e,1:2);
            save(min_match_points_file_name, 'e','temp_f_index');
        
            unit_abs_error(e,:)=[];
            if pose_std_flag == 1
                unit_pose_std(e,:)=[];
            end
        else
%             load(min_match_points_file_name);  % apply index from VRO
%             vro_idx=[];
%             for k=1:size(temp_f_index,1)
%                 temp_vro_idx = find(unit_abs_error(:,1) == temp_f_index(k,1) & unit_abs_error(:,2) == temp_f_index(k,2));
%                 if ~isempty(temp_vro_idx)
%                     vro_idx = [vro_idx; temp_vro_idx];
%                 end
%             end
%             unit_abs_error(vro_idx,:)=[];

            e = unit_abs_error(:,error_index-1) < min_matched_points;
            unit_abs_error(e,:)=[];

            if pose_std_flag == 1
%                 unit_pose_std(vro_idx,:)=[];
                unit_pose_std(e,:)=[];
            end
        end
        
    end
    
    % eliminate specific data temporary
%     temp_idx = find(unit_abs_error(:,1) == 48 & unit_abs_error(:,2) == 59)
%     unit_abs_error(temp_idx,:) = [];
%     unit_pose_std(temp_idx,:) =[];
%     
%     temp_idx = find(unit_abs_error(:,1) == 80 & unit_abs_error(:,2) == 98)
%     unit_abs_error(temp_idx,:) = [];
%     unit_pose_std(temp_idx,:) =[];
%     
%     temp_idx = find(unit_abs_error(:,1) == 94 & unit_abs_error(:,2) == 125)
%     unit_abs_error(temp_idx,:) = [];
%     unit_pose_std(temp_idx,:) =[];
%     
%     temp_idx = find(unit_abs_error(:,1) == 132 & unit_abs_error(:,2) == 165)
%     unit_abs_error(temp_idx,:) = [];
%     unit_pose_std(temp_idx,:) =[];
%     
%     temp_idx = find(unit_abs_error(:,1) == 278 & unit_abs_error(:,2) == 286)
%     unit_abs_error(temp_idx,:) = [];
%     unit_pose_std(temp_idx,:) =[];
    
    
    if is_frame_index == 0
        o_error = [o_error; unit_abs_error(:,1:3)];
        t_error = [t_error; unit_abs_error(:,4:6)];
    else
        if vro_cpp == 1
            f_index = [f_index; unit_abs_error(:,1:2)];
            kinect_depth_file_num = [kinect_depth_file_num; unit_abs_error(:,3) ];
            o_error = [o_error; unit_abs_error(:,7:9)];  % [rx ry rz] [radian]
            t_error = [t_error; unit_abs_error(:,4:6)];  % [meter]
        else
            f_index = [f_index; unit_abs_error(:,1:2)];
            o_error = [o_error; unit_abs_error(:,3:5)];   % [ry rx rz]
            t_error = [t_error; unit_abs_error(:,6:8)];
            if strcmp(data_name{data_index}, 'amir_vro') == 0
                icp_ct = [icp_ct; unit_abs_error(:,1:2) unit_abs_error(:,9:16)];
            end
        end
    end
    
    if pose_std_flag == 1
        pose_std = unit_pose_std(:,3:8);  %[ry rx rz tx ty tz]
    else
        pose_std = [];
    end
    
    valid_count = valid_count + 1;
    %end
end

feature_points = feature_points_cell{1,1};

%Adjust the measurement unit in standard deviation 
% t_error_std = t_error_std * 1000; % meter -> milimeter
% o_error_std = o_error_std * 180 / pi;  % radian -> degree

% Adjust the measurement unit
t_error = t_error * 1000; % meter -> milimeter
o_error = o_error * 180 / pi;  % radian -> degree
t_pose = t_error;       % [mm]
o_pose = o_error;       % [degree]

%% Analysis motion estimation by step sizes
% for i=1:1 %7
%     
%     step_idx = (f_index(:,2) - f_index(:,1)) == i;
%     t_error_step = t_error(step_idx,:);
% %     o_error_step = t_error(step_idx,:);
% %     figure(1);plot(t_error_step(:,1),'*');title('X');
%     figure(2);plot(t_error_step(:,2),'*');title('Y');
% %     figure(3);plot(t_error_step(:,3),'*');title('Z');
% %     figure(4);plot(o_error_step(:,1),'*');title('Ry');
% %     figure(5);plot(o_error_step(:,2),'*');title('Rx');
% %     figure(6);plot(o_error_step(:,3),'*');title('Rz');
% 
%     %load time
%     f_index_tmp = f_index(step_idx,1);
%     for k=1:size(f_index_tmp,1)
%         [img, x, y, z, c, rtime, time_stamp(k)] = LoadSR_no_bpc_time(data_name{data_index}, 'gaussian', 0, dynamic_data_index, f_index_tmp(k,1), 1, 'int');
%     end
%     time_interval = diff(time_stamp);
%     speed = t_error_step(2:end,2)./time_interval';
%     
%     %figure(3);plot(time_stamp,'d');title('Time Stamp');
%      figure(3);plot(speed);title('Speed');
%      %mean_speed = mean(speed(100:end-100))  % for loops 2
%      %median_speed = median(speed(100:end-100))  % for loops 2
%      mean_speed = mean(speed(30:end-30))
%      median_speed = median(speed(30:end-30))
%     
%     % Save speed
%     [prefix, confidence_read] = get_sr4k_dataset_prefix(data_name{data_index}, dynamic_data_index);
%     save(sprintf('%s_speed.mat',prefix),'t_error_step','time_stamp','time_interval','speed');
% end

%% Delete data which has smaller amount than convariance
% t_thresh = 14;  % 14 mm
% o_thresh = 0.48; % 0.48 degree
% e = abs(t_error(:,1)) < t_thresh & abs(t_error(:,2)) < t_thresh & abs(t_error(:,3)) < t_thresh & abs(o_error(:,1)) < o_thresh & abs(o_error(:,2)) < o_thresh & abs(o_error(:,3)) < o_thresh;
% 
% f_index(e,:) = [];
% o_error(e,:) = [];
% t_error(e,:) = [];


% Replace the measurement which is less than noise threshold with zero
% t_thresh =7; %14; %14; %14;  % 14 mm
% o_thresh = 0.24; %0.12; %0.24; %0.24; % 0.48 degree
% for i=1:size(t_pose,1)
%     for j=1:size(t_pose,2)
%         if abs(t_pose(i,j)) < t_thresh
%             t_pose(i,j) = 0;
%         end
%         if abs(o_pose(i,j)) < o_thresh
%             o_pose(i,j) = 0;
%         end
%     end
% end
% 
% e = abs(t_error(:,1)) == 0 & abs(t_error(:,2)) == 0 & abs(t_error(:,3)) == 0;
%  
% f_index(e,:) = [];
% o_pose(e,:) = [];
% t_pose(e,:) = [];

% figure;
% plot(icp_ct,'.');
% ylabel('Computatoinal Time [sec]')
% set(gca,'FontSize',12,'FontWeight','bold');
% h_ylabel = get(gca,'YLabel');
% set(h_ylabel,'FontSize',12,'FontWeight','bold'); 


% icp_ct_mean = mean(icp_ct)
% icp_ct_median = median(icp_ct)
% icp_ct_max = max(icp_ct)
% icp_ct_min = min(icp_ct)


if feature_flag == 1
    feature_points(:,4:6) = feature_points(:,4:6) * 1000;   % [m] -> [mm]
end

end



function analyze_nMatch(unit_abs_error, error_index)

%nMatch = unit_abs_error(:,error_index-1);
hist_center = 10:20:200; % for visual features
%hist_center = 1:3:30;


% hist(nMatch,hist_center);
% 
% nMatch_hist = hist(nMatch,hist_center);

step_size = unit_abs_error(:,2) - unit_abs_error(:,1);
step_size_uniq = unique(step_size);
%mean_nMatch=[];
figure;
for s=1:6
    idx = find(step_size == s);
    nMatch = unit_abs_error(idx,error_index-1);
    subplot(3,2,s);hist(nMatch,hist_center);title(sprintf('Step Size %d',s));
    ylim([0 600]);
    %mean_nMatch = [mean_nMatch; mean(nMatch)];
end

% mean_nMatch'

end