function [img, frm, des, p] = load_feature(id)
%
% David Z, 3/6/2015 
% load features of this index file, directory info is in the global_def 
%

if nargin == 0 % test
    global_def;
    index = 1; 
end

%% get file name  
global g_data_dir g_data_prefix g_feature_dir
file_name = sprintf('%s/%s/%s_%04d.mat', g_data_dir, g_feature_dir, g_data_prefix, id); 
load(file_name);

% %% compatable with soonhac' load and save visual feature 
% load(file_name);
% [m, n] = size(x);
% p = zeros(m,n,3);
% p(:,:,1) = x; 
% p(:,:,2) = y;
% p(:,:,3) = z;

end