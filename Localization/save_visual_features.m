% Save sift visual feature into a file
%
% Author : Soonhac Hong (sxhong1@ualr.edu)
% Date : 2/13/2013

function save_visual_features(data_name, dm, cframe, frm, des, elapsed_sift, img, x, y, z, c, elapsed_pre, sequence_data, image_name)
[prefix, confidence_read] = get_sr4k_dataset_prefix(data_name, dm);
if sequence_data == true
    if strcmp(data_name, 'object_recognition')
        dataset_dir = strrep(prefix, '/f1','');
    else
        dataset_dir = strrep(prefix, '/d1','');
    end
    if strcmp(image_name, 'depth')
        file_name = sprintf('%s/depth_feature/d1_%04d.mat',dataset_dir, cframe);
    else
        file_name = sprintf('%s/visual_feature/d1_%04d.mat',dataset_dir, cframe);
    end
else
    dataset_dir = prefix(1:max(strfind(prefix,sprintf('/d%d',dm)))-1);
    if strcmp(image_name, 'depth')
        file_name = sprintf('%s/depth_feature/d%d_%04d.mat',dataset_dir, dm, cframe);
    else
        file_name = sprintf('%s/visual_feature/d%d_%04d.mat',dataset_dir, dm, cframe);
    end
end

%file_name = sprintf('%s/visual_feature/d1_%04d.mat',dataset_dir, cframe);

save(file_name, 'frm', 'des', 'elapsed_sift', 'img', 'x', 'y', 'z', 'c', 'elapsed_pre');

end