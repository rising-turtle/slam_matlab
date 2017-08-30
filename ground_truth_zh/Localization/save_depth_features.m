% Save sift visual feature into a file
%
% Author : Soonhac Hong (sxhong1@ualr.edu)
% Date : 2/13/2013

function save_depth_features(data_name, dm, cframe, depth_frm, depth_des, depth_ct)
[prefix, confidence_read] = get_sr4k_dataset_prefix(data_name, dm);
dataset_dir = strrep(prefix, '/d1','');
file_name = sprintf('%s/depth_feature/d1_%04d.mat',dataset_dir, cframe);

save(file_name, 'depth_frm', 'depth_des', 'depth_ct');

end