% Plot the result of graph SLAM, g2o
%
% Author : Soonhac Hong (sxhong1@uarl.edu)
% Date : 2/22/12

function plot_toro(org_file_name, opt_file_name, feature_flag)

[ org_poses org_edges org_fpts_poses org_fpts_edges] = load_graph_toro(org_file_name);
[ opt_poses opt_edges opt_fpts_poses opt_fpts_edges] = load_graph_toro(opt_file_name);

% Show the pose
start_index = 1;
end_index = min(size(org_poses,1), size(opt_poses,1)); %80;
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
    legend('vro','toro');
    %legend('vro','g2o');
    %xlim([-0.1 0.2]);
    %ylim([-0.1 0.4]);
    hold off;
elseif size(org_poses,2) == 6     % 3D
    figure; plot3(org_poses(:,1), org_poses(:,2), org_poses(:,3), 'b:', 'LineWidth',2);
    %xlabel('X [m]');
    %ylabel('Y [m]');
    %zlabel('Z [m]');
    %grid;
    %figure; 
    hold on;
    plot3(opt_poses(:,1), opt_poses(:,2), opt_poses(:,3), 'r-.', 'LineWidth',2);
    %plot_groundtruth_3D();
    %plot_gt_etas();
    xlabel('X [m]');
    ylabel('Y [m]');
    zlabel('Z [m]');
    %legend('vro','TORO','GT_e');
    legend('vro','TORO','GT_e');
    grid;
    axis equal;
    hold off;
    show_errors(org_poses, opt_poses);
end

end

function show_errors(org_poses, opt_poses)

% Show last position
last_org = org_poses(end,:)
last_opt = opt_poses(end,:)

distance_org = sqrt(sum(org_poses(end,1:3).^2))
distance_opt = sqrt(sum(opt_poses(end,1:3).^2))

z_rmse_org = sqrt(mean(org_poses(:,3).^2))
z_rmse_opt = sqrt(mean(opt_poses(:,3).^2))

z_me_org = mean(abs(org_poses(:,3)))
z_me_opt = mean(abs(opt_poses(:,3)))

end

function plot_groundtruth()
    gt_x = [0 0 2135 2135 0];
    gt_y = [0 1220 1220 0 0];
    gt_x = gt_x / 1000; % [mm] -> [m]
    gt_y = gt_y / 1000; % [mm] -> [m]
    plot(gt_x,gt_y,'g-','LineWidth',2);
end

function plot_groundtruth_3D()
%     inch2mm = 304.8;        % 1 cube = 12 inch = 304.8 mm
%     gt_x = [0 0 13*inch2mm 13*inch2mm 0];
%     gt_y = [-1*inch2mm 6*inch2mm 6*inch2mm -1*inch2mm -1*inch2mm];
%     %gt_x = [0 0 2135 2135 0];
%     %gt_y = [0 1220 1220 0 0];
%     gt_z = [0 0 0 0 0];
%     gt_x = gt_x / 1000; % [mm] -> [m]
%     gt_y = gt_y / 1000; % [mm] -> [m]
%     gt_z = gt_z / 1000; % [mm] -> [m]
    
    inch2m = 0.0254;        % 1 inch = 0.0254 m
    gt_x = [0 0 150 910 965 965 910 50 0 0];
    gt_y = [0 24 172.5 172.5 122.5 -122.5 -162.5 -162.5 -24 0];
    
    gt_x = [gt_x 0 0 60 60+138 60+138+40 60+138+40 60+138 60 0 0];
    gt_y = [gt_y 0 24 38.5+40 38.5+40 38.5 -38.5 -38.5-40 -38.5-40 -24 0];
    
    gt_x = gt_x * inch2m;
    gt_y = gt_y * inch2m;
    gt_z = zeros(length(gt_x),1);    
    plot3(gt_x,gt_y,gt_z,'g-','LineWidth',2);
    
    
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

