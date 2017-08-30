function [op_match, e] = load_matched_points_zh(id1, id2)

%% file name
global g_data_dir g_data_prefix g_matched_dir
file_name = sprintf('%s/%s/%s_%04d_%04d.mat', g_data_dir, g_matched_dir ...
    ,g_data_prefix, id1, id2); 

%% optimal match set 
load(file_name, 'op_match', 'e');

end