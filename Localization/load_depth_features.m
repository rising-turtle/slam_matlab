% Load sift visual feature from a file
%
% Author : Soonhac Hong (sxhong1@ualr.edu)
% Date : 2/13/2013

function [depth_frm, depth_des, depth_ct] = load_depth_features(data_name, dm, cframe)
[prefix, confidence_read] = get_sr4k_dataset_prefix(data_name, dm);
dataset_dir = strrep(prefix, '/d1','');
file_name = sprintf('%s/depth_feature/d1_%04d.mat',dataset_dir, cframe);

load(file_name);



end
