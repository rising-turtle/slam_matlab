
% Author : David Zhang (hxzhang1@ualr.edu)
% Date : 11/13/15
% plot the accumulated RTE displacement error at each step, 

function plot_rte_translation_error()
    add_path_zh;
    
    %% dataset_1 
     gt_f = '.\motion_capture_data\test_10_16_2015\Take 2015-10-16 04.25.55 PM.dat_pose_wp';
     es_f = '.\motion_capture_data\test_10_16_2015\dataset_1\trajectory_vo_estimate.txt';
    % es_f2 = '.\motion_capture_data\test_10_16_2015\dataset_1\trajectory_vo_p_estimate.txt';
     es_f2 = '.\motion_capture_data\test_10_16_2015\dataset_1\trajectory_vo_pem_estimate.txt';
    
    %% dataset_2
    % gt_f = '.\motion_capture_data\test_10_16_2015\Take 2015-10-16 04.46.44 PM.dat_pose_wp';
    % es_f = '.\motion_capture_data\test_10_16_2015\dataset_2\trajectory_vo_estimate.txt';
    % es_f2 = '.\motion_capture_data\test_10_16_2015\dataset_2\trajectory_vo_p_estimate.txt';
    % es_f2 = '.\motion_capture_data\test_10_16_2015\dataset_2\trajectory_vo_pem_estimate.txt';
    
    %% dataset_3     
      gt_f = '.\motion_capture_data\test_10_16_2015\Take 2015-10-16 04.49.46 PM.dat_pose_wp';
      % es_f = '.\motion_capture_data\test_10_16_2015\dataset_3\trajectory_vo_estimate.txt';
      es_f = '.\motion_capture_data\test_10_16_2015\dataset_3\data3_vro_estimate.txt';
      % es_f2 = '.\motion_capture_data\test_10_16_2015\dataset_3\trajectory_vo_p_estimate.txt';
      % es_f2 = '.\motion_capture_data\test_10_16_2015\dataset_3\trajectory_vo_pem_estimate.txt';
      % es_f = '.\motion_capture_data\test_10_16_2015\dataset_3\data3_plane_em_vro_estimate.txt';
      es_f2 = '.\motion_capture_data\test_10_16_2015\dataset_3\data3_plane_em_vro_4_estimate.txt';
      % es_f2 = '.\motion_capture_data\test_10_16_2015\dataset_3\compare_lsd_vo\trajectory_estimate.txt';
    
      
    mode = 'RTE';
    [rmse, E_sq, E_ab] = compute_error(gt_f, es_f, mode);
    E1 = E_ab; 
    [rmse, E_sq, E_ab] = compute_error(gt_f, es_f2, mode);
    E2 = E_ab; 
    plot_error(E1, E2);
end

function E = accumulate(E)
    for i=2:size(E,1)
        E(i) = E(i-1) + E(i);
    end
end

function plot_error(E1, E2)
       et1 = sqrt(E1(:,1)); 
       et2 = sqrt(E2(:,1)); 
       et1 = accumulate(et1); 
       et2 = accumulate(et2);
       plot_error_impl(et1, et2, 'translational error [m]');
       figure;
       et1 = sqrt(E1(:,2)); 
       et2 = sqrt(E2(:,2)); 
       et1 = accumulate(et1); 
       et2 = accumulate(et2);
       plot_error_impl(et1, et2, 'rotational error [m]');
end

function plot_error_impl(et1, et2, y_label)
       plot(et1, 'r+');
       hold on; 
       plot(et2, 'b+');
       xlabel('nth camera frame #');
       ylabel(y_label); 
       legend('VO', 'VO_p');
end

