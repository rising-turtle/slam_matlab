% Conver the results of VRO to the vertex and edges for g2o 
%
% Author : Soonhac Hong (sxhong1@ualr.edu)
% Date : 2/22/12

function [vro_size] = run_gslam(data_index, dynamic_index, nFrame, g2o_file_name, g2o_dir_name, feature_flag, index_interval, dis)

if nargin < 8
    dis = 0;
end

% Load the result of VRO
disp('Load the result from VRO.');
[f_index, t_pose, o_pose, feature_points] = load_vro(data_index,dynamic_index, nFrame, feature_flag);  % t_pose[mm], o_pose[degree]
if isempty(feature_points)
    feature_flag = 0;
end
vro_size = size(t_pose,1)

% Convert the odometry and feature points to the global poses
disp('Convert the VRO and feauture points w.r.t the glabal frame.');
[pose_index, e_t_pose e_o_pose e_ftps] = convert_o2p(f_index, t_pose, o_pose, feature_points);


% graph slam 
% Set the dimension of the filter
N = 20;
num_landmarks = 0;
%dim = 2 * (N + num_landmarks); % x1,y1,x2,y2.....
dim = 3 * (N + num_landmarks); % x1,y1,z1,x2,y2,z2.....
motion_noise = 34;   % [mm]
o_noise = 0.24 * 2;

% make the constraint information matrix and vector
Omega = zeros(dim, dim);
Omega(1,1) = 1.0;
Omega(2,2) = 1.0;
Omega(3,3) = 1.0;

Xi = zeros(dim, 1);
Xi(1:3) = 0;      % first frame locate at (0,0)

data_index = min(find(f_index(:,2) == N));
%data_index = min(find(f_index(:,1) == (N-1)));

% process the data
for k = 0 : data_index-1
    
    % n is the index of the robot pose in the matrix/vector
    %n = k * 2; 
    %n1 = (f_index(k+1,1)-1)*2;
    %n2 = (f_index(k+1,2)-1)*2;
    
    %if abs(f_index(k+1,1) - f_index(k+1,2)) >= 2 && abs(f_index(k+1,1) - f_index(k+1,2)) <= 3
    if (max(abs((t_pose(k+1,1) - t_pose(k+1,2)))) >= motion_noise || max(abs((o_pose(k+1,1) - o_pose(k+1,2)))) >= o_noise) ...
       && (max(abs((t_pose(k+1,1) - t_pose(k+1,2)))) <= motion_noise*3 || max(abs((o_pose(k+1,1) - o_pose(k+1,2)))) <= o_noise*3)
    n = k * 3; 
    n1 = (f_index(k+1,1)-1)*3
    n2 = (f_index(k+1,2)-1)*3
    
    %measurement = feature_points(k+1,:); %data[k][0]
    %motion = t_pose(k+1,1:2); %data[k][1]
    motion = t_pose(k+1,:); %data[k][1]
    R = euler_to_rot(o_pose(k+1,1), o_pose(k+1,2), o_pose(k+1,3));
    
    % integrate the measurements
%     for i = 1: size(feature_points)
    
        % m is the index of the landmark coordinate in the matrix/vector
        %m = 2 * (N + measurement[i][0])
    
        %update the information maxtrix/vector based on the measurement
%             for b in range(2):
%                 Omega.value[n+b][n+b] +=  1.0 / measurement_noise
%                 Omega.value[m+b][m+b] +=  1.0 / measurement_noise
%                 Omega.value[n+b][m+b] += -1.0 / measurement_noise
%                 Omega.value[m+b][n+b] += -1.0 / measurement_noise
%                 Xi.value[n+b][0]      += -measurement[i][1+b] / measurement_noise
%                 Xi.value[m+b][0]      +=  measurement[i][1+b] / measurement_noise


        %update the information maxtrix/vector based on the robot motion
