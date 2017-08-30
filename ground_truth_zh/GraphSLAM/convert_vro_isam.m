% Conver the results of VRO to the vertex and edges for isam 
%
% Author : Soonhac Hong (sxhong1@ualr.edu)
% Date : 2/22/12

function [vro_size, e_t_pose_size, feature_points_visual] = convert_vro_isam(data_index, dynamic_index, nFrame, file_name, dir_name, feature_pose_name, feature_flag, index_interval, cmp_option, dense_index, sparse_interval, vro_cpp, constraint_max_interval, vro_name, pose_std_flag, isgframe, pixel_culling_size, min_matched_points, with_lc_flag, dis)

if nargin < 20
    dis = 0;
end

% Load the result of VRO
[f_index, t_pose, o_pose, feature_points, pose_std, icp_ct] = load_vro(data_index,dynamic_index, nFrame, 1, vro_cpp, vro_name, pose_std_flag, isgframe, min_matched_points, with_lc_flag);  % t_pose[mm], o_pose[degree], feature_points [mm]
feature_points_visual = feature_points;
if feature_flag == 0
    feature_points=[];
end

if isempty(feature_points)
    feature_flag = 0;
end
vro_size = size(t_pose,1)

% Interploation for missing constraints
if feature_flag == 0
    [f_index, t_pose, o_pose, feature_points, pose_std] = compensate_vro(f_index, t_pose, o_pose, feature_points, pose_std, pose_std_flag, cmp_option);
else
    feature_points = sampling_feature_points(feature_points, pixel_culling_size);
    %check_camera_projection(feature_points,isgframe);
    [f_index, t_pose, o_pose, feature_points(:,1:2), pose_std] = compensate_vro(f_index, t_pose, o_pose, feature_points(:,1:2), pose_std, pose_std_flag, cmp_option);
    % Generate global index of feature points
    feature_points = generate_feature_index(feature_points);
end



% Conver the odometry to the global poses
% e_t_pose [mm] e_o_pose [radian]
[pose_index e_t_pose e_o_pose e_fpts trajectory_length] = convert_o2p(data_index, dynamic_index, f_index, t_pose, o_pose, feature_points, dense_index, sparse_interval, vro_cpp, isgframe);  
%[pose_index e_t_pose e_o_pose e_fpts] = convert_o2p_adaptive(data_index, dynamic_index, f_index, t_pose, o_pose, feature_points, dense_index, sparse_interval);  % e_t_pose [mm] e_o_pose [radian]

%check_camera_projection2(e_t_pose, e_o_pose, e_fpts, isgframe);


e_t_pose_size = size(e_t_pose,1)
first_pose = e_t_pose(1,:)
last_pose = e_t_pose(end,:)
distance_first_last = sqrt(sum((first_pose(1:3) - last_pose(1:3)).^2))
trajectory_length
length_percentage_error = distance_first_last * 100 / trajectory_length

% Generate an index of feature points on the global poses
if feature_flag == 1
    [g_fpts g_fpts_edges] = convert_fpts2g(pose_index, e_fpts);
end

%check_camera_projection2(e_t_pose, e_o_pose, g_fpts_edges, isgframe);

% plot pose
if dis == 1
    plot_trajectory(e_t_pose, dynamic_index);
end

% Write Vertexcies and Edges
% if feature_flag == 1
%     feature_pose_name = 'pose_feature';
% else
%     feature_pose_name = 'pose';
% end
data_name_list = {'ODOMETRY','LANDMARK','EDGE3','VERTEX_SE3'};
fpts_name_list ={'POINT2','POINT3'};

if pose_std_flag == 1
    if feature_flag == 1
        file_name_final = sprintf('%s%s_%s_%s_%d_%d_fpt_%d_%s_cov.sam',file_name, dir_name, cmp_option, feature_pose_name, vro_size, e_t_pose_size, pixel_culling_size, vro_name);
    else
        file_name_final = sprintf('%s%s_%s_%s_%d_%d_%s_cov.sam',file_name, dir_name, cmp_option, feature_pose_name, vro_size, e_t_pose_size, vro_name);
    end
else
    if feature_flag == 1
        file_name_final = sprintf('%s%s_%s_%s_%d_%d_fpt_%d_%s.sam',file_name, dir_name, cmp_option, feature_pose_name, vro_size, e_t_pose_size, pixel_culling_size, vro_name);
    else
        file_name_final = sprintf('%s%s_%s_%s_%d_%d_%s.sam',file_name, dir_name, cmp_option, feature_pose_name, vro_size, e_t_pose_size, vro_name);
    end
