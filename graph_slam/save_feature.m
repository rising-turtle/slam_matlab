function save_feature(id, img, frm, des, p)
%
% David Z, 3/6/2015 
% save features to the index file, directory info is in the global_def 
%

if nargin == 0 % test
    global_def;
    index = 1; 
end

%% get file name  
global g_data_dir g_data_prefix g_feature_dir
file_name = sprintf('%s/%s/%s_%04d.mat', g_data_dir, g_feature_dir, g_data_prefix, id); 
save(file_name, 'img','frm', 'des', 'p');

% %% to be compatable with soonhac' load and save visual feature function 
% elapsed_sift = 0;
% elapsed_pre = 0;
% x = p(:,:,1);
% y = p(:,:,2);
% z = p(:,:,3);
% 
% %% save this file
% save(file_name,'frm', 'des', 'elapsed_sift', 'img', 'x', 'y', 'z', 'c', 'elapsed_pre');

end