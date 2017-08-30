% Find pairs between two 3D point sets by Nearest Neighbors
%
% Author : Soonhac Hong (sxhong1@ualr.edu)
% Date : 2/21/14
% 
% Input : gt_total : [[x y z]*n]

function [ gt_total_pair] = find_pair_nn( gt_total)
    % Find pairs by nearest neighbor
    gt_total_pair=gt_total(1,:);
    for i=2:size(gt_total,1)
        min_idx_prev=[];
        for j=1:2
            cur = gt_total(i,1+(j-1)*3:3+(j-1)*3);
            diff_dist=[];
            for k=1:2
                pre = gt_total_pair(i-1,1+(k-1)*3:3+(k-1)*3);
                diff_dist = [diff_dist; norm(pre - cur)];
            end
            diff_dist(min_idx_prev)=intmax;
            [~, min_idx] = min(diff_dist);
            min_idx_prev = [min_idx_prev; min_idx];
            gt_total_pair(i,1+(min_idx-1)*3:3+(min_idx-1)*3)=cur;
        end
    end
end