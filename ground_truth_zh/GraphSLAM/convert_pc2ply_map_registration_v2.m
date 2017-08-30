% Write 3D point clouds to a ply file using map registration algorithm
% Conver isp to ply for meshlab 
%
% Author : Soonhac Hong (sxhong1@ualr.edu)
% History : 
% 1/8/14 : Created
% 2/27/14 : Update map by mean value of correspondence and include quality
% factor

function convert_pc2ply_map_registration_v2(ply_headers, ply_file_name, poses, data_index, dynamic_index, isgframe)
data_name_list=get_data_name_list(); %{'pitch', 'pan', 'roll','x2', 'y2', 'c1', 'c2','c3','c4','m','etas','loops2','kinect_tum','sparse_feature','motive',};


feature_ply_file_name=strrep(ply_file_name, '.ply','_feature_mag_reg_v2.ply')
feature_ct_file_name=strrep(ply_file_name, '.ply','_feature_mag_reg_v2.ct')


% Write headers
pose_interval = 1;
sample_interval = 2;
image_width = 176;
image_height = 144;
show_image_width = floor(image_width/sample_interval);
show_image_height = floor(image_height/sample_interval);
% nfeature = size(poses,1)*show_image_width*show_image_height;
% element_vertex_n = sprintf('element vertex %d',nfeature);
% ply_headers{4} = element_vertex_n;

% for i=1:size(ply_headers,2)
%     fprintf(fd,'%s\n',ply_headers{i});
% end

% Write data
for i = 1:size(poses,1)
%     if vro_cpp == 1
%         h{i} = [euler_to_rot(vro_o_pose(i,2), vro_o_pose(i,1), vro_o_pose(i,3)) vro_t_pose(i,:)'; 0 0 0 1];
%     else
    if strcmp(isgframe, 'gframe')
        h{i} = [e2R([poses(i,4), poses(i,5), poses(i,6)]) poses(i,1:3)'; 0 0 0 1];  % e2R([rx,ry,rz]) [radian]
    else
        h{i} = [euler_to_rot(poses(i,5)*180/pi, poses(i,4)*180/pi, poses(i,6)*180/pi) poses(i,1:3)'; 0 0 0 1];  % euler_to_rot(ry, rx, rz) [degree]
    end
end

distance_threshold_max = 5; %8; %5;
distance_threshold_min = 0.8; 
ply_data=[];
ply_data_index = 1;
map=[];
map_kd_tree=[];
map_quality=[];
last_pose = size(poses,1)
map_ct=[];
for i=1:pose_interval:last_pose
    i
    if check_stored_visual_feature(data_name_list{data_index+5}, dynamic_index, i, true, 'intensity') == 0
        [img, x, y, z, c, elapsed_pre] = LoadSR_no_bpc(data_name_list{data_index+5}, 'gaussian', 0, dynamic_index, i, 1, 'int');
    else
        [frm, des, elapsed_sift, img, x, y, z, c, elapsed_pre] = load_visual_features(data_name_list{data_index+5}, dynamic_index, i, true, 'intensity');
    end
    
    confidence_threshold = floor(max(max(c))/2);
    %confidence_threshold = 0;  % for object_recognition
    
    ct_start=tic;
    unit_map=[];
    for j=1:show_image_width
        for k=1:show_image_height
            col_idx = (j-1)*sample_interval + 1;
            row_idx = (k-1)*sample_interval + 1;
            %unit_pose = [x(row_idx,col_idx), y(row_idx, col_idx), z(row_idx, col_idx)];
            unit_pose = [-x(row_idx,col_idx), z(row_idx, col_idx), y(row_idx, col_idx)];
            unit_pose_distance = sqrt(sum(unit_pose.^2));
            %if img(row_idx, col_idx) > 50
            if unit_pose(3) <= -0.1 && img(row_idx, col_idx) < 200 % 50
                if c(row_idx,col_idx) >= confidence_threshold && unit_pose_distance < distance_threshold_max && unit_pose_distance > distance_threshold_min
                    unit_pose_global = h{i}*[unit_pose, 1]';
                    [map_registration_flag, unit_map_quality, map]=check_map_registration(map_kd_tree, map, [unit_pose_global(1:3,1)', double(img(row_idx, col_idx))]); 
                    if map_registration_flag
                        unit_color = [img(row_idx, col_idx),img(row_idx, col_idx),img(row_idx, col_idx)];
                        %fprintf(fd,'%f %f %f %d %d %d\n',unit_pose_global(1:3,1)', unit_color);
                        ply_data(ply_data_index,:) = [unit_pose_global(1:3,1)', double(unit_color)];
                        unit_map(ply_data_index,:) = [unit_pose_global(1:3,1)', double(unit_color(1)), 0, 1];  %[x,y,z,gray,radius,n]
                        ply_data_index = ply_data_index + 1;
                    else
                        if unit_map_quality >= 0
                            map_quality = [map_quality; unit_map_quality];
                        end
                    end
                end
            end
        end
    end
    map = [map; unit_map];
    %update k-d tree with new map
    map_kd_tree = kdtree_build(map(:,1:4));
    map_ct(i,1) = toc(ct_start);
end

% Write data
nply_data = size(ply_data,1)
element_vertex_n = sprintf('element vertex %d',nply_data);
ply_headers{4} = element_vertex_n;

fd = fopen(feature_ply_file_name, 'w');
for i=1:size(ply_headers,2)
    fprintf(fd,'%s\n',ply_headers{i});
end

for i=1:nply_data
    fprintf(fd,'%f %f %f %d %d %d\n',ply_data(i,:));
end

fclose(fd);

%save computational time
dlmwrite(feature_ct_file_name,map_ct,' ');

% Display map quality
mean_map_quality = mean(map_quality)
std_map_quality = std(map_quality)

    
end


function [registration_flag, map_quality, map] = check_map_registration(map_kd_tree, map, point)    
    registration_flag = true;
    dist_th = 0.3; % [m]
    gray_th = 255*0.01;  % [gray level]
    map_quality = -1;
    
    if ~isempty(map_kd_tree)
        % find closest point using kd-tree
        temp_idx = kdtree_nearest_neighbor(map_kd_tree, point);
        closest_point = map(temp_idx,:);
        dist = norm(point(1:3) - closest_point(1:3));
        gray_dist = abs(point(4) - closest_point(4));
        
        % check distance less than threshold and determine the flag
        if dist < dist_th && gray_dist < gray_th
            registration_flag = false;
            map(temp_idx,1:4) = sum([point;closest_point(1:4)*closest_point(6)])/(closest_point(6)+1);
            map_quality = norm(map(temp_idx,1:3)-point(1:3));
            map(temp_idx,5) = map_quality;
            map(temp_idx,6) = map(temp_idx,6) + 1;
        end
    end
end

