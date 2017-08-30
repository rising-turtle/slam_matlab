% Check if there is the stored matched points
%
% Author : Soonhac Hong (sxhong1@ualr.edu)
% Date : 3/11/2013

function [exist_flag] = check_stored_matched_points(data_name, dm, first_cframe, second_cframe, isgframe, sequence_data)
exist_flag = 0;

[prefix, confidence_read] = get_sr4k_dataset_prefix(data_name, dm);
if sequence_data == true
    if strcmp(data_name, 'object_recognition')
        dataset_dir = strrep(prefix, '/f1','');
    else
        dataset_dir = strrep(prefix, '/d1','');
    end
else
    dataset_dir = prefix(1:max(strfind(prefix,sprintf('/d%d',dm)))-1);
end

if strcmp(isgframe, 'gframe')
    dataset_dir = sprintf('%s/matched_points_gframe',dataset_dir);
else
    dataset_dir = sprintf('%s/matched_points',dataset_dir);
end

file_name = sprintf('d1_%04d_%04d.mat',first_cframe, second_cframe);

dirData = dir(dataset_dir);     %# Get the data for the current directory
dirIndex = [dirData.isdir];  %# Find the index for directories
file_list = {dirData(~dirIndex).name}';
if isempty(file_list)
    return;
else
    for i=1:size(file_list,1)
        if strcmp(file_list{i}, file_name)
            exist_flag = 1;
            break;
        end
    end
end

end