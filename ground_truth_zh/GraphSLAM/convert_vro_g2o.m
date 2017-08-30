% Conver the results of VRO to the vertex and edges for g2o 
%
% Author : Soonhac Hong (sxhong1@ualr.edu)
% Date : 2/22/12

function [vro_size] = convert_vro_g2o(data_index, dynamic_index, nFrame, g2o_file_name, g2o_dir_name, feature_flag, index_interval, cmp_option,  dense_index, sparse_interval, dis)

if nargin < 9
    dis = 0;
end

% Load the result of VRO
disp('Load the result from VRO.');
[f_index, t_pose, o_pose, feature_points] = load_vro(data_index,dynamic_index, nFrame, feature_flag);  % t_pose[mm], o_pose[degree]
if isempty(feature_points)
    feature_flag = 0;
end
vro_size = size(t_pose,1)

% Interploation for missing constraints
if feature_flag == 0
    [f_index, t_pose, o_pose, feature_points] = compensate_vro(f_index, t_pose, o_pose, feature_points, cmp_option);
else
    [f_index, t_pose, o_pose, feature_points(:,1:2)] = compensate_vro(f_index, t_pose, o_pose, feature_points(:,1:2), cmp_option);
end

% Convert the odometry and feature points to the global poses
disp('Convert the VRO and feauture points w.r.t the glabal frame.');
%dense_index = 1;
[pose_index, e_t_pose, e_o_pose, e_ftps] = convert_o2p(data_index, dynamic_index, f_index, t_pose, o_pose, feature_points, dense_index, sparse_interval); %convert_o2p(f_index, t_pose, o_pose, feature_points, dense_index);
% e_t_pose [mm]
% e_o_pose [radian]

% Generate an index of feature points on the global poses
disp('Generate an index of feature points on the global poses.');
if feature_flag == 1
    [g_fpts g_fpts_edges] = convert_fpts2g(pose_index, e_fpts);
else
    g_fpts=[];
    g_fpts_edges=[];
end

% plot pose
if dis == 1
    if data_index == 10
        gt_dis = 1;
    else
        gt_dis = 0;
    end
    plot_trajectory(e_t_pose, g_fpts, gt_dis);
end

% Write Vertexcies and Edges
if feature_flag == 1
    feature_pose_name = 'pose_feature';
else
    feature_pose_name = 'pose';
end
data_name_list = {'VERTEX_SE2','EDGE_SE2','VERTEX_SE3:QUAT','EDGE_SE3:QUAT'};
fpts_name_list ={'VERTEX_XY','EDGE_SE2_XY'};
g2o_file_name_final = sprintf('%s%s_%s_%s_%d.g2o',g2o_file_name, g2o_dir_name, cmp_option, feature_pose_name, vro_size)
g2o_fd = fopen(g2o_file_name_final,'w');

t_cov = 0.034; % [m] in SR4000
o_cov = 0.5 * pi / 180; % [rad] in SR4000
%cov_mat = [t_cov 0 0; 0 t_cov 0; 0 0 o_cov];
cov_mat = zeros(6,6);
for i=1:size(cov_mat,1)
    if i > 3
        cov_mat(i,i) = o_cov;
    else
        cov_mat(i,i) = t_cov;
    end
end
info_mat = cov_mat^-1;
sqrt_info_mat = info_mat; %sqrt(info_mat);

e_t_pose = e_t_pose/1000;   % [mm] -> [m]
t_pose = t_pose / 1000;   %[mm] -> [m]
%o_pose = o_pose * pi / 180;  % [degree] -> [radian]
e_o_pose = e_o_pose * 180 /pi; % [radian] -> [degree]

%Convert the euler angles to quaterion
disp('Convert the euler angles to quaterion.');
for i=1:size(o_pose,1)
    temp_rot = euler_to_rot(o_pose(i,1),o_pose(i,2),o_pose(i,3)); % input(ry, rx, rz) [degree]
    o_pose_quat(i,:) = R2q(temp_rot);
    %o_pose_quat(i,:) = e2q([o_pose(i,2),o_pose(i,1),o_pose(i,3)]);
end

for i=1:size(e_o_pose,1)
    temp_rot = euler_to_rot(e_o_pose(i,1), e_o_pose(i,2), e_o_pose(i,3)); % input(ry, rx, rz) [degree]
    e_o_pose_quat(i,:) = R2q(temp_rot);
    %e_o_pose_quat(i,:) = e2q([e_o_pose(i,2),e_o_pose(i,1),e_o_pose(i,3)]);
end

if ~isempty(g_fpts)
    g_fpts(:,2:4) = g_fpts(:,2:4) / 1000;  %[mm] -> [m]
end

if ~isempty(g_fpts_edges)
    g_fpts_edges(:,3:5) = g_fpts_edges(:,3:5) / 1000;  % [mm] -> [m]
end

f_index(:,2) = f_index(:,2) + index_interval;