end

file_name_pose = sprintf('%s%s_%s_%s_%d_%d_%s.isp',file_name, dir_name, cmp_option, feature_pose_name, vro_size, e_t_pose_size, vro_name);
icp_ct_file_name_final = sprintf('%s%s_%s_%s_%d_%d_%s_icp.ct',file_name, dir_name, cmp_option, feature_pose_name, vro_size, e_t_pose_size, vro_name);
pose_std_file_name_final = sprintf('%s%s_%s_%s_%d_%d_%s_pose.std',file_name, dir_name, cmp_option, feature_pose_name, vro_size, e_t_pose_size, vro_name);

t_cov = 0.034; % [m] in SR4000
%t_cov = 0.5;
o_cov = 0.5 * pi / 180; % [rad] in SR4000
%o_cov = 3 * pi / 180;

cov_mat = zeros(6,6);
for i=1:size(cov_mat,1)
    if i > 3
        cov_mat(i,i) = o_cov;
    else
        cov_mat(i,i) = t_cov;
    end
end
info_mat = cov_mat^-1;
sqrt_info_mat = sqrt(info_mat);

e_t_pose = e_t_pose/1000;   % [mm] -> [m]
t_pose = t_pose / 1000;   %[mm] -> [m]
o_pose = o_pose * pi / 180;  % [degree] -> [radian]
if feature_flag == 1
    g_fpts(:,2:4) = g_fpts(:,2:4)/1000;  %[mm] -[m]
    g_fpts_edges(:,3:5) = g_fpts_edges(:,3:5)/1000;  %[mm] -> [m]
end

%Convert the euler angles to quaterion
%disp('Convert the euler angles to quaterion.');
%for i=1:size(o_pose,1)
%    temp_rot = euler_to_rot(o_pose(i,1),o_pose(i,2),o_pose(i,3));
%    o_pose_quat(i,:) = R2q(temp_rot);
    %o_pose_quat(i,:) = e2q([o_pose(i,2),o_pose(i,1),o_pose(i,3)]);
%end


f_index(:,2) = f_index(:,2) ; %+ index_interval;  %TODO: Generalize !!!

isp_fd = fopen(file_name_pose, 'w');
for i=1:size(e_t_pose,1)
    fprintf(isp_fd,'%s %d %f %f %f %f %f %f\n', data_name_list{4}, pose_index(i)-1, e_t_pose(i,1), e_t_pose(i,2), e_t_pose(i,3), e_o_pose(i,2), e_o_pose(i,1), e_o_pose(i,3));
end
fclose(isp_fd);

% Analysis pose_std
if pose_std_flag == 1
    [median_pose_std, std_pose_std, unique_pose_step, step1_pose_std_total, step1_pose_std] = analyze_pose_std(f_index, pose_std, 0);
    sigma_level = 1.0; %0.9; %1.0; %0.5; %1.0; %0.9; %1.0;
    %step1_o_std = std_pose_std(1,1:3).*180./pi
    %std_diff = abs(std_pose_std(5,1:3) - std_pose_std(10,1:3))./std_pose_std(10,1:3);
    
    %write pose_std into a file
    pose_std_fd = fopen(pose_std_file_name_final,'w');
    for i=1:size(f_index,1)
        fprintf(pose_std_fd,'%d %d %f %f %f %f %f %f\n', f_index(i,:)-1, pose_std(i,:));
    end
    fclose(pose_std_fd);
end

