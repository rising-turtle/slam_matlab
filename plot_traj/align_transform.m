%% 
function [pose, pose_err] = align_transform(pose, gt)
    index = find_index(gt(:,1), pose(1,1));
    [pose, pts_f, pts_t] = transform_to_synchronized(pose, gt, index);
    [pose, pose_err] = compute_transform(pose, pts_f(:,:), pts_t(:,:));
end

