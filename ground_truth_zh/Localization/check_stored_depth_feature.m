% Check if there is the stored visual feature
%
% Author : Soonhac Hong (sxhong1@ualr.edu)
% Date : 2/13/2013

function [exist_flag] = check_stored_depth_feature(data_name, dm, cframe)
exist_flag = 0;

[prefix, confidence_read] = get_sr4k_dataset_prefix(data_name, dm);
dataset_dir = strrep(prefix, '/d1','');
dataset_dir = sprintf('%s/depth_feature',dataset_dir);
file_name = sprintf('d1_%04d.mat',cframe);

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

dirData=[];
dirIndex=[];
file_list=[];
end