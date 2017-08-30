% Load graph of vro

function [poses edges fpts_poses fpts_edges] = load_graph_g2o(file_name)
    fid = fopen(file_name);
    data = textscan(fid, '%s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f');  % 2D format
    fclose(fid);

    % Convert data
    % Pose
    data_name = data{1};
    data_name_list = {'VERTEX_SE2','EDGE_SE2','VERTEX_SE3:QUAT','EDGE_SE3:QUAT'};
    fpts_name_list ={'VERTEX_XY','EDGE_SE2_XY'};
    vertex_index = 1;
    edge_index = 1;
    fpts_pose_index =1;
    fpts_edge_index =1;
    fpts_poses =[];
    fpts_edges =[];
    for i = 1 : size(data_name,1)
        if strcmp(data_name{i}, data_name_list{1})    % VERTEX_SE2
            unit_data =[];
            for j=3:5
                unit_data = [unit_data data{j}(i)];
            end
            poses(vertex_index,:) = unit_data;
            vertex_index = vertex_index + 1;
        elseif strcmp(data_name{i}, data_name_list{2})    % EDGE_SE2
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
        elseif strcmp(data_name{i}, data_name_list{3}) % VERTEX_SE3:QUAT
            unit_data =[];
            for j=3:9
                unit_data = [unit_data data{j}(i)];
            end
            poses(vertex_index,:) = unit_data;
            vertex_index = vertex_index + 1;
        elseif strcmp(data_name{i}, data_name_list{4})    % EDGE_SE3:QUAT
            unit_data =[];
            for j=2:31
                unit_data = [unit_data data{j}(i)];
            end
            edges(edge_index,:) = unit_data;
            edge_index = edge_index + 1;
        end

    end
end
