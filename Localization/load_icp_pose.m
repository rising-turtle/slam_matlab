% Load matched points from a file
%
% Author : Soonhac Hong (sxhong1@ualr.edu)
% Date : 3/11/2013

%function [match_num, ransac_iteration, op_pset1_image_index, op_pset2_image_index, op_pset_cnt, elapsed_match, elapsed_ransac, op_pset1, op_pset2] = load_matched_points(data_name, dm, first_cframe, second_cframe, isgframe, sequence_data)
function [phi_icp, theta_icp, psi_icp, trans_icp, rmse_icp, match_num, elapsed_icp, sta_icp, error, pose_std] = load_icp_pose(data_name, dm, first_cframe, second_cframe, icp_mode, sequence_data)

[prefix, confidence_read] = get_sr4k_dataset_prefix(data_name, dm);
if sequence_data == true
    dataset_dir = strrep(prefix, '/d1','');
    if strcmp(icp_mode, 'icp_ch')
        file_name = sprintf('%s/icp_ch_pose/d1_%04d_%04d.mat',dataset_dir, first_cframe, second_cframe);
    else
        file_name = sprintf('%s/icp_pose/d1_%04d_%04d.mat',dataset_dir, first_cframe, second_cframe);
    end
else
    dataset_dir = prefix(1:max(strfind(prefix,sprintf('/d%d',dm)))-1);
    if strcmp(icp_mode, 'icp_ch')
        file_name = sprintf('%s/icp_ch_pose/d1_%04d_d%d_%04d.mat',dataset_dir, first_cframe, dm, second_cframe);
    else
        file_name = sprintf('%s/icp_pose/d1_%04d_d%d_%04d.mat',dataset_dir, first_cframe, dm, second_cframe);
    end
end

% if strcmp(isgframe, 'gframe')
%     file_name = sprintf('%s/matched_points_gframe/d1_%04d_%04d.mat',dataset_dir, first_cframe, second_cframe);
% else
%     file_name = sprintf('%s/matched_points/d1_%04d_%04d.mat',dataset_dir, first_cframe, second_cframe);
% end

load(file_name);



end
