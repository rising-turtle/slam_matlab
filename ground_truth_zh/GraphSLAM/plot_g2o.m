% Plot the result of graph SLAM, g2o
%
% Author : Soonhac Hong (sxhong1@uarl.edu)
% Date : 2/22/12

function plot_g2o(org_file_name, opt_file_name, feature_flag)

[ org_poses org_edges org_fpts_poses org_fpts_edges] = load_graph_g2o(org_file_name);
[ opt_poses opt_edges opt_fpts_poses opt_fpts_edges] = load_graph_g2o(opt_file_name);

% Show the pose
start_index = 1;
end_index = min(size(org_poses,1), size(opt_poses)); %80;
if size(org_poses,2) == 3     % SE2
    figure; 
    %plot(org_poses(start_index:end_index,1), org_poses(start_index:end_index,2),'b.-','LineWidth',2);
    plot(org_poses(:,1), org_poses(:,2),'b.-','LineWidth',2);
    if ~isempty(org_fpts_poses) && feature_flag == 1
        hold on;
        plot(org_fpts_poses(:,1), org_fpts_poses(:,2), 'bd');
    end
    %xlabel('X [m]');
    %ylabel('Y [m]');
    %grid;
    %figure; 
    hold on;
    %plot(opt_poses(start_index:end_index,1), opt_poses(start_index:end_index,2),'r.-','LineWidth',2);
    plot(opt_poses(:,1), opt_poses(:,2),'r.-','LineWidth',2);
    if ~isempty(opt_fpts_poses) && feature_flag == 1
        plot(opt_fpts_poses(:,1), opt_fpts_poses(:,2), 'rd');
    end
    %plot_groundtruth();
    xlabel('X [m]');
    ylabel('Y [m]');
    grid;
    %legend('vro','vro fpts', 'g2o', 'g2o fpts','eGT');
    legend('vro','g2o');
    %legend('vro','g2o');
    %xlim([-0.1 0.2]);
    %ylim([-0.1 0.4]);
    axis equal;
    hold off;
elseif size(org_poses,2) == 7     % SE3:QUAT
    figure; plot3(org_poses(start_index:end_index,1), org_poses(start_index:end_index,2), org_poses(start_index:end_index,3), 'b-');
    %xlabel('X [m]');
    %ylabel('Y [m]');
    %zlabel('Z [m]');
    %grid;
    %figure; 
    hold on;
    plot3(opt_poses(start_index:end_index,1), opt_poses(start_index:end_index,2), opt_poses(start_index:end_index,3), 'r-');
    xlabel('X [m]');
    ylabel('Y [m]');
    zlabel('Z [m]');
    grid;
    axis equal;
    hold off;
end

end

function plot_groundtruth()
    gt_x = [0 0 2135 2135 0];
    gt_y = [0 1220 1220 0 0];
    gt_x = gt_x / 1000; % [mm] -> [m]
    gt_y = gt_y / 1000; % [mm] -> [m]
    plot(gt_x,gt_y,'g-','LineWidth',2);
end

% function [poses edges] = load_graph(file_name)
%     fid = fopen(file_name);
%     data = textscan(fid, '%s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f');  % 2D format
%     fclose(fid);
% 
%     % Convert data
%     % Pose
%     data_name = data{1};
%     data_name_list = {'VERTEX_SE2','EDGE_SE2','VERTEX_SE3:QUAT','EDGE_SE3:QUAT'};
%     vertex_index = 1;
%     edge_index = 1;
%     for i = 1 : size(data_name,1)
%         if strcmp(data_name{i}, data_name_list{1})    % VERTEX_SE2
%             unit_data =[];
%             for j=3:5
%                 unit_data = [unit_data data{j}(i)];
%             end
%             poses(vertex_index,:) = unit_data;
%             vertex_index = vertex_index + 1;
%         elseif strcmp(data_name{i}, data_name_list{2})    % EDGE_SE2
%             unit_data =[];
%             for j=2:12
%                 unit_data = [unit_data data{j}(i)]; 
%             end
%             edges(edge_index,:) = unit_data;
%             edge_index = edge_index + 1;
%         elseif strcmp(data_name{i}, data_name_list{3}) % VERTEX_SE3:QUAT
%             unit_data =[];
%             for j=3:9
%                 unit_data = [unit_data data{j}(i)];
%             end
%             poses(vertex_index,:) = unit_data;
%             vertex_index = vertex_index + 1;
%         elseif strcmp(data_name{i}, data_name_list{4})    % EDGE_SE3:QUAT
%             unit_data =[];
%             for j=2:31
%                 unit_data = [unit_data data{j}(i)];
%             end
%             edges(edge_index,:) = unit_data;
%             edge_index = edge_index + 1;
%         end
% 
%     end
% end

