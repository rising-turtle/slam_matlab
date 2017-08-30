% Conver isp to ply for meshlab 
%
% Author : Soonhac Hong (sxhong1@ualr.edu)
% Date : 4/1/13

function generate_video(isp_file_name, opt_file_name, file_index, dynamic_index, isgframe, vro_name)

close all;

[poses] = load_graph_isp(isp_file_name);
[opt_poses] = load_graph_isp(opt_file_name);

%     convert_feature2ply(ply_headers, ply_file_name, poses, file_index, dynamic_index, isgframe);

data_name_list={'pitch', 'pan', 'roll','x2', 'y2', 'c1', 'c2','c3','c4','m','etas','loops2','kinect_tum','sparse_feature','swing'};


% Write headers
pose_interval = 4;
sample_interval = 3;
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
for i = 1:size(opt_poses,1)
%     if vro_cpp == 1
%         h{i} = [euler_to_rot(vro_o_pose(i,2), vro_o_pose(i,1), vro_o_pose(i,3)) vro_t_pose(i,:)'; 0 0 0 1];
%     else
    if strcmp(isgframe, 'gframe')
        h{i} = [e2R([opt_poses(i,4), opt_poses(i,5), opt_poses(i,6)]) opt_poses(i,1:3)'; 0 0 0 1];  % e2R([rx,ry,rz]) [radian]
    else
        h{i} = [euler_to_rot(opt_poses(i,5)*180/pi, opt_poses(i,4)*180/pi, opt_poses(i,6)*180/pi) opt_poses(i,1:3)'; 0 0 0 1];  % euler_to_rot(ry, rx, rz) [degree]
    end
end

distance_threshold_max = 5;
distance_threshold_min = 0.8; 

x_min = min(opt_poses(:,1)) - 1;
x_max = max(opt_poses(:,1)) + 1;
y_min = min(opt_poses(:,2)) - 1;
y_max = max(opt_poses(:,2)) + 1;
z_min = min(opt_poses(:,3)) - 1;
z_max = max(opt_poses(:,3)) + 1;

scrsz = get(0,'ScreenSize');
% figure(video_figure);
video_figure=figure('Position',[scrsz(3)/4 scrsz(4)/4 scrsz(3)/2 scrsz(4)/2]);

[prefix, confidence_read] = get_sr4k_dataset_prefix(data_name_list{file_index+3}, dynamic_index);
vidObj = VideoWriter(sprintf('%s_gslam_vf.avi', prefix));
vidObj.Quality=100;
vidObj.FrameRate=5;
%vidObj.Height=scrsz(4)/2;
%vidObj.Width=scrsz(3)/2;

open(vidObj);

for i=1:size(opt_poses,1)
    i
    
    % show images
    if check_stored_visual_feature(data_name_list{file_index+3}, dynamic_index, i, true, 'intensity') == 0
        [img, x, y, z, c, elapsed_pre] = LoadSR(data_name_list{file_index+3}, 'gaussian', 0, dynamic_index, i, 1, 'int');
    else
        [frm, des, elapsed_sift, img, x, y, z, c, elapsed_pre] = load_visual_features(data_name_list{file_index+3}, dynamic_index, i, true, 'intensity');
        if i>=2
            [match_num, ransac_iteration, op_pset1_image_index, op_pset2_image_index, op_pset_cnt, elapsed_match, elapsed_ransac, op_pset1, op_pset2] = load_matched_points(data_name_list{file_index+3}, dynamic_index, i-1, i, 'none', true);
        end
    end
    subplot(1,2,1);imshow(img);colormap(gray); 
    if i>=2
        hold on;
        for j=1:size(op_pset2_image_index,1)
            subplot(1,2,1);plot(round(op_pset2_image_index(j,1))+1, round(op_pset2_image_index(j,2))+1,'r+','Markersize',10); 
        end
    end
    axis image;
%     set(gca,'XTick',[]);
%     set(gca,'YTick',[]);
    
    % show poses
    subplot(1,2,2);plot3(poses(i,1),poses(i,2),poses(i,3),'g.','LineWidth', 2); 
    hold on;
    subplot(1,2,2);plot3(opt_poses(i,1),opt_poses(i,2),opt_poses(i,3),'r.', 'LineWidth',2);
    grid on;
    axis equal;
    axis([x_min x_max y_min y_max z_min z_max]);
    xlabel('X');ylabel('Y');zlabel('Z');
    %axis equal;
    %hold off;
%     if mod(i,pose_interval) == 1    
%         
%         confidence_threshold = floor(max(max(c))/2);
%         
%         for j=1:show_image_width
%             for k=1:show_image_height
%                 col_idx = (j-1)*sample_interval + 1;
%                 row_idx = (k-1)*sample_interval + 1;
%                 %unit_pose = [x(row_idx,col_idx), y(row_idx, col_idx), z(row_idx, col_idx)];
%                 unit_pose = [-x(row_idx,col_idx), z(row_idx, col_idx), y(row_idx, col_idx)];
%                 unit_pose_distance = sqrt(sum(unit_pose.^2));
%                 %if img(row_idx, col_idx) > 50
%                 if unit_pose(3) <= -0.1
%                     if c(row_idx,col_idx) >= confidence_threshold && unit_pose_distance < distance_threshold_max && unit_pose_distance > distance_threshold_min
%                         unit_pose_global = h{i}*[unit_pose, 1]';
%                         unit_color = [img(row_idx, col_idx),img(row_idx, col_idx),img(row_idx, col_idx)]./255;
%                         %fprintf(fd,'%f %f %f %d %d %d\n',unit_pose_global(1:3,1)', unit_color);
%                         %ply_data(ply_data_index,:) = [unit_pose_global(1:3,1)', double(unit_color)];
%                         %ply_data_index = ply_data_index + 1;
%                         subplot(1,2,2);plot3(unit_pose_global(1,1),unit_pose_global(2,1),unit_pose_global(3,1),'Color',unit_color);
%                         grid;
%                     end
%                 end
%             end
%         end
%     end
    
    
    
    currFrame = getframe(video_figure);
    writeVideo(vidObj,currFrame);
    
    drawnow;
end

hold off;

close(vidObj);

end