for i=1:size(e_t_pose,1)
    %fprintf(g2o_fd,'%s %d %f %f %f\n', data_name_list{3}, pose_index(i)-1, e_t_pose(i,1:2), e_o_pose(i,3));
    %if (max(t_pose(i,:)) >= t_cov *4) || (max(o_pose(i,:)) >= o_cov*4)
        %fprintf(g2o_fd,'%s %d %f %f %f %f %f %f %f\n', data_name_list{3}, pose_index(i)-1, e_t_pose(i,1:3), e_o_pose_quat(i,2), e_o_pose_quat(i,1), e_o_pose_quat(i,3));
        fprintf(g2o_fd,'%s %d %f %f %f %f %f %f %f\n', data_name_list{3}, pose_index(i)-1, e_t_pose(i,1:3), e_o_pose_quat(i,:));
    %end
end

for i=1:size(f_index,1)-1 %vro_size-1
    %if (max(t_pose(i,:)) >= t_cov *4) || (max(o_pose(i,:)) >= o_cov*4)
        %fprintf(g2o_fd,'%s %d %d %f %f %f %f %f %f %f %f %f\n', data_name_list{4}, f_index(i,1)-1, f_index(i,2)-1, t_pose(i,1), t_pose(i,2), o_pose(i,3), sqrt_info_mat(1,1), sqrt_info_mat(1,2), sqrt_info_mat(1,3), sqrt_info_mat(2,2), sqrt_info_mat(2,3), sqrt_info_mat(3,3));
        fprintf(g2o_fd,'%s %d %d %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f\n', data_name_list{4}, f_index(i,1)-1, f_index(i,2)-1, t_pose(i,1:3), o_pose_quat(i,:), sqrt_info_mat(1,:), sqrt_info_mat(2,2:6), sqrt_info_mat(3,3:6), sqrt_info_mat(4,4:6), sqrt_info_mat(5,5:6), sqrt_info_mat(6,6));
    %end
end

if feature_flag == 1
    for i=1:size(g_fpts,1)
        fprintf(g2o_fd,'%s %d %f %f \n', fpts_name_list{1}, g_fpts(i,1:3));
    end
    
    for i=1:size(g_fpts_edges,1)
        fprintf(g2o_fd,'%s %d %d %f %f %f %f %f \n', fpts_name_list{2}, g_fpts_edges(i,1:4), t_covariance, 0, t_covariance);
    end
end

fclose(g2o_fd);

end

function [isExist previous_index] = getPreviousIndex(data_set,pts)
    isExist = 0;
    previous_index = 0;
    distance_threshold = 41;   % [mm]; typical absolute accuracy + 3 * typical repeatibility of SR4000 = 20 + 3 * 7 = 41
    for i=1:size(data_set,1)
        if data_set(i,1) > 0 && data_set(i,1) == pts(1)   % Skip non-valid data
            distance = sqrt(sum((data_set(i,3:5)-pts(4:6)).^2));
            if distance <= distance_threshold
                isExist = 1;
                previous_index = data_set(i,2);
                break;
            end
        end
    end
end

function plot_trajectory(e_pose, fpts, gt_dis)
    figure;
    gt_x = [0 0 2135 2135 0];
    gt_y = [0 1220 1220 0 0];
    plot(e_pose(:,1),e_pose(:,2),'bo-');
    hold on;
    if gt_dis == 1
        plot(gt_x,gt_y,'r-','LineWidth',2);
    end
    if ~isempty(fpts)
        plot(fpts(:,2),fpts(:,3),'gd');
        if gt_dis == 1
            legend('Estimated Pose','Estimated Truth','feature points');
        else
            legend('Estimated Pose','feature points');
        end
    else
        if gt_dis == 1
            legend('Estimated Pose','Estimated Truth');
        else
            legend('Estimated Pose');
        end
    end
    xlabel('X [mm]');
    ylabel('Y [mm]');
    grid;
    h_xlabel = get(gca,'XLabel');
    set(h_xlabel,'FontSize',12,'FontWeight','bold');
    h_ylabel = get(gca,'YLabel');
    set(h_ylabel,'FontSize',12,'FontWeight','bold');
    
    hold off;
    
    figure;
    gt_x = [0 0 2135 2135 0];
    gt_y = [0 1220 1220 0 0];
    gt_z = [0 0 0 0 0];
    plot3(e_pose(:,1),e_pose(:,2),e_pose(:,3),'bo-');
    hold on;
    plot3(gt_x,gt_y,gt_z,'r-','LineWidth',2);
    if ~isempty(fpts)
        plot3(fpts(:,2),fpts(:,3),fpts(:,4),'gd');
        legend('Estimated Pose','Estimated Truth','feature points');
    else
        legend('Estimated Pose','Estimated Truth');
    end
    xlabel('X [mm]');
    ylabel('Y [mm]');
    zlabel('Z [mm]');
    grid;
    h_xlabel = get(gca,'XLabel');
    set(h_xlabel,'FontSize',12,'FontWeight','bold');
    h_ylabel = get(gca,'YLabel');
    set(h_ylabel,'FontSize',12,'FontWeight','bold');
    legend('Estimated Pose','Estimated Truth');
end