isam_fd = fopen(file_name_final,'w');
additional_constraints_cnt = 0;
o_constraints=[];
for i=1:size(f_index,1)-1
    %fprintf(isam_fd,'%s %d %d %f %f %f %f %f %f %f %f %f\n', data_name_list{3}, f_index(i,1)-1, f_index(i,2)-1, t_pose(i,1), t_pose(i,2), o_pose(i,3), t_covariance, 0, 0, t_covariance, 0, o_covariance);
    if abs(f_index(i,1) - f_index(i,2)) <= constraint_max_interval
        if vro_cpp == 1
            fprintf(isam_fd,'%s %d %d %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f\n', data_name_list{3}, f_index(i,1)-1, f_index(i,2)-1, t_pose(i,1:3), o_pose(i,1),o_pose(i,2),o_pose(i,3), sqrt_info_mat(1,:), sqrt_info_mat(2,2:6), sqrt_info_mat(3,3:6), sqrt_info_mat(4,4:6), sqrt_info_mat(5,5:6), sqrt_info_mat(6,6));
        else
            if pose_std_flag == 1
                %fprintf(isam_fd,'%s %d %d %f %f %f %f %f %f %f %f %f %f %f %f\n', data_name_list{3}, f_index(i,1)-1, f_index(i,2)-1, t_pose(i,1:3), o_pose(i,2),o_pose(i,1),o_pose(i,3), pose_std(i,4:6), pose_std(i,2),pose_std(i,1),pose_std(i,3));
                
                
                %if (abs(f_index(i,1)-f_index(i,2)) == 1) || check_reliability(pose_std(i,:), median_pose_std(1,:), std_pose_std(1,:), sigma_level) == 1
                %if (abs(f_index(i,1)-f_index(i,2)) == 1) || check_reliability_static(pose_std(i,:), sigma_level) == 1    
                %if (abs(f_index(i,1)-f_index(i,2)) == 1) || check_reliability_static2(pose_std(i,:), sigma_level) == 1    
                %if (abs(f_index(i,1)-f_index(i,2)) == 1) || check_reliability_static3(pose_std(i,:), sigma_level) == 1    
                %if (abs(f_index(i,1)-f_index(i,2)) == 1) || check_reliability_static4(pose_std(i,:), sigma_level) == 1    
                %if (abs(f_index(i,1)-f_index(i,2)) == 1) || check_reliability_static5(pose_std(i,:), sigma_level) == 1    
                %if (abs(f_index(i,1)-f_index(i,2)) == 1) || check_reliability_static6(pose_std(i,:), sigma_level) == 1    
                if (abs(f_index(i,1)-f_index(i,2)) == 1) || check_reliability_static7(pose_std(i,:), sigma_level) == 1    
                %if (abs(f_index(i,1)-f_index(i,2)) == 1) || check_reliability_static8(pose_std(i,:), sigma_level) == 1    
                %if (abs(f_index(i,1)-f_index(i,2)) == 1) || check_reliability_eigen(t_pose(i,:), o_pose(i,:), pose_std(i,:), sigma_level) == 1    
                %if (abs(f_index(i,1)-f_index(i,2)) == 1) || check_reliability_step1based(pose_std(i,:), step1_pose_std(i,:), sigma_level) == 1    
                %if (abs(f_index(i,1)-f_index(i,2)) == 1) || check_reliability_step1based2(pose_std(i,:), step1_pose_std(i,:), sigma_level) == 1    
                %if (abs(f_index(i,1)-f_index(i,2)) == 1) || check_reliability_step1based3(pose_std(i,:), step1_pose_std(i,:), sigma_level) == 1    
                %if (abs(f_index(i,1)-f_index(i,2)) == 1) || check_reliability_composite(pose_std(i,:), step1_pose_std(i,:), std_pose_std) == 1    
                %if (abs(f_index(i,1)-f_index(i,2)) == 1) || check_reliability_compound(pose_std(i,:), step1_pose_std, f_index(i,:)) == 1    
                %if (abs(f_index(i,1)-f_index(i,2)) <= 10)
                if (abs(f_index(i,1)-f_index(i,2)) > 1) 
                    additional_constraints_cnt = additional_constraints_cnt + 1;
                end
                  pose_step = find(unique_pose_step == abs(f_index(i,1)-f_index(i,2)));  
%                 if pose_step > 40
%                     disp('debug here');
%                 end
                    fprintf(isam_fd,'%s %d %d %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f\n', data_name_list{3}, f_index(i,1)-1, f_index(i,2)-1, t_pose(i,1:3), o_pose(i,2),o_pose(i,1),o_pose(i,3), pose_std(i,4:6), pose_std(i,2),pose_std(i,1),pose_std(i,3), median_pose_std(pose_step,4:6), median_pose_std(pose_step,2),median_pose_std(pose_step,1),median_pose_std(pose_step,3), std_pose_std(pose_step,4:6), std_pose_std(pose_step,2),std_pose_std(pose_step,1),std_pose_std(pose_step,3));
                    o_constraints =[o_constraints; o_pose(i,2),o_pose(i,1),o_pose(i,3)];
                end
            else
                fprintf(isam_fd,'%s %d %d %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f\n', data_name_list{3}, f_index(i,1)-1, f_index(i,2)-1, t_pose(i,1:3), o_pose(i,2),o_pose(i,1),o_pose(i,3), sqrt_info_mat(1,:), sqrt_info_mat(2,2:6), sqrt_info_mat(3,3:6), sqrt_info_mat(4,4:6), sqrt_info_mat(5,5:6), sqrt_info_mat(6,6));
            end
        end
    end
end

additional_constraints_cnt

