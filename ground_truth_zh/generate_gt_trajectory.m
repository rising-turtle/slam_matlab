% input: inf: *.csv file 
% Assumption : Motion caputre data of MOTIVE(file format : *.csv) has at
% least 5 markers on camera
% output: ouf: .log file [timestamp x, y, z, qx, qy, qz, qw]

% Author : David Zhang (hxzhang1@ualr.edu)
% Date : Jan. 28 2018

function generate_gt_trajectory(inf, ouf)
clear all
clc
clf
close all

if nargin == 0 
    inf = './motion_capture_data/Dense_Slow_640x480_30_b.csv';
    ouf = './motion_capture_data/Dense_Slow_640x480_30_b_trajectory.log';
end

%% add 3rd libraries
add_path_zh;

%% open and load the data 
fid = fopen(inf);
if fid < 0
    error(['Cannot open file ' inf]);
end

%% 
[unused, gt, gt_total] = scan_data(fid);  

%% T pattern, find matched points 
%    ---|---  4/5  1  5/4
%       |          2
%       |          3

% find the T pattern in each frame, and find 5 matched points
[ gt_total_pair ] = find_pair_tp( gt_total );
[ gt_total_pair(:,11:16)] = find_pair_nn( gt_total_pair(:,11:16));

%% added by Yimin Zhao on @13/07/2015
marker=[];
for m=1:5
    marker=[marker; [gt_total_pair(1,(m-1)*3+2),gt_total_pair(1,(m-1)*3+3),gt_total_pair(1,(m-1)*3+4)]];
end
%% transform all the points from the motion capture coordinate frame into local coordinate frame
% set the origin of motion capture system to the center of five LEDs in initial position
% origin =  mean(marker,1);
% gt_total_pair(:,2:end) = gt_total_pair(:,2:end) - repmat(origin, size(gt_total_pair,1), 5); % some concern

% f_w = f_l*R_l2w, p^l = R_l2w * p^w 
[R_l2w, t_l2w] = compute_initial_T(marker);
[ gt_total_pair(:,2:16)] = transform_pc( gt_total_pair(:,2:16), R_l2w, t_l2w);
[ gt(:, 2:4)] = transform_pc(gt(:, 2:4), R_l2w, t_l2w); 

%% original of Soonhac
%gt_total_pair(:,2:end) = gt_total_pair(:,2:end) - repmat(gt_total_pair(1,2:4), size(gt_total_pair,1), 5);

%% generate pose
[gt_pose, gt_pose_euler, distance_total] = compute_transformation(gt_total_pair); 

%% only convert with dataset_3 
% gt_pose = [gt_pose(:,1), gt_pose(:,2), gt_pose(:,3), gt_pose(:,4:end)];

%% plot result 
% plot_distance(distance_total); 
plot_gt_pose(gt_pose_euler); 
% plot_Rxyz(gt_pose_euler); 
% plot_ground_truth1(gt);
plot_gt_pairs(gt_total_pair); 
% plot_ground_truth2(gt_total);
% plot_TPattern(gt_total); 
% plot_displacement(gt_total);

%% Save result 
% out_file_name=strrep(data_file_name, 'csv','dat_wp');
% total_out_file_name=strrep(data_file_name, 'csv','dat_total_wp');
% gt_pose_out_file_name=strrep(data_file_name, 'csv','dat_pose_wp');

