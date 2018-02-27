%% find transformation between two point sets
function [pose, pose_err] = compute_transform(pose, pF, pT)
     
%     plot_xyz(pts_f(:,1), pts_f(:,2), pts_f(:,3), 'r*');
%     hold on;
%     plot_xyz(pts_t(:,1), pts_t(:,2), pts_t(:,3), 'bs');
    
    pts_f = pF(:,2:4);
    pts_t = pT(:,2:4);
    [rot, trans] = eq_point(pts_t', pts_f');
    
     pts_tt = rot * pts_f' + repmat(trans,1, size(pts_f,1));
     pts_tt = pts_tt';
     dt = pts_t(1,:) - pts_tt(1,:);
        
    if nargout == 2  
        pts_tt = pts_tt' + repmat(dt', 1, size(pts_f,1));
        pose_err = zeros(size(pT,1),2);
        pose_err(:,1) = pT(:,1);
        d_pos = pts_tt - pts_t';
        pose_err(:,2) = sqrt(sum(d_pos.*d_pos));
    end
%     hold on; 
%     plot_xyz(pts_tt(:,1), pts_tt(:,2), pts_tt(:,3), 'g+');
    
    for i=1:size(pose)
        t = pose(i, 2:4);
        t = rot * t' + trans + dt';
        pose(i,2:4) = t';
    end
end