% Compute sum of relative orietation variation
o_constraints_unit = sum(sum(abs(o_constraints)))/(3*size(o_constraints,1));
o_constraints_unit = o_constraints_unit*180/pi

if feature_flag == 1
    for i=1:size(g_fpts,1)
        fprintf(isam_fd,'%s %d %f %f %f\n', data_name_list{2}, g_fpts(i,1)-1, g_fpts(i,2:4));
    end
    
    for i=1:size(g_fpts_edges,1)
        %fprintf(isam_fd,'%s %d %d %f %f %f %f %f %f %f %f %f\n', fpts_name_list{2}, g_fpts_edges(i,1)-1, g_fpts_edges(i,2)-1, g_fpts_edges(i,3:5), sqrt_info_mat(1,1:3), sqrt_info_mat(2,2:3), sqrt_info_mat(3,3));
        fprintf(isam_fd,'%s %d %d %f %f %f %f %f\n', fpts_name_list{2}, g_fpts_edges(i,1)-1, g_fpts_edges(i,2)-1, g_fpts_edges(i,3:5), g_fpts_edges(i,7:8));
    end
end

fclose(isam_fd);
% new_isam_fd = fopen(new_file_name_final,'w');
% for i=1:vro_size
%    fprintf(isam_fd,'%s %d %d %f %f %f %f %f %f %f %f %f\n', data_name_list{1}, new_f_index(i,1)-1, new_f_index(i,2)-1, new_t_pose(i,1), new_t_pose(i,2), new_o_pose(i,3), t_covariance, 0, 0, t_covariance, 0, o_covariance);
%    fprintf(isam_fd,'%s %d %d %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f\n', data_name_list{3}, f_index(i,1)-1, f_index(i,2)-1, new_t_pose(i,1:3), new_o_pose(i,:), sqrt_info_mat(1,:), sqrt_info_mat(2,2:6), sqrt_info_mat(3,3:6), sqrt_info_mat(4,4:6), sqrt_info_mat(5,5:6), sqrt_info_mat(6,6));
% end
% fclose(new_isam_fd);

% Save icp ct
icp_ct_fd = fopen(icp_ct_file_name_final,'w');
for i=1:size(icp_ct,1)
    fprintf(icp_ct_fd,'%d %d %f %f %f %f %f %f %f %f\n', icp_ct(i,:));
end
fclose(icp_ct_fd);




end

function [reliability_flag] = check_reliability_compound(pose_std, step1_pose_std, f_index)
reliability_flag = 1;
compound_std=sum(step1_pose_std(f_index(1):f_index(2)-1,:));

for i=1:6
    if pose_std(i) > compound_std(i)
        reliability_flag = 0;
        break;
    end
end

end

function [reliability_flag] = check_reliability(pose_std, median_pose_std, std_pose_std, sigma_level)
reliability_flag = 1;

for i=1:6
    if pose_std(i) > (median_pose_std(i) + sigma_level * std_pose_std(i))
        reliability_flag = 0;
        break;
    end
end

end

function [reliability_flag] = check_reliability_static(pose_std, sigma_level)
reliability_flag = 1;
translation_sigma = 0.014;  %[m]
orientation_sigma = 0.24*pi/180; %[radian]
std_pose_std = [orientation_sigma,orientation_sigma,orientation_sigma,translation_sigma,translation_sigma,translation_sigma];

for i=1:6
    if pose_std(i) > (sigma_level * std_pose_std(i))
        reliability_flag = 0;
        break;
    end
end

end

function [reliability_flag] = check_reliability_static2(pose_std, sigma_level)
reliability_flag = 1;
translation_sigma = 0.014;  %[m]
orientation_sigma = 0.57*pi/180; %[radian]
std_pose_std = [orientation_sigma,orientation_sigma,orientation_sigma,translation_sigma,translation_sigma,translation_sigma];

for i=1:6
    if pose_std(i) > (sigma_level * std_pose_std(i))
        reliability_flag = 0;
        break;
    end
end

end

function [reliability_flag] = check_reliability_static3(pose_std, sigma_level)
reliability_flag = 1;
translation_sigma = 0.014; %0.014;  %[m]
orientation_sigma_rx = 0.10*pi/180; %0.12*pi/180;%0.57*pi/180; %[radian]
orientation_sigma_ry = 0.10*pi/180; %0.12*pi/180;%0.11*pi/180; %[radian]
orientation_sigma_rz = 0.10*pi/180; %0.12*pi/180;%0.30*pi/180; %[radian]
std_pose_std = [orientation_sigma_ry,orientation_sigma_rx,orientation_sigma_rz,translation_sigma,translation_sigma,translation_sigma];

