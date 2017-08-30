% Load matched points from a file
%
% Author : Soonhac Hong (sxhong1@ualr.edu)
% Date : 3/11/2013

function [pose_std] = load_pose_std(data_name, dm, first_cframe, second_cframe, isgframe, sequence_data)
[prefix, confidence_read] = get_sr4k_dataset_prefix(data_name, dm);
if sequence_data == true
    if strcmp(data_name, 'object_recognition')
        dataset_dir = strrep(prefix, '/f1','');
    else
        dataset_dir = strrep(prefix, '/d1','');
    end
    if strcmp(isgframe, 'gframe')
        file_name = sprintf('%s/pose_std_gframe/d1_%04d_%04d.mat',dataset_dir, first_cframe, second_cframe);
    else
        file_name = sprintf('%s/pose_std/d1_%04d_%04d.mat',dataset_dir, first_cframe, second_cframe);
    end
else
    dataset_dir = prefix(1:max(strfind(prefix,sprintf('/d%d',dm)))-1);
    if strcmp(isgframe, 'gframe')
        file_name = sprintf('%s/pose_std_gframe/d1_%04d_d%d_%04d.mat',dataset_dir, first_cframe, dm, second_cframe);
    else
        file_name = sprintf('%s/pose_std/d1_%04d_d%d_%04d.mat',dataset_dir, first_cframe, dm, second_cframe);
    end
end

% if strcmp(isgframe, 'gframe')
%     file_name = sprintf('%s/matched_points_gframe/d1_%04d_%04d.mat',dataset_dir, first_cframe, second_cframe);
% else
%     file_name = sprintf('%s/matched_points/d1_%04d_%04d.mat',dataset_dir, first_cframe, second_cframe);
% end

load(file_name);



end
