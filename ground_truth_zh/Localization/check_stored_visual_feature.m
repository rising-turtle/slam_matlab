% Check if there is the stored visual feature
%
% Author : Soonhac Hong (sxhong1@ualr.edu)
% Date : 2/13/2013

function [exist_flag] = check_stored_visual_feature(data_name, dm, cframe, sequence_data, image_name)
exist_flag = 0;

[prefix, confidence_read] = get_sr4k_dataset_prefix(data_name, dm);
if sequence_data == true
    if strcmp(data_name, 'object_recognition')
        dataset_dir = strrep(prefix, '/f1','');
    else
        dataset_dir = strrep(prefix, '/d1','');
    end
    file_name = sprintf('d1_%04d.mat',cframe);
else
    dataset_dir = prefix(1:max(strfind(prefix,sprintf('/d%d',dm)))-1);
    file_name = sprintf('d%d_%04d.mat',dm,cframe);
end

if strcmp(image_name, 'depth')
    dataset_dir = sprintf('%s/depth_feature',dataset_dir);
else
    dataset_dir = sprintf('%s/visual_feature',dataset_dir);
end
%file_name = sprintf('d1_%04d.mat',cframe);

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