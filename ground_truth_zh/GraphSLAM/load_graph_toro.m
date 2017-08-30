% Plot the data of TORO
% Author : Soonhac Hong (sxhong1@ualr.edu)
% Date : 4/19/2012


function [poses edges fpts_poses fpts_edges] = load_graph_toro(file_name)
    fid = fopen(file_name);
    data = textscan(fid, '%s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f');  % 2D format
    fclose(fid);

    % Convert data
    % Pose
    data_name = data{1};
    data_name_list = {'VERTEX','EDGE','VERTEX2','EDGE2','VERTEX3','EDGE3'};
    fpts_name_list ={'VERTEX_XY','EDGE_SE2_XY'};
    vertex_index = 1;
    edge_index = 1;
    fpts_pose_index =1;
    fpts_edge_index =1;
    fpts_poses =[];
    fpts_edges =[];
    for i = 1 : size(data_name,1)
        if strcmp(data_name{i}, data_name_list{1}) || strcmp(data_name{i}, data_name_list{3})    % VERTEX
            unit_data =[];
            for j=3:5
                unit_data = [unit_data data{j}(i)];
            end
            poses(vertex_index,:) = unit_data;
            vertex_index = vertex_index + 1;
        elseif strcmp(data_name{i}, data_name_list{2}) || strcmp(data_name{i}, data_name_list{4})   % EDGE
            unit_data =[];
            for j=2:12
                unit_data = [unit_data data{j}(i)]; 
            end
            edges(edge_index,:) = unit_data;
            edge_index = edge_index + 1;
        elseif strcmp(data_name{i}, fpts_name_list{1})    % VERTEX_XY
            unit_data =[];
            for j=3:5
                unit_data = [unit_data data{j}(i)];
            end
            fpts_poses(fpts_pose_index,:) = unit_data;
            fpts_pose_index = fpts_pose_index + 1;
        elseif strcmp(data_name{i}, fpts_name_list{2})    % EDGE_SE2_XY
            unit_data =[];
            for j=2:12
                unit_data = [unit_data data{j}(i)]; 
            end
            fpts_edges(fpts_edge_index,:) = unit_data;
            fpts_edge_index = fpts_edge_index + 1;
        elseif strcmp(data_name{i}, data_name_list{5}) % VERTEX3
            unit_data =[];
            for j=3:8
                unit_data = [unit_data data{j}(i)];
            end
            poses(vertex_index,:) = unit_data;
            vertex_index = vertex_index + 1;
        elseif strcmp(data_name{i}, data_name_list{6})    % EDGE3
            unit_data =[];
            for j=2:30
                unit_data = [unit_data data{j}(i)];
            end
            edges(edge_index,:) = unit_data;
            edge_index = edge_index + 1;
        end

    end