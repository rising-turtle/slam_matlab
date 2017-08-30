function save_matched_points_zh(id1, id2, op_match, e)
%
% David Z, 3/6/2015
% save matched feature points 
% match id1 -> id2

%% get file name 
global g_data_dir g_data_prefix g_matched_dir
file_name = sprintf('%s/%s/%s_%04d_%04d.mat', g_data_dir, g_matched_dir, ...
    g_data_prefix,id1, id2); 

%% weather this match is error
if ~exist('e', 'var')
    e = 1;
end

%% save the optimal matched point set
save(file_name, 'op_match', 'e');
    
%% save the matched points, and compatable with soonhac' scheme 
% ransac_iteration = 0; 
% match_num = [0; 0];
% elapsed_match = 0; 
% elapsed_ransac = 0;
% save(file_name, 'match_num', 'ransac_iteration', 'op_pset1_image_index', 'op_pset2_image_index', 'op_pset_cnt', 'elapsed_match', 'elapsed_ransac', 'op_pset1', 'op_pset2');

end