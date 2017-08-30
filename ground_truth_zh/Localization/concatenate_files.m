% Concatenate result files
%
% Author : Soonhac Hong (sxhong1@ualr.edu)
% Date : 3/4/13

function concatenate_files()
%data_name = 'sparse_feature';
data_name = 'object_recognition'; %'sparse_feature'; %'etas'; %'loops2';
dynamic_index = 16;
data_type_index = 3;  % select data type; See data_type
data_type={'','_pose_std','_feature_points'};

base_file_name = textscan('198_frame_abs_intensity_sift_i_r_s_i_t_t_c_i_a_c_c_featureidxfix_fast_fast_dist2_nobpc_gaussian_0','%d%s');

nframe=base_file_name{1,1};
data_type={'','_pose_std','_feature_points'};
%data_dir_list=get_loops2_filename();
data_dir_list = get_dir_name(data_name);
%data_dir = sprintf('D:\\soonhac\\Project\\PNBD\\SW\\ASEE\\Localization\\result\\loops2\\%s',data_dir_list{dynamic_index});
data_dir = sprintf('D:\\soonhac\\SW\\Localization\\result\\%s\\%s',data_name,data_dir_list{dynamic_index});

file_name_core = sprintf('%s%s.dat', base_file_name{1,2}{1,1}, data_type{data_type_index});
output_file_name = sprintf('%s\\%d%s_total',data_dir,nframe, file_name_core);

dirData = dir(data_dir);     %# Get the data for the current directory
dirIndex = [dirData.isdir];  %# Find the index for directories
file_list = {dirData(~dirIndex).name}';

% Load data according to the file_name_core
data={};
data_index = 1;
for i=1:size(file_list,1)
    unit_file_name = textscan(file_list{i,1}, '%d%s');
    if strcmp(unit_file_name{1,2}, file_name_core)
        input_file_name_full = sprintf('%s\\%s',data_dir, file_list{i,1});
        data{data_index,1} = load(input_file_name_full);
        data_first_index(data_index,1) = data{data_index,1}(1,1);
        data_index = data_index + 1;
    end
end

%Write data into a unfied file.
[~, data_first_index_sorted_index] = sort(data_first_index);

output_fd = fopen(output_file_name,'a');
for i=1:size(data_first_index,1)
    unit_data = data{data_first_index_sorted_index(i)};
    %save(output_file_name,'unit_data', '-ascii', '-append');
    switch data_type_index
        case 1
            fprintf(output_fd,'%d %d %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f\n', unit_data');
        case 2  % pose_std
            fprintf(output_fd,'%d %d %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f\n', unit_data');
        case 3  % feature_points
        fprintf(output_fd,'%d %d %d %f %f %f %f %f\n',unit_data');
    end
end
fclose(output_fd);

end