%         for b = 1:2
%             %Omega(n+b, n+b) =  Omega(n+b, n+b) + 1.0 / motion_noise;    % (x1,x1), (y1,y1), (x2,x2), (y2,y2)
%             Omega(n1+b, n1+b) =  Omega(n1+b, n1+b) + 1.0 / motion_noise;    %(x1,x1), (y1,y1), (x2,x2), (y2,y2)
%             Omega(n2+b, n2+b) =  Omega(n2+b, n2+b) + 1.0 / motion_noise;    %(x1,x1), (y1,y1), (x2,x2), (y2,y2)
%         end
%         
%         for b = 1:2
%             Omega(n1+b,n2+b) = Omega(n1+b, n2+b) + (-1.0) / motion_noise;
%             Omega(n2+b, n1+b) = Omega(n2+b, n1+b) + (-1.0) / motion_noise;
%             Xi(n1+b)= Xi(n1+b) - motion(b) / motion_noise;
%             Xi(n2+b)= Xi(n2+b) +  motion(b) / motion_noise;
%         end
        
        for b = 1:3
            %Omega(n+b, n+b) =  Omega(n+b, n+b) + 1.0 / motion_noise;    % (x1,x1), (y1,y1), (x2,x2), (y2,y2)
            Omega(n1+b, n1+b) =  Omega(n1+b, n1+b) + 1.0 / motion_noise;    %(x1,x1), (y1,y1), (z1,z1)
%             Omega(n2+b, n2+b) =  Omega(n2+b, n2+b) + (1.0) / motion_noise;    %(x2,x2), (y2,y2), (z2, z2)
            Omega(n2+b, n2+b) =  Omega(n2+b, n2+b) + (1.0)*R(b,b) / motion_noise;    %(x2,x2), (y2,y2), (z2, z2)
            d_index = [1 2 3];
            b_index = find(d_index == b);
            d_index(b_index)=[];
            for d = 1:size(d_index,2)
                Omega(n2+b, n2+d_index(d)) =  Omega(n2+b, n2+d_index(d)) + (1.0)*R(b,d_index(d)) / motion_noise;
            end
        end
        
        for b = 1:3
%             Omega(n1+b,n2+b) = Omega(n1+b, n2+b) + (-1.0) / motion_noise;
            Omega(n1+b,n2+b) = Omega(n1+b, n2+b) + (-1.0)*R(b,b) / motion_noise;
            d_index = [1 2 3];
            b_index = find(d_index == b);
            d_index(b_index)=[];
            for d = 1:size(d_index,2)
                Omega(n1+b, n2+d_index(d)) =  Omega(n1+b, n2+d_index(d)) + (-1.0)*R(b,d_index(d)) / motion_noise;
            end
            Omega(n2+b,n1+b) = Omega(n2+b, n1+b) + (-1.0) / motion_noise;
            Xi(n1+b)= Xi(n1+b) - motion(b) / motion_noise;
            Xi(n2+b)= Xi(n2+b) +  motion(b) / motion_noise;
        end
    end
end

%compute best estimate
mu = (Omega^-1) * Xi;

g_t_pose=[];
temp_index = 1;
for i=1:3:size(mu,1)
    g_t_pose(temp_index,:) =  [mu(i), mu(i+1), mu(i+2)];
    temp_index = temp_index + 1;
end

%Show the result
figure;
plot(g_t_pose(:,1), g_t_pose(:,2),'r*-');
hold on;
plot(e_t_pose(1:N,1), e_t_pose(1:N,2),'bo-');
hold off

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

function plot_trajectory(e_pose, fpts)
    figure;
    gt_x = [0 0 2135 2135 0];
    gt_y = [0 1220 1220 0 0];
    plot(e_pose(:,1),e_pose(:,2),'bo-');
    hold on;
    plot(gt_x,gt_y,'r-','LineWidth',2);
    if ~isempty(fpts)
        plot(fpts(:,2),fpts(:,3),'gd');
        legend('Estimated Pose','Estimated Truth','feature points');
    else
        legend('Estimated Pose','Estimated Truth');
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

