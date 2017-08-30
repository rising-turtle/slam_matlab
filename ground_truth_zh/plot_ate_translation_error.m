
% Author : David Zhang (hxzhang1@ualr.edu)
% Date : 11/09/15
% plot the the ATE displacement error at each step, 

function plot_ate_translation_error()
    add_path_zh;
    
    %% dataset_1 
    % gt_f = '.\motion_capture_data\test_10_16_2015\Take 2015-10-16 04.25.55 PM.dat_pose_wp';
    % es_f = '.\motion_capture_data\test_10_16_2015\dataset_1\trajectory_vo_estimate.txt';
    % es_f2 = '.\motion_capture_data\test_10_16_2015\dataset_1\trajectory_vo_p_estimate.txt';
    % es_f2 = '.\motion_capture_data\test_10_16_2015\dataset_1\trajectory_vo_pem_estimate.txt';
    
    %% dataset_2
     gt_f = '.\motion_capture_data\test_10_16_2015\Take 2015-10-16 04.46.44 PM.dat_pose_wp';
     es_f = '.\motion_capture_data\test_10_16_2015\dataset_2\trajectory_vo_estimate.txt';
    % es_f2 = '.\motion_capture_data\test_10_16_2015\dataset_2\trajectory_vo_p_estimate.txt';
     es_f2 = '.\motion_capture_data\test_10_16_2015\dataset_2\trajectory_vo_pem_estimate.txt';
    
    %% dataset_3     
    % es_f = '.\motion_capture_data\test_10_16_2015\trajectory_estimate_04.49.46.txt';
     % gt_f = '.\motion_capture_data\test_10_16_2015\Take 2015-10-16 04.49.46 PM.dat_pose_wp';
     % es_f = '.\motion_capture_data\test_10_16_2015\dataset_3\trajectory_vo_estimate.txt';
     % es_f2 = '.\motion_capture_data\test_10_16_2015\dataset_3\trajectory_vo_p_estimate.txt';
     % es_f2 = '.\motion_capture_data\test_10_16_2015\dataset_3\trajectory_vo_pem_estimate.txt';
    
    mode = 'ATE';
    [rmse, E_sq, E_ab] = compute_error(gt_f, es_f, mode);
    E1 = E_ab; 
    [rmse, E_sq, E_ab] = compute_error(gt_f, es_f2, mode);
    E2 = E_ab; 
    plot_error(E1, E2);
end

function plot_error(E1, E2)
       et1 = sqrt(E1(:,1)); 
       et2 = sqrt(E2(:,1)); 
       plot(et1, 'r+');
       hold on; 
       plot(et2, 'b+');
       xlabel('nth camera frame #');
       ylabel('translational error [m]'); 
       legend('VO', 'VO_p');
end