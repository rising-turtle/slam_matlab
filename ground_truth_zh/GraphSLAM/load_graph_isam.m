% Load the graph of isam

function [poses] = load_graph_isam(file_name)
    fid = fopen(file_name);
            
    % Convert data
    % Pose
    
    data_name_list = {'Pose2d_Node','Pose2d_Pose2d_Factor','Pose3d_Node'};
    vertex_index = 1;
    edge_index = 1;
    while ~feof(fid) %for i = 1 : size(data_name,1)
        header = textscan(fid, '%s',1);  % 2D format
        data_name = header{1};
        if strcmp(data_name, data_name_list{1})    % VERTEX_SE2
            data = textscan(fid, '%f (%f,%f,%f)');
            unit_data =[];
            for j=1:4
                unit_data = [unit_data data{j}];
            end
            f_index(vertex_index, :) = unit_data(1);
            t_pose(vertex_index,:) = unit_data(2:3);
            o_pose(vertex_index,:) = unit_data(4);
            vertex_index = vertex_index + 1;
%         elseif strcmp(data_name{i}, data_name_list{2})    % EDGE_SE2
%             unit_data =[];
%             for j=4:12
%                 unit_data= [unit_data data{j}(i)]; 
%             end
%             edges(edge_index,:) = unit_data;
%             edge_index = edge_index + 1;
        elseif strcmp(data_name, data_name_list{3}) % VERTEX_SE3:QUAT
            data = textscan(fid, '%f (%f,%f,%f;%f,%f,%f)');
            unit_data =[];
            for j=2:7
                unit_data = [unit_data data{j}];
            end
            t_pose(vertex_index,:) = unit_data(1:3);
            o_pose(vertex_index,:) = unit_data(4:6);
            vertex_index = vertex_index + 1;
%         elseif strcmp(data_name{i}, data_name_list{4})    % EDGE_SE3:QUAT
%             unit_data =[];
%             for j=2:31
%                 unit_data = [unit_data data{j}(i)];
%             end
%             edges(edge_index,:) = unit_data;
%             edge_index = edge_index + 1;
        end

    end
    fclose(fid);
    poses = [t_pose o_pose];
end