for i=1:6
    if pose_std(i) > (sigma_level * std_pose_std(i))
        reliability_flag = 0;
        break;
    end
end

end


function [reliability_flag] = check_reliability_static4(pose_std, sigma_level)
reliability_flag = 1;
translation_sigma = 1.1*0.014;  %[m]
orientation_sigma_rx = 1.12*0.24*pi/180;%0.57*pi/180; %[radian]
orientation_sigma_ry = 1.12*0.24*pi/180;%0.11*pi/180; %[radian]
orientation_sigma_rz = 1.12*0.24*pi/180;%0.30*pi/180; %[radian]
std_pose_std = [orientation_sigma_ry,orientation_sigma_rx,orientation_sigma_rz,translation_sigma,translation_sigma,translation_sigma];

for i=1:6
    if pose_std(i) > (sigma_level * std_pose_std(i))
        reliability_flag = 0;
        break;
    end
end

end

function [reliability_flag] = check_reliability_static5(pose_std, sigma_level)
reliability_flag = 1;
translation_sigma = 0.007; %14;  %[m]
orientation_sigma_rx = 0.16*pi/180;%0.57*pi/180; %[radian]
orientation_sigma_ry = 0.16*pi/180;%0.11*pi/180; %[radian]
orientation_sigma_rz = 0.16*pi/180;%0.30*pi/180; %[radian]
std_pose_std = [orientation_sigma_ry,orientation_sigma_rx,orientation_sigma_rz,translation_sigma,translation_sigma,translation_sigma];

for i=1:6
    if pose_std(i) > (sigma_level * std_pose_std(i))
        reliability_flag = 0;
        break;
    end
end

end

function [reliability_flag] = check_reliability_static6(pose_std, sigma_level)
reliability_flag = 1;
translation_sigma = 0.007; %14;  %[m]
orientation_sigma_rx = 0.12*pi/180;%0.57*pi/180; %[radian]
orientation_sigma_ry = 0.12*pi/180;%0.11*pi/180; %[radian]
orientation_sigma_rz = 0.12*pi/180;%0.30*pi/180; %[radian]
std_pose_std = [orientation_sigma_ry,orientation_sigma_rx,orientation_sigma_rz,translation_sigma,translation_sigma,translation_sigma];

for i=1:6
    if pose_std(i) > (sigma_level * std_pose_std(i))
        reliability_flag = 0;
        break;
    end
end

end


function [reliability_flag] = check_reliability_static7(pose_std, sigma_level)
reliability_flag = 1;
translation_sigma = 0.056; %14;  %[m]
orientation_sigma_rx = 0.96*pi/180;%0.57*pi/180; %[radian]
orientation_sigma_ry = 0.96*pi/180;%0.11*pi/180; %[radian]
orientation_sigma_rz = 0.96*pi/180;%0.30*pi/180; %[radian]
std_pose_std = [orientation_sigma_ry,orientation_sigma_rx,orientation_sigma_rz,translation_sigma,translation_sigma,translation_sigma];

for i=1:6
    if pose_std(i) > (sigma_level * std_pose_std(i))
        reliability_flag = 0;
        break;
    end
end

end

function [reliability_flag] = check_reliability_static8(pose_std, sigma_level)
reliability_flag = 1;
translation_sigma = 0.028; %14;  %[m]
orientation_sigma_rx = 0.48*pi/180;%0.57*pi/180; %[radian]
orientation_sigma_ry = 0.48*pi/180;%0.11*pi/180; %[radian]
orientation_sigma_rz = 0.48*pi/180;%0.30*pi/180; %[radian]
std_pose_std = [orientation_sigma_ry,orientation_sigma_rx,orientation_sigma_rz,translation_sigma,translation_sigma,translation_sigma];

for i=1:6
    if pose_std(i) > (sigma_level * std_pose_std(i))
        reliability_flag = 0;
        break;
    end
end

end

function [reliability_flag] = check_reliability_step1based(pose_std, step1_pose_std, sigma_level)
reliability_flag = 1;
translation_sigma = 0.014;  %[m]
orientation_sigma = 0.12*pi/180;%0.57*pi/180; %[radian]
std_pose_std = [orientation_sigma,orientation_sigma,orientation_sigma,translation_sigma,translation_sigma,translation_sigma];

for i=1:6
    if pose_std(i) >  std_pose_std(i) && pose_std(i) > (sigma_level * step1_pose_std(i)) 
        reliability_flag = 0;
        break;
    end
end

end

