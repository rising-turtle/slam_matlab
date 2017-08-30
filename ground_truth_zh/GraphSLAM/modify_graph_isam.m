% Load the graph of isam

function modify_graph_isam(input_file_name)
    
    temp_file_name = textscan(input_file_name,'%s','Delimiter','.');
    output_file_name = sprintf('%s_modified.sam',temp_file_name{1}{1,1});
    
    fid = fopen(input_file_name);
            
    % Convert data
    % Pose
    
    data_name_list = {'EDGE3','POINT3'};
    vertex_index = 1;
    edge_index = 1;
    while ~feof(fid) %for i = 1 : size(data_name,1)
        %header = textscan(fid, '%s',1);  % 2D format
        %data_name = header{1};
        %if strcmp(data_name, data_name_list{1})    % VERTEX_SE2
            data = textscan(fid, '%s %d %d %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f\n');
%             unit_data =[];
%             for j=1:4
%                 unit_data = [unit_data data{j}];
%             end
%             f_index(vertex_index, :) = unit_data(1);
%             t_pose(vertex_index,:) = unit_data(2:3);
%             o_pose(vertex_index,:) = unit_data(4);
%             vertex_index = vertex_index + 1;
%         elseif strcmp(data_name{i}, data_name_list{2})    % EDGE_SE2
%             unit_data =[];
%             for j=4:12
%                 unit_data= [unit_data data{j}(i)]; 
%             end
%             edges(edge_index,:) = unit_data;
%             edge_index = edge_index + 1;
        %elseif strcmp(data_name, data_name_list{2}) % VERTEX_SE3:QUAT
        %    data = textscan(fid, '%s %d %d %f %f %f %f %f %f %f %f %f\n');
%             unit_data =[];
%             for j=2:7
%                 unit_data = [unit_data data{j}];
%             end
%             t_pose(vertex_index,:) = unit_data(1:3);
%             o_pose(vertex_index,:) = unit_data(4:6);
%             vertex_index = vertex_index + 1;
%         elseif strcmp(data_name{i}, data_name_list{4})    % EDGE_SE3:QUAT
%             unit_data =[];
%             for j=2:31
%                 unit_data = [unit_data data{j}(i)];
%             end
%             edges(edge_index,:) = unit_data;
%             edge_index = edge_index + 1;
        %end

    end
    fclose(fid);
    
    fod = fopen(output_file_name,'w');
    pose_index = 0 ;
    
    for j=1:size(data{1},1)
        j
        for i=1:size(data{1},1)
            if strcmp(data{1}(i), data_name_list{1}) && data{1,2}(i) == pose_index
                    unit_data=[];
                    for k=1:size(data,2)
                        unit_data = [unit_data data{k}(i)];
                    end
                    fprintf(fod,'%s %d %d %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f\n',unit_data{1:30});
            elseif strcmp(data{1}(i), data_name_list{2}) && data{1,2}(i) == (pose_index+1)
                    unit_data=[];
                    for k=1:12
                        unit_data = [unit_data data{k}(i)];
                    end
                    fprintf(fod,'%s %d %d %f %f %f %f %f %f %f %f %f\n',unit_data{1}, unit_data{2}-1, unit_data{3}-1, unit_data{4:12});
            end
        end
        pose_index = pose_index + 1;
    end
    fclose(fod);
    %poses = [t_pose o_pose];
end