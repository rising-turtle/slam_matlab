% launch isam and show the results
% Author : Soonhac Hong (sxhong1@ualr.edu)
% Date : 3/2/12

import gtsam.*

%% Run VRO
graphslam_addpath;

run_convert = 1;
run_graphSLAM = 1;   % It should be zero due to the run-time error by system()
run_plot = 1;


file_index = 15; %14; %12;     % 5 = whitecane 6 = etas 7 = loops 8 = kinect_tum 9 = loops2 10= amir_vro 11 = sparse_feature 12 = swing 13 = swing2 14 = motive 15 = object_recognition 16=map
dynamic_index = 20; %12; %11; %14; %24; %16; %15; %9;     % 15:square_500, 16:square_700, 17:square_swing
vro_name_list={'vro','vro_icp','vro_icp_ch','icp'};
vro_name_index = 1;
vro_name=vro_name_list{vro_name_index};
% etas_nFrame_list = [979 1479 621 1979 1889]; %979%[3rd_straight, 3rd_swing, 4th_straigth, 4th_swing, 5th_straight, 5th_swing]
% loops_nFrame_list = [0 1359 2498 0 0 0 0 0 0 0 0 0 515 0 0 0 0 2669]; %%224 %18
% kinect_tum_nFrame_list = [0 427 0 0]; %17  427 1243
% loops2_nFrame_list = [830 582 830 832 649 930 479 580 699 458 368 239]; %2498 578 [8]=18 [1]=830 48
% amir_vro_nFrame_list = [832 0 832 832 649 932 479 580 699 458 398]; 
% sparse_feature_nFrame_list = [232 198 432 365 275 413 164 206 235 353 708]; 
% swing_nFrame_list = [269 322 598 532 528 0 379 379 379 379 379]; 
% swing2_nFrame_list = [99 128 221 176 210 110];
% m_nFrame_list = [0 5414 0 729];
compensation_option ={'Replace','Linear'};
compensation_index = 1;
% etas_vro_size_list = [1260 0 1665 0 9490 0]; %1974 
% loops_vro_size_list = [0 12476 12492 0 0 0 0 0 0 0 0 0 0 0 0 0 0 26613]; %13098  12476  12552
% kinect_tum_vro_size_list = [0 98 0 0];
% loops2_vro_size_list = [10822 0 0 4065 0 0 0 0 0 0 0 0]; %[1]=426  10792
% amir_vro_size_list = [0 0 0 4065 0 0 0 0 0 0 0];
% sparse_feature_vro_size_list = [0 0 0 0 0 0 0 0 0 0 0];
% swing_vro_size_list = [0 0 0 0 0 0 0 0 0 0 0];
% swing2_vro_size_list = [0 0 0 0 0 0];

feature_flag =0;       % 0 = Exclude feature points into constraints, 1 = Include feature points constraints
dense_index  = 1;   %1 = dense constraints; 0 = sparse constraints
sparse_interval = 3;   % valid only if dense_index is zero
vro_dis = 0; % 1 = display vro, 0 = display no vro
vro_cpp = 0;  % 1 = data from vro cpp, 0 = data from matlab
constraint_max_interval = 1000; %1000; %1000; %1000; %200; %50; %50; %120; %50; %50; %50; % max interval for constraints
pose_std_flag = 1; % 0 = no pose standard deviation, 1 = load pose standard deviation from a file
isgframe='none'; %'gframe'; %'none'; %'gframe';   %general frame (aka. z-axis represent depth data)
rossba_plot =0;  % 1 = plot the result of ros_sba
pixel_culling_size = 30; % Sampling size of feature points in pixel space when feature_flag is set 1.
lba_file = 0; % 1 = read data from LBA results(aka. *lab.sam); 0=read data from VRO
% optimizer_iteration_max = 10;
%pose_step = 0; %0 = batch optimization; otherwise = incremental optimization.
min_matched_points = 13; %13; %6; %13; %11; %13;
with_lc_flag =0;  % 0 : without LC, 1 : with typical LC, 2 : with typical LC with 2 neighbors 3 : with fast LC 4: with long_term LC

