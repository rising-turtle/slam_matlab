% Plot the result of graph SLAM for kinect_tum data
%
% Author : Soonhac Hong (sxhong1@uarl.edu)
% Date : 2/22/12

function plot_kinect_tum(org_file_name, opt_file_name, optimizer_name, dir_index, nFrame)

switch optimizer_name
    case 'isam'
        [org_poses] = load_graph_isp(org_file_name);
        if ~strcmp(opt_file_name, 'none')
            [opt_poses] = load_graph_isam(opt_file_name);
        end
    case 'toro'
        [org_poses org_edges org_fpts_poses org_fpts_edges] = load_graph_toro(org_file_name);
        [opt_poses opt_edges opt_fpts_poses opt_fpts_edges] = load_graph_toro(opt_file_name);
    case 'g2o'
        [org_poses org_edges org_fpts_poses org_fpts_edges] = load_graph_g2o(org_file_name);
        [opt_poses opt_edges opt_fpts_poses opt_fpts_edges] = load_graph_g2o(opt_file_name);
end

%load ground truth
[gt rgbdslam rtime] = Load_kinect_gt(dir_index);
first_timestamp = get_timestamp_kinect_tum(dir_index,1);
gt_start_index = find(gt(:,1) > first_timestamp, 1);
if gt(gt_start_index,1) - first_timestamp > first_timestamp - gt(gt_start_index-1,1)
    gt_start_index = gt_start_index - 1;
end
%gt(gt_start_index,:)
last_timestamp = get_timestamp_kinect_tum(dir_index,nFrame);
gt_last_index = find(gt(:,1) > last_timestamp, 1);
if gt(gt_last_index,1) - last_timestamp > last_timestamp - gt(gt_last_index-1,1)
    gt_last_index = gt_last_index - 1;
end

% Show the pose
start_index = 1;
if ~strcmp(opt_file_name, 'none')
    end_index = min(size(org_poses,1), size(opt_poses)); %80;
else
    end_index = size(org_poses,1);
end
if size(org_poses,2) == 2     % SE2
    figure; 
    plot(org_poses(start_index:end_index,1), org_poses(start_index:end_index,2),'g:-');
    hold on;
    if ~strcmp(opt_file_name, 'none')
        plot(opt_poses(start_index:end_index,1), opt_poses(start_index:end_index,2),'b.-','LineWidth',2);
    end
    plot(gt(:,2), gt(:,3),'r.-','LineWidth',2);
    xlabel('X [m]');
    ylabel('Y [m]');
    grid;
    if ~strcmp(opt_file_name, 'none')
        legend('vro',optimizer_name,'GT');
    else
        legend('vro','GT');
    end
    hold off;
elseif size(org_poses,2) == 3     % SE3:QUAT
    figure; 
    plot3(org_poses(start_index:end_index,1), org_poses(start_index:end_index,2), org_poses(start_index:end_index,3), 'g-', 'LineWidth',1);
    hold on;
    if ~strcmp(opt_file_name, 'none')
        plot3(opt_poses(start_index:end_index,1), opt_poses(start_index:end_index,2), opt_poses(start_index:end_index,3), 'b.-', 'LineWidth',2);
    end
    plot3(gt(gt_start_index:gt_last_index,2), gt(gt_start_index:gt_last_index,3), gt(gt_start_index:gt_last_index,4), 'r-','LineWidth',1);
    %plot3(rgbdslam(start_index:end_index,2), rgbdslam(start_index:end_index,3), rgbdslam(start_index:end_index,4), 'b:', 'LineWidth',1);
    xlabel('X [m]');
    ylabel('Y [m]');
    zlabel('Z [m]');
    if ~strcmp(opt_file_name, 'none')
        legend('vro',optimizer_name,'GT_e');
    else
        legend('vro','GT');
    end
    grid;
    axis equal;
    hold off;
end

end