% dlmwrite(out_file_name,gt,' '); % [time_stamp x y z]
% dlmwrite(total_out_file_name,gt_total_pair,' '); % [time_stamp [x y z]*5]
% dlmwrite(gt_pose_out_file_name,gt_pose,' '); % [time_stamp [x y z q1 q2 q3 q4]

dlmwrite(ouf,gt_pose,' '); % [time_stamp [x y z q1 q2 q3 q4]

end

function [gt_pose, gt_pose_euler, distance_total] = add_new_trans(rot, trans, timestamp, ... 
    op_pset1, op_pset2, gt_pose,gt_pose_euler, distance_total)
   
    q = R2q(rot);
    gt_pose=[gt_pose; timestamp, trans' q'];
    %
    e = R2e(rot);
    gt_pose_euler=[gt_pose_euler; timestamp, trans' e'];

    % check relative distance b/w markers for rigid body
    if i==1
        for k=2:5
            distance(k-1)=norm(op_pset1(k,:)-op_pset1(1,:));
        end
        distance_total=[distance_total; distance];
    end
    for k=2:5
        distance(k-1)=norm(op_pset2(k,:)-op_pset2(1,:));
    end
    distance_total=[distance_total; distance];

end

function [gt_pose, gt_pose_euler, distance_total] = compute_transformation(gt_total_pair)
gt_pose=[gt_total_pair(1,1), 0,0,0,1,0,0,0];
gt_pose_euler=[gt_total_pair(1,1), 0,0,0,0,0,0];
distance_total=[];
for i=1:size(gt_total_pair,1)-1
    op_pset1 = [];
    op_pset2 = [];
    for k=1:5
        op_pset1 = [op_pset1; gt_total_pair(1,2+(k-1)*3:4+(k-1)*3)];
        op_pset2 = [op_pset2; gt_total_pair(i+1,2+(k-1)*3:4+(k-1)*3)];
    end
    [rot, trans, sta] = find_transform_matrix(op_pset2', op_pset1');
    % [rot, trans, sta] = find_transform_matrix(op_pset1', op_pset2');
    
    if sta > 0
       [gt_pose, gt_pose_euler, distance_total] = add_new_trans(rot, trans, gt_total_pair(i+1,1),...
           op_pset1, op_pset2, gt_pose, gt_pose_euler, distance_total);
    else
        % sta;
%        [rot, trans, valid] = computeT_with_previous(op_pset1, op_pset2, gt_pose_euler); 
%        if valid % find valid transformation 
%             [gt_pose, gt_pose_euler, distance_total] = add_new_trans(rot, trans, gt_total_pair(i+1,1), ...
%             op_pset1, op_pset2, gt_pose, gt_pose_euler, distance_total);
%        end
        
        %% use this more robust function to compute [R, t]
        [rot, trans] = eq_point(op_pset2', op_pset1');
        % [rot, trans] = eq_point(op_pset1', op_pset2');
        [gt_pose, gt_pose_euler, distance_total] = add_new_trans(rot, trans, gt_total_pair(i+1,1), ...
            op_pset1, op_pset2, gt_pose, gt_pose_euler, distance_total);
    end
end
end


function plot_distance(distance_total)
%% show relative distance between marker for checking rigid body
figure;
plot_colors={'b.','r.','g.','m.','c.'};
for k=1:4
    plot(distance_total(:,k),plot_colors{k});
    hold on;
end
xlabel('Frame');
ylabel('Relative Distance');
grid;
legend('v^1_2','v^1_3','v^1_4','v^1_5');
hold off;
end

function plot_gt_pose(gt_pose_euler)
%% show gt_pose
figure;
plot3(gt_pose_euler(:,2),gt_pose_euler(:,3),gt_pose_euler(:,4),'.-');
hold on;
plot3(gt_pose_euler(1,2),gt_pose_euler(1,3),gt_pose_euler(1,4),'g*', 'MarkerSize', 20);
hold off;
axis equal;
grid;
xlabel('X');ylabel('Y');zlabel('Z');
title('Translaton');
end

function plot_Rxyz(gt_pose_euler)
plot_colors={'b.','r.','g.','m.','c.'};
figure;
title_list ={'Rx','Ry','Rz'};
for i=1:3
    %plot(gt_pose(:,i+4),plot_colors{i});
    %subplot(3,1,i);plot(gt_pose_euler(:,i),plot_colors{i});
    subplot(3,1,i);plot(gt_pose_euler(:,i+4)*180/pi(),plot_colors{i});
    title(title_list{i});grid;
    %hold on;
end
xlabel('frame');
%ylabel('Orientation [quaternion]');
ylabel('Orientation [degree]');
%legend('Rx','Ry','Rz');
end

function plot_ground_truth1(gt)

%% show ground truth
figure;
plot3(gt(:,2),gt(:,3),gt(:,4),'.-');
hold on;
plot3(gt(1,2),gt(1,3),gt(1,4),'g*', 'MarkerSize', 10);
hold off;
axis equal;
grid;
xlabel('X');ylabel('Y');zlabel('Z');
end

function plot_gt_pairs(gt_total_pair)
%% show ground truth by pairs
plot_colors={'b.','r.','g.','m.','c.'};
figure;
%plot_colors={'b.-','r.-','g.-','m.-','c.-'};
for i=1:5
    plot3(gt_total_pair(:,2+3*(i-1)),gt_total_pair(:,3+3*(i-1)),gt_total_pair(:,4+3*(i-1)),plot_colors{i});
    hold on;
end
plot3(gt_total_pair(1,2),gt_total_pair(1,3),gt_total_pair(1,4),'g*', 'MarkerSize', 20);
hold off;
axis equal;
grid;
xlabel('X');ylabel('Y');zlabel('Z');
title('GT pairs');
end

function plot_TPattern(gt_total)
   plot_colors={'b.','r.','g.','m.','c.'};
   figure;
   px = zeros(5, 1); py = zeros(5,1); pz = zeros(5,1); 
   for i=1:5
       px(i) = gt_total(1,2+3*(i-1)); 
       py(i) = gt_total(1,3+3*(i-1));
       pz(i) = gt_total(1,4+3*(i-1));
       hold on;
       plot3(px(i), py(i), pz(i), plot_colors{i});
   end
grid; 
axis equal; 
hold off; 
end

function plot_ground_truth2(gt_total)
%% show ground truth
plot_colors={'b.','r.','g.','m.','c.'};
figure;
%plot_colors={'b.-','r.-','g.-','m.-','c.-'};
for i=1:5
    plot3(gt_total(:,2+3*(i-1)),gt_total(:,3+3*(i-1)),gt_total(:,4+3*(i-1)),plot_colors{i});
    hold on;
end
plot3(gt_total(1,2),gt_total(1,3),gt_total(1,4),'g*', 'MarkerSize', 10);
hold off;
axis equal;
grid;
xlabel('X');ylabel('Y');zlabel('Z');
end

function plot_displacement(gt)
%% show displacement
gt_diff = diff(gt(:,2:4),5,1);
%[~,gt_diff] = gradient(gt(:,2:4));

for i=1:size(gt_diff,1)
    displacement(i,1) = norm(gt_diff(i,:));
end
figure;
plot(displacement);
xlabel('Frame');
ylabel('displacement [m]');
end