% switch file_index
%     case 5       
%         nFrame = m_nFrame_list(dynamic_index - 14);
%         vro_size = 6992; %5382; %46; %5365; %5169;
%     case 6
%         nFrame = etas_nFrame_list(dynamic_index); %289; 5414; %46; %5468; %296; %46; %86; %580; %3920;
%         vro_size = etas_vro_size_list(dynamic_index); %1951; 1942; %5382; %46; %5365; %5169;
%     case 7
%         nFrame = loops_nFrame_list(dynamic_index);
%         vro_size = loops_vro_size_list(dynamic_index); 
%     case 8
%         nFrame = kinect_tum_nFrame_list(dynamic_index);
%         vro_size = kinect_tum_vro_size_list(dynamic_index); 
%     case 9
%         nFrame = loops2_nFrame_list(dynamic_index);
%         vro_size = loops2_vro_size_list(dynamic_index); 
%     case 10
%         nFrame = amir_vro_nFrame_list(dynamic_index);
%         vro_size = amir_vro_size_list(dynamic_index);  
%     case 11
%         nFrame = sparse_feature_nFrame_list(dynamic_index);
%         vro_size = sparse_feature_vro_size_list(dynamic_index);  
%     case 12
%         nFrame = swing_nFrame_list(dynamic_index);
%         vro_size = swing_vro_size_list(dynamic_index);  
%    case 13
%         nFrame = swing2_nFrame_list(dynamic_index);
%         vro_size = swing2_vro_size_list(dynamic_index);  
%         
% end

[nFrame, vro_size, pose_size, vro_icp_size, pose_vro_icp_size, vro_icp_ch_size, pose_vro_icp_ch_size] = get_nframe_nvro_npose(file_index, dynamic_index);


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
        [vro_size, pose_size, feature_points_visual] = convert_vro_isam(file_index + 5, dynamic_index,nFrame,vro_dir_name, dynamic_dir_name, feature_pose_name, feature_flag, index_interval,compensation_option{compensation_index}, dense_index, sparse_interval, vro_cpp, constraint_max_interval, vro_name, pose_std_flag, isgframe, pixel_culling_size, min_matched_points, with_lc_flag, vro_dis);
    else
        pose_size = nFrame;
    end
    opt_file_name = sprintf('%s%s_%s_%s_%d_isam.opt', isam_result_dir_name, dynamic_dir_name, compensation_option{compensation_index}, feature_pose_name, vro_size);
    if pose_std_flag == 1
        if lba_file == 1
            isam_file_name = sprintf('%s%s_%s_%s_%d_%d_%s_cov_lba_fpt_2_inlier.sam', vro_dir_name, dynamic_dir_name, compensation_option{compensation_index}, feature_pose_name, vro_size, pose_size, vro_name);
        else
            isam_file_name = sprintf('%s%s_%s_%s_%d_%d_%s_cov.sam', vro_dir_name, dynamic_dir_name, compensation_option{compensation_index}, feature_pose_name, vro_size, pose_size, vro_name);
        end
    else
        isam_file_name = sprintf('%s%s_%s_%s_%d_%d_%s.sam', vro_dir_name, dynamic_dir_name, compensation_option{compensation_index}, feature_pose_name, vro_size, pose_size, vro_name);
    end
    %loop closure --> isam_file_name = sprintf('%s%s_%s_%s_%d.sam', vro_dir_name, dynamic_dir_name, compensation_option{compensation_index}, feature_pose_name, vro_size);
    isp_file_name = sprintf('%s%s_%s_%s_%d_%d_%s.isp', vro_dir_name, dynamic_dir_name, compensation_option{compensation_index}, feature_pose_name, vro_size, pose_size, vro_name);
    if lba_file == 1
        gtsam_isp_file_name = sprintf('%s%s_%s_%s_%d_%s_lba_fpt_2_gtsam.isp', vro_dir_name, dynamic_dir_name, compensation_option{compensation_index}, feature_pose_name, vro_size, vro_name);
        gtsam_opt_file_name = sprintf('%s%s_%s_%s_%d_%s_lba_fpt_2_gtsam.opt', isam_result_dir_name, dynamic_dir_name, compensation_option{compensation_index}, feature_pose_name, vro_size, vro_name);
    else
        gtsam_isp_file_name = sprintf('%s%s_%s_%s_%d_%s_gtsam.isp', vro_dir_name, dynamic_dir_name, compensation_option{compensation_index}, feature_pose_name, vro_size, vro_name);
        if file_index == 12 && dynamic_index == 25 && constraint_max_interval == 1000
            gtsam_opt_file_name = sprintf('%s%s_%s_%s_%d_%s_gtsam.opt', isam_result_dir_name, dynamic_dir_name, compensation_option{compensation_index}, feature_pose_name, vro_size+2, vro_name);
        else
            gtsam_opt_file_name = sprintf('%s%s_%s_%s_%d_%s_gtsam.opt', isam_result_dir_name, dynamic_dir_name, compensation_option{compensation_index}, feature_pose_name, vro_size, vro_name);
        end
    end
    
    icp_ct_file_name = sprintf('%s%s_%s_%s_%d_%d_%s_icp.ct', vro_dir_name, dynamic_dir_name, compensation_option{compensation_index}, feature_pose_name, vro_size, pose_size, vro_name);
    rossba_file_name = sprintf('results/ros_sba/%s_%s_pose_feature_%d_%d_fpt_2_ros_sba_result_inlier_result_inlier_result.out', dynamic_dir_name, compensation_option{compensation_index}, vro_size, pose_size);