function [reliability_flag] = check_reliability_step1based2(pose_std, step1_pose_std, sigma_level)
reliability_flag = 1;
translation_sigma = 0.014;  %[m]
orientation_sigma = 0.12*pi/180;%0.57*pi/180; %[radian]
std_pose_std = [orientation_sigma,orientation_sigma,orientation_sigma,translation_sigma,translation_sigma,translation_sigma];

for i=1:6
    %if pose_std(i) >  std_pose_std(i) && pose_std(i) > (sigma_level * step1_pose_std(i)) 
    if pose_std(i) > (sigma_level * step1_pose_std(i)) 
        reliability_flag = 0;
        break;
    end
end

end


function [reliability_flag] = check_reliability_step1based3(pose_std, step1_pose_std, sigma_level)
reliability_flag = 0;
translation_sigma = 0.014;  %[m]
orientation_sigma = 0.12*pi/180;%0.57*pi/180; %[radian]
std_pose_std = [orientation_sigma,orientation_sigma,orientation_sigma,translation_sigma,translation_sigma,translation_sigma];

for i=1:6
    %if pose_std(i) >  std_pose_std(i) && pose_std(i) > (sigma_level * step1_pose_std(i)) 
    if pose_std(i) < (sigma_level * step1_pose_std(i)) 
        reliability_flag = 1;
        break;
    end
end

end


function [reliability_flag] = check_reliability_composite(pose_std, step1_pose_std, std_pose_std)
[step1_max_orientation, max_idx]= max(std_pose_std(1,1:3));
step10_step5_ratio = abs(std_pose_std(10,max_idx)-std_pose_std(5,max_idx))/std_pose_std(10,max_idx);
step10_step5_ratio_rz = abs(std_pose_std(10,3)-std_pose_std(5,3))/std_pose_std(10,3);

if  step1_max_orientation*180/pi  < 0.1 || (step1_max_orientation*180/pi > 0.7 &&  step10_step5_ratio < 0.35  && step10_step5_ratio_rz < 0.55)
    reliability_flag = check_reliability_static3(pose_std, 0.9);
else
    reliability_flag = check_reliability_step1based(pose_std, step1_pose_std, 1.0);
end

end


function [reliability_flag] = check_reliability_eigen(t_pose, o_pose, pose_std, sigma_level)
reliability_flag = 1;
translation_sigma = 0.014;  %[m]
orientation_sigma_rx = 0.12*pi/180;%0.57*pi/180; %[radian]
orientation_sigma_ry = 0.12*pi/180;%0.11*pi/180; %[radian]
orientation_sigma_rz = 0.12*pi/180;%0.30*pi/180; %[radian]
std_pose_std = [orientation_sigma_ry,orientation_sigma_rx,orientation_sigma_rz,translation_sigma,translation_sigma,translation_sigma];

%find dominant movement
t_eigen_thresh = 0.020; %[m]
o_eigen_thresh = 1*pi/180;
eigen_index =zeros(6,1);
for i=1:6
    if i>=4  %translation
        if t_pose(i-3) > t_eigen_thresh
            eigen_index(i) = 1;
        end
    else
        if o_pose(i) > o_eigen_thresh
            eigen_index(i) = 1;
        end
    end
end

for i=1:6
    
    if eigen_index(i) == 1 && pose_std(i) > (sigma_level * std_pose_std(i))
        reliability_flag = 0;
        break;
    end
end

end


function check_camera_projection(feature_points, isgframe)
cam = initialize_cam();
features_info=[];
ros_sba_T = sr4k_p2T([0,0,0,pi/2,0,0]);

camera_index_list=unique(feature_points(:,1));

for i=1:size(camera_index_list,1)
    camera_index = camera_index_list(i);
    data_index_list = find((feature_points(:,1) == camera_index & feature_points(:,3) == 1) | (feature_points(:,2) == camera_index & feature_points(:,3) == 2));
    unit_data = feature_points(data_index_list,:);
    estimated_uv = [];
    for j=1:size(unit_data,1)
%         if i==40
%             disp('debug');
%         end
        if strcmp(isgframe, 'gframe')
            temp_p = [unit_data(j,4:6) 1]';
        else
            temp_p = ros_sba_T * [unit_data(j,4:6) 1]';
        end
        estimated_uv(j,:) = hi_cartesian_test(temp_p(1:3), [0;0;0], eye(3), cam, features_info )';
    end
    figure;
    plot(estimated_uv(:,1), estimated_uv(:,2),'b+');
    hold on;
    plot(unit_data(:,7),unit_data(:,8),'ro');
    legend('Estimated','Measured');
    hold off;
    
    projection_error = sqrt(sum((estimated_uv - unit_data(:,7:8)).^2,2));
    projection_error_mean_std(i,:) = [mean(projection_error), std(projection_error)]; 
