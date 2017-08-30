% Copy files to a designated directory
%
% Author : Soonhac Hong (sxhong1@ualr.edu)
% Date : 2/15/13

function copy_sr4k_files()

source_dir = 'F:\home_sc_data\l2o'; %'E:\data\swing\revisiting10_10m' %; % %''E:/data/sparse_feature/exp4_etas_2nd'
%destination_dir = 'C:\SC-DATA-TRANSFER';
destination_dir = sprintf('%s/processed_data',source_dir);
mkdir(source_dir,'processed_data');
% destination_dir = sprintf('%s/processed_data_c6',source_dir);
% mkdir(source_dir,'processed_data_c6');
%destination_dir = 'E:\data\sparse_feature\exp15_etas_4th_swing_2culling\processed_data';

% Get file names from source directory
dirData = dir(source_dir);     %# Get the data for the current directory
dirIndex = [dirData.isdir];  %# Find the index for directories
file_list = {dirData(~dirIndex).name}';

interval = 1;
destination_file_idx=748; %1;
first_file_number = 757; %1;
last_file_number =1400; %size(file_list,1)
for i=first_file_number:interval:last_file_number
    source_file_name = sprintf('%s/%s',source_dir, file_list{i});
    %unit_destination_file_name = sprintf('d1_%04d.bdat',destination_file_idx);
    unit_destination_file_name = sprintf('d1_%04d.dat',destination_file_idx);
    destination_file_name = sprintf('%s/%s',destination_dir,unit_destination_file_name);
    copyfile(source_file_name, destination_file_name);
    destination_file_idx = destination_file_idx + 1;
end

end