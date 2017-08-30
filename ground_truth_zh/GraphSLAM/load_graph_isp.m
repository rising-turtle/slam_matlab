function [t_pose] = load_graph_isp(file_name)
    fid = fopen(file_name);
    data = textscan(fid, '%s %d %f %f %f %f %f %f');  % 2D format
    fclose(fid);

    % Convert data
    % Pose
    data_name = data{1};
    data_name_list = {'ODOMETRY','LANDMARK','EDGE3','VERTEX_SE2', 'VERTEX_SE3'};
    vertex_index = 1;
    edge_index = 1;
    for i = 1 : size(data_name,1)
        if strcmp(data_name{i}, data_name_list{4})    % VERTEX_SE2
            %unit_data =[];
            %for j=3:5
            %    unit_data = [unit_data data{j}(i)];
            %end
            f_index(vertex_index,:) = data{2}(i);
            t_pose(vertex_index,:) = [data{3}(i) data{4}(i)];
            o_pose(vertex_index,:) = data{5}(i);
            vertex_index = vertex_index + 1;
%         elseif strcmp(data_name{i}, data_name_list{2})    % EDGE_SE2
%             unit_data =[gt_y = gt_y / [e_t_pose e_o_pose] = convert_o2p(f_index, t_pose, o_pose)1000; % [mm] -> [m]];
%             for j=4:12
%                 unit_data = [unit_data data{j}(i)]; 
%             end%         elseif strcmp(data_name{i}, data_name_list{2})    % EDGE_SE2
%             unit_data =[];
%             for j=4:12
%                 unit_data= [unit_data data{j}(i)]; 
%             end
%             edges(edge_index,:) = unit_data;
%             edge_index = edge_index + 1;

%             edges(edge_index,:) = unit_data;
%             edge_index = edge_index + 1;
        elseif strcmp(data_name{i}, data_name_list{5}) % VERTEX_SE3:QUAT
            unit_data =[];
            for j=3:8
                unit_data = [unit_data data{j}(i)];
            end
            t_pose(vertex_index,:) = unit_data;  % include orientation pose
            vertex_index = vertex_index + 1;
%         elseif strcmp(data_name{i}, data_name_list{4})    % EDGE_SE3:QUAT
%             unit_data =[];
%             for j=2:31
%                 unit_data = [unit_data data{j}(i)];
%             end
%             edge[e_t_pose e_o_pose] = convert_o2p(f_index, t_pose, o_pose)s(edge_index,:) = unit_data;
%             edge_index = edge_index + 1;
        end

    end
end