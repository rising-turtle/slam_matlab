% Plot the result of graph SLAM, isam
%
% Author : Soonhac Hong (sxhong1@uarl.edu)
% Date : 2/22/12

function plot_isam(org_file_name, opt_file_name)

[org_poses] = load_graph_isp(org_file_name);
[opt_poses] = load_graph_isam(opt_file_name);

% Show the pose
start_index = 1;
%end_index = min(size(org_poses,1), size(opt_poses)); %80;
end_index = size(org_poses,1);
if size(org_poses,2) == 2     % SE2
    figure; plot(org_poses(start_index:end_index,1), org_poses(start_index:end_index,2),'b*-');
    %xlabel('X [m]');
    %ylabel('Y [m]');
    %grid;[e_t_pose e_o_pose] = convert_o2p(f_index, t_pose, o_pose)
    %figure; 
    hold on;
    plot(opt_poses(start_index:end_index,1), opt_poses(start_index:end_index,2),'ro-','LineWidth',2);
    %plot_groundtruth();
    xlabel('X [m]');
    ylabel('Y [m]');
    grid;
    legend('vro','isam'); %,'eGT');
    %xlim([-0.1 0.6]);
    %ylim([-0.1 0.6]);
    hold off;
elseif size(org_poses,2) == 3     % SE3:QUAT
    figure; plot3(org_poses(:,1), org_poses(:,2), org_poses(:,3), 'b:', 'LineWidth',2);
    %xlabel('X [m]');
    %ylabel('Y [m]');
    %zlabel('Z [m]');plot_g2o.m
    %grid;[e_t_pose e_o_pose] = convert_o2p(f_index, t_pose, o_pose)
    %figure; 
    hold on;
    plot3(opt_poses(:,1), opt_poses(:,2), opt_poses(:,3), 'r-.', 'LineWidth',2);
    %plot_groundtruth_3D();
    %plot_gt_etas();
    xlabel('X [m]');
    ylabel('Y [m]');
    zlabel('Z [m]');
    legend('vro','isam','GT_e');
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


% function [t_pose] = load_graph_sam(file_name)
%     fid = fopen(file_name);
%     data = textscan(fid, '%s %d %f %f %f ');  % 2D format
%     fclose(fid);
% 
%     % Convert data
%     % Pose
%     data_name = data{1};
%     data_name_list = {'ODOMETRY','LANDMARK','EDGE3','VERTEX_SE2'};
%     vertex_index = 1;
%     edge_index = 1;
%     for i = 1 : size(data_name,1)
%         if strcmp(data_name{i}, data_name_list{4})    % VERTEX_SE2
%             %unit_data =[];
%             %for j=3:5
%             %    unit_data = [unit_data data{j}(i)];
%             %end
%             f_index(vertex_index,:) = data{2}(i);
%             t_pose(vertex_index,:) = [data{3}(i) data{4}(i) 0];
%             o_pose(vertex_index,:) = [ 0 0 data{5}(i)];
%             vertex_index = vertex_index + 1;
% %         elseif strcmp(data_name{i}, data_name_list{2})    % EDGE_SE2
% %             unit_data =[gt_y = gt_y / [e_t_pose e_o_pose] = convert_o2p(f_index, t_pose, o_pose)1000; % [mm] -> [m]];
% %             for j=4:12
% %                 unit_data = [unit_data data{j}(i)]; 
% %             end%         elseif strcmp(data_name{i}, data_name_list{2})    % EDGE_SE2
% %             unit_data =[];
% %             for j=4:12
% %                 unit_data= [unit_data data{j}(i)]; 
% %             end
% %             edges(edge_index,:) = unit_data;
% %             edge_index = edge_index + 1;
% 
% %             edges(edge_index,:) = unit_data;
% %             edge_index = edge_index + 1;
% %         elseif strcmp(data_name{i}, data_name_list{3}) % VERTEX_SE3:QUAT
% %             unit_data =[];
% %             for j=3:9
% %                 unit_data = [unit_data data{j}(i)];
% %             end
% %             poses(vertex_index,:) = unit_data;
% %             vertex_index = vertex_index + 1;
% %         elseif strcmp(data_name{i}, data_name_list{4})    % EDGE_SE3:QUAT
% %             unit_data =[];
% %             for j=2:31
% %                 unit_data = [unit_data data{j}(i)];
% %             end
% %             edge[e_t_pose e_o_pose] = convert_o2p(f_index, t_pose, o_pose)s(edge_index,:) = unit_data;
% %             edge_index = edge_index + 1;
%         end
% 
%     end
% end

% function [poses] = load_graph_opt(file_name)
%     fid = fopen(file_name);
%     
%         
%     % Convert data
%     % Pose
%     
%     data_name_list = {'Pose2d_Node','Pose2d_Pose2d_Factor'};
%     vertex_index = 1;
%     edge_index = 1;
%     while ~feof(fid) %for i = 1 : size(data_name,1)
%         header = textscan(fid, '%s',1);  % 2D format
%         data_name = header{1};
%         if strcmp(data_name, data_name_list{1})    % VERTEX_SE2
%             data = textscan(fid, '%f (%f,%f,%f)');
%             unit_data =[];
%             for j=1:4
%                 unit_data = [unit_data data{j}];
%             end
%             f_index(vertex_index, :) = unit_data(1);
%             t_pose(vertex_index,:) = [unit_data(2:3) 0];
%             o_pose(vertex_index,:) = [0 0 unit_data(4)];
%             vertex_index = vertex_index + 1;
% %         elseif strcmp(data_name{i}, data_name_list{2})    % EDGE_SE2
% %             unit_data =[];
% %             for j=4:12
% %                 unit_data= [unit_data data{j}(i)]; 
% %             end
% %             edges(edge_index,:) = unit_data;
% %             edge_index = edge_index + 1;
% %         elseif strcmp(data_name{i}, data_name_list{3}) % VERTEX_SE3:QUAT
% %             unit_data =[];
% %             for j=3:9
% %                 unit_data = [unit_data data{j}(i)];
% %             end
% %             poses(vertex_index,:) = unit_data;
% %             vertex_index = vertex_index + 1;
% %         elseif strcmp(data_name{i}, data_name_list{4})    % EDGE_SE3:QUAT
% %             unit_data =[];
% %             for j=2:31
% %                 unit_data = [unit_data data{j}(i)];
% %             end
% %             edges(edge_index,:) = unit_data;
% %             edge_index = edge_index + 1;
%         end
% 
%     end
%     fclose(fid);
%     poses = [t_pose(:,1:2) o_pose(:,3)];
% end