else
    opt_file_name = isam_result_dir_name;
    isam_file_name = vro_dir_name;
end


%% Run gtsam
% SR4000's repeatibility (sigma) = 7 mm (maximum)
translation_covariance = 0.007; %0.014; %0.014; %[m]
orientation_covariance = 0.12*pi/180; %0.6*pi/180; %[degree] -> [radian]

if run_graphSLAM == 1
    
%pose_noise_model = noiseModel.Diagonal.Sigmas([0.034; 0.034; 0.034; 0.5*pi/180; 0.5*pi/180; 0.5*pi/180]);  % [m][radian]
pose_noise_model = noiseModel.Diagonal.Sigmas([translation_covariance; translation_covariance; translation_covariance; orientation_covariance; orientation_covariance; orientation_covariance]);  % [m][radian]
%model = noiseModel.Diagonal.Sigmas([0.5; 0.5; 0.5; 3*pi/180; 3*pi/180; 3*pi/180]);  % [m][radian]
%landmark_noise_model = noiseModel.Diagonal.Sigmas([0.034; 0.034; 0.034]);  % [m][radian]
landmark_noise_model = noiseModel.Diagonal.Sigmas([translation_covariance; translation_covariance; translation_covariance]);  % [m][radian]

    t_isam = tic;
    
    t = gtsam.Point3(0, 0, 0);
    %rx = -24.3316;
    %ry = 1.2670;
    %rz = 4.6656;
    %R = gtsam.Rot3.Ypr(rz, rx, ry);  % rz, ry, rx; Yaw = rz, pitch=ry, roll=rx
    %rot = euler_to_rot(ry, rx, rz);  % ry, rx, rz [degree]
    h_global = get_global_transformation(file_index+5, dynamic_index, isgframe);
    rot = h_global(1:3,1:3);
    R = gtsam.Rot3(rot);
    origin= gtsam.Pose3(R,t);
    initial_max_index = 0;  % dummy
    
    [graph,initial]=load3D_SR4000(pose_std_flag, isam_file_name, pose_noise_model, true, vro_size, landmark_noise_model, pose_size, origin);
    
    %% Plot Initial Estimate
    %cla
    first = initial.at(0);
    
    figure;plot3(first.x(),first.y(),first.z(),'r*'); hold on
    %plot3DTrajectory(initial,'g-',false);
    plot3_gtsam(initial,'g-',false);
    drawnow;
    
    %save initial pose
    save_graph_isp(initial, gtsam_isp_file_name, isgframe);
    
    %% Read again, now with all constraints, and optimize
    %graph = load3D(isam_file_name, pose_noise_model, false, vro_size);
    graph = load3D_SR4000(pose_std_flag, isam_file_name, pose_noise_model, false, vro_size, landmark_noise_model, pose_size, origin); 
    graph.add(NonlinearEqualityPose3(0, first));
    
    gtsam_t=tic;
    optimizer = LevenbergMarquardtOptimizer(graph, initial);
    %optimizer = DoglegOptimizer(graph, initial);
    result = optimizer.optimizeSafely();
    gtsam_t =toc(gtsam_t)
    
    %optimizer.iterations()
    
%     for i=1:optimizer_iteration_max
%           optimizer.iterate();
%           %optimizer.check_convergence()  % how to check it out?
%     end
%     result = optimizer.values();
    
    
    
    %plot3DTrajectory(result, 'r-', false); axis equal;
    figure;plot3_gtsam(result,'r-',false); axis equal;
    
    view(3); axis equal;
    
    % Save optimized pose
    %save initial pose
    save_graph_isp(result, gtsam_opt_file_name, isgframe);
    
    
    t_isam = toc(t_isam)
end


%% plot g2o
if run_plot == 1
    if file_index == 8
        opt_file_name = 'none';
        plot_kinect_tum(isp_file_name, opt_file_name, 'isam', dynamic_index, nFrame);
    elseif rossba_plot == 1
        plot_gtsam_rossba(gtsam_isp_file_name, gtsam_opt_file_name, rossba_file_name);
    else
        plot_gtsam(gtsam_isp_file_name, gtsam_opt_file_name);
        %plot_icp_ct(icp_ct_file_name);
    end
end

% Write ply files
convert_isp2ply(gtsam_isp_file_name, file_index, dynamic_index, isgframe, vro_name);
convert_isp2ply(gtsam_opt_file_name, file_index, dynamic_index, isgframe, vro_name);

% Dense map
%convert_isp2ply(gtsam_opt_file_name, file_index, dynamic_index, isgframe, vro_name);

% Sparse map (feature map)
% convert_isp2ply_featuremap(gtsam_opt_file_name, file_index, dynamic_index, isgframe, vro_name, feature_points_visual);

% Generate video
% generate_video(gtsam_isp_file_name, gtsam_opt_file_name, file_index, dynamic_index, isgframe, vro_name)
