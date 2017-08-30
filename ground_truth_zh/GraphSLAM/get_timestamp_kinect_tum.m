% Get time stamp of depth image in kinect_tum dataset
%
% Author : Soonhac Hong (sxhong1@ualr.edu)
% Date : 12/20/12
function [time_stamp] = get_timestamp_kinect_tum(dm,j)
dir_name = get_kinect_tum_dir_name();

[depth_data_dir, err] = sprintf('E:/data/kinect_tum/%s/depth',dir_name{dm});
dirData = dir(depth_data_dir);     %# Get the data for the current directory
dirIndex = [dirData.isdir];  %# Find the index for directories
file_list = {dirData(~dirIndex).name}';
[file_name, err]=sprintf('%s',file_list{j});
time_stamp = str2num(strrep(file_name, '.png',''));
end