end

figure;
errorbar(projection_error_mean_std(:,1), projection_error_mean_std(:,2),'b');


end

function check_camera_projection2(e_t_pose, e_o_pose, e_fpts, isgframe)

cam = initialize_cam();
features_info=[];
ros_sba_T = sr4k_p2T([0,0,0,pi/2,0,0]);

% camera_index_list=unique(feature_points(:,1));

for i=1:size(e_t_pose,1)
%     camera_index = camera_index_list(i);
%     data_index_list = find((feature_points(:,1) == camera_index & feature_points(:,3) == 1) | (feature_points(:,2) == camera_index & feature_points(:,3) == 2));
%     unit_data = feature_points(data_index_list,:);
    temp_t = e_t_pose(i,1:3)';
    if strcmp(isgframe, 'gframe') 
        temp_R = e2R([e_o_pose(i,2),e_o_pose(i,1),e_o_pose(i,3)]');  
    else
        temp_R = euler_to_rot(e_o_pose(i,1)*180/pi,e_o_pose(i,2)*180/pi,e_o_pose(i,3)*180/pi);
    end
    %temp_R = eye(3);
%     T = [temp_R, temp_t; 0 0 0 1];
%     T = ros_sba_T*T;  % Convert Bundler frame to SBA frame.
%     temp_t = T(1:3,4);
%     temp_R = T(1:3,1:3);
    if iscell(e_fpts)
        unit_data = e_fpts{i};
    else
        data_index_list = find(e_fpts(:,1) == i);
        unit_data = e_fpts(data_index_list,2:end);
    end
    
    
    estimated_uv = [];
    for j=1:size(unit_data,1)
%         if i==40
%             disp('debug');
%         end
        %temp_p = ros_sba_T * [unit_data(j,2:4) 1]';
        temp_p = [unit_data(j,2:4) 1]';
        %estimated_uv(j,:) = hi_cartesian_test(temp_p(1:3), [0;0;0], eye(3), cam, features_info )';
        if strcmp(isgframe, 'gframe') 
            estimated_uv(j,:) = hi_cartesian_test(temp_p(1:3), temp_t, temp_R, cam, features_info)';
        else
            estimated_uv(j,:) = vro_camera_projection(temp_p(1:3), temp_t, temp_R, cam, features_info, ros_sba_T)';
        end
    end
    figure;
    plot(estimated_uv(:,1), estimated_uv(:,2),'b+');
    hold on;
    plot(unit_data(:,6),unit_data(:,7),'ro');
    legend('Estimated','Measured');
    hold off;
    
    projection_error = sqrt(sum((estimated_uv - unit_data(:,6:7)).^2,2));
    projection_error_mean_std(i,:) = [mean(projection_error), std(projection_error)]; 
end

figure;
errorbar(projection_error_mean_std(:,1), projection_error_mean_std(:,2),'b');

end



function plot_trajectory(e_pose, dynamic_index)
    e_pose = e_pose/1000;
    figure;
    if dynamic_index == 18
        cube2m = 0.3048;        % 1cube = 12 inch = 0.3048 m
        gt_x=[];
        gt_y=[];
        [px,py] = plot_arc([1*cube2m;5*cube2m],[0;5*cube2m],[1*cube2m;6*cube2m]);
        gt_x =[gt_x px];
        gt_y =[gt_y py];
        [px,py] = plot_arc([12*cube2m;5*cube2m],[12*cube2m;6*cube2m],[13*cube2m;5*cube2m]);
        gt_x =[gt_x px];
        gt_y =[gt_y py];
        [px,py] = plot_arc([12*cube2m;0],[13*cube2m;0],[12*cube2m;-1*cube2m]);
        gt_x =[gt_x px];
        gt_y =[gt_y py];
        [px,py] =plot_arc([1*cube2m;0],[1*cube2m;-1*cube2m],[0;0]);
        gt_x =[gt_x px gt_x(1)];
        gt_y =[gt_y py gt_y(1)];
        %gt_x = [0 0 1*inch2m 12*inch2m 13*inch2m 13*inch2m 12*inch2m 1*inch2m 0 ];
        %gt_y = [0 5*inch2m 6*inch2m 6*inch2m 5*inch2m 0 -1*inch2m -1*inch2m 0];
%         plot([0;0],[0;5*inch2m],'r-','LineWidth',2);
%         plot([1*inch2m;12*inch2m],[6*inch2m;6*inch2m],'r-','LineWidth',2);
%         plot([13*inch2m;13*inch2m],[5*inch2m;0],'r-','LineWidth',2);
%         plot([12*inch2m;1*inch2m],[-1*inch2m;-1*inch2m],'r-','LineWidth',2);
    elseif dynamic_index >= 15 && dynamic_index <= 17
        gt_x = [0 0 2.135 2.135 0];
        gt_y = [0 1.220 1.220 0 0];
    else
        inch2m = 0.0254;        % 1 inch = 0.0254 m
        gt_x = [0 0 150 910 965 965 910 50 0 0];
        gt_y = [0 24 172.5 172.5 122.5 -122.5 -162.5 -162.5 -24 0];
        
        gt_x = [gt_x 0 0 60 60+138 60+138+40 60+138+40 60+138 60 0 0];
        gt_y = [gt_y 0 24 38.5+40 38.5+40 38.5 -38.5 -38.5-40 -38.5-40 -24 0];
        
        gt_x = gt_x * inch2m;
        gt_y = gt_y * inch2m;
    end
    plot(e_pose(:,1),e_pose(:,2),'b-');
    %hold on;
    %plot(gt_x,gt_y,'r-','LineWidth',2);
    
    xlabel('X [m]');
    ylabel('Y [m]');
    grid;
    %h_xlabel = get(gca,'XLabel');
    %set(h_xlabel,'FontSize',12,'FontWeight','bold');
    %h_ylabel = get(gca,'YLabel');
    %set(h_ylabel,'FontSize',12,'FontWeight','bold');
    legend('Estimated Pose','Estimated Truth');
    %legend('Estimated Pose');
    %xlim([-0.5 4.5]);
    %ylim([-18 6]);
    axis equal;
    hold off;
    
    figure;
    if dynamic_index == 18
        inch2m = 0.3048;        % 1cube = 12 inch = 0.3048 m
        gt_x=[];
        gt_y=[];
        [px,py] = plot_arc([1*inch2m;5*inch2m],[0;5*inch2m],[1*inch2m;6*inch2m]);
        gt_x =[gt_x px];
        gt_y =[gt_y py];
        [px,py] = plot_arc([12*inch2m;5*inch2m],[12*inch2m;6*inch2m],[13*inch2m;5*inch2m]);
        gt_x =[gt_x px];
        gt_y =[gt_y py];
        [px,py] = plot_arc([12*inch2m;0],[13*inch2m;0],[12*inch2m;-1*inch2m]);
        gt_x =[gt_x px];
        gt_y =[gt_y py];
        [px,py] =plot_arc([1*inch2m;0],[1*inch2m;-1*inch2m],[0;0]);
        gt_x =[gt_x px gt_x(1)];
        gt_y =[gt_y py gt_y(1)];
        gt_z =zeros(1, length(gt_x));
    else
        gt_x = [0 0 2.135 2.135 0];
        gt_y = [0 1.220 1.220 0 0];
        gt_z = [0 0 0 0 0];
    end
    
    
    plot3(e_pose(:,1),e_pose(:,2),e_pose(:,3),'b-');
    %hold on;
    %plot3(gt_x,gt_y,gt_z,'r-','LineWidth',2);
    xlabel('X [m]');
    ylabel('Y [m]');
    zlabel('Z [m]');
    grid;
    h_xlabel = get(gca,'XLabel');
    set(h_xlabel,'FontSize',12,'FontWeight','bold');
    h_ylabel = get(gca,'YLabel');
    set(h_ylabel,'FontSize',12,'FontWeight','bold');
    legend('Estimated Pose','Estimated Truth');
    axis equal;
end


function [px, py] = plot_arc(P0,P1,P2)
 n = 50; % The number of points in the arc
 v1 = P1-P0;
 v2 = P2-P0;
 c = det([v1,v2]); % "cross product" of v1 and v2
 a = linspace(0,atan2(abs(c),dot(v1,v2)),n); % Angle range
 v3 = [0,-c;c,0]*v1; % v3 lies in plane of v1 and v2 and is orthog. to v1
 v = v1*cos(a)+((norm(v1)/norm(v3))*v3)*sin(a); % Arc, center at (0,0)
 px = v(1,:) + P0(1);
 py = v(2,:) + P0(2);
 %plot(v(1,:)+P0(1),v(2,:)+P0(2),'r-','LineWidth',2) % Plot arc, centered at P0
 %hold on;
 %axis equal
end
