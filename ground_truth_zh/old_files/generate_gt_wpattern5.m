% Generate ground truth from motion capture data of MOTIVE
% Assumption : Motion caputre data of MOTIVE(file format : *.csv) has only double marker on SR4K
%
% Author : Soonhac Hong (sxhong1@ualr.edu)
% Date : 10/2/13
% Coordinate : PGO

function generate_gt_wpattern5()
clear all
%addpath('..\GraphSLAM');
%addpath('..\Localization');
%addpath('..\slamtoolbox\slamToolbox_11_09_08\FrameTransforms\Rotations');

path_dir = 'D:\co_worker\ground_truth';
addpath(strcat(path_dir, '\GraphSLAM'));
addpath(strcat(path_dir, '\Localization'));
addpath(strcat(path_dir, '\slamtoolbox\slamToolbox_11_09_08\FrameTransforms\Rotations'));

%% Load motion capture data
%data_file_name = 'C:\Yiming\data_experiments\RS4000_motive_10June_2015\Motive_capture_data\Take 2015-06-10 04.45.44 PM.csv'; % 19
%data_file_name = 'C:\Yiming\data_experiments\RS4000_motive_12June_2015\Motive_capture_data\Take 2015-06-13 10.31.15 AM.csv'; % 19
%data_file_name = 'C:\Yiming\data_experiments\RS4000_motive_10June_2015\Motive_capture_data\Take 2015-06-10 04.45.44 PM.csv'; % 19
%data_file_name = 'C:\Users\ymzhao\Desktop\ground_truth_data\motioncapture\Session 2014-02-13\m5_2 Take 2014-02-13 02.32.29 PM.csv'; % 19
%data_file_name = 'C:\Users\ymzhao\Desktop\ground_truth_data\motioncapture\Take 2015-06-14 01.22.29 PM.csv'; % 19
%data_file_name = 'C:\Users\ymzhao\Desktop\ground_truth_data\motioncapture\Take 2015-06-15 12.08.12 AM.csv'; % 19
%data_file_name = 'C:\Yiming\data_experiments\RS4000_motive_15June_2015\IEKF_data_15June2015\Take 2015-06-15 12.04.48 AM.csv'; % $@06/15/2015,data 2$
%data_file_name = 'C:\Yiming\data_experiments\RS4000_motive_18June_2015\EKF_data_18June2015\Take 2015-06-18 05.46.35 PM.csv';% diff_threshold = 0.00002 % $@06/18/2015,data 1$
%data_file_name = 'C:\Yiming\data_experiments\RS4000_motive_23June_2015\EKF_data_23June2015\Take 2015-06-25 11.16.27 AM.csv';% $@06/18/2015,data 2$
%data_file_name = 'C:\Yiming\data_experiments\RS4000_motive_26July_2015\IEKF_data_26July2015\Take 2015-07-26 11.22.31 AM.csv'; % diff_threshold = 0.00002 $@07/26/2015,data 1$
%data_file_name = 'C:\Yiming\data_experiments\RS4000_motive_26July_2015\IEKF_data_26July2015\Take 2015-07-26 11.39.04 AM.csv'; % diff_threshold = 0.00002 $@07/26/2015,data 2$
%data_file_name = 'C:\Yiming\data_experiments\RS4000_motive_28July_2015\IEKF_data_28July2015\Take 2015-07-29 02.09.11 PM.csv'; % data 4, diff_threshold = 0.00002 $@07/28/2015,data 2$
%data_file_name = 'C:\Yiming\data_experiments\RS4000_motive_30July_2015\IEKF_data_30July2015\Take 2015-07-30 05.37.59 PM.csv'; % data 1 diff_threshold = 0.00002 $@07/30/2015,data 2$
%data_file_name = 'C:\Yiming\data_experiments\RS4000_motive_30July_2015\IEKF_data_30July2015\Take 2015-07-30 05.42.15 PM.csv'; % data 2 diff_threshold = 0.00002 $@07/30/2015,data 2$

%data_file_name = 'C:\Yiming\data_experiments\RS4000_motive_03August_2015\IEKF_data_03August2015\Take 2015-08-03 11.32.37 AM.csv'; % data 1, diff_threshold = 0.000025 $@08/03/2015,data 2$
%data_file_name = 'C:\Yiming\data_experiments\RS4000_motive_03August_2015\IEKF_data_03August2015\Take 2015-08-03 11.36.33 AM.csv'; % data 2, diff_threshold = 0.000025 $@08/03/2015,data 2$
%data_file_name = 'C:\Yiming\data_experiments\RS4000_motive_03August_2015\IEKF_data_03August2015\Take 2015-08-03 11.39.47 AM.csv'; % data 3, diff_threshold = 0.000025 $@08/03/2015,data 2$
%data_file_name = 'D:\co_worker\ground_truth\motion_capture_data\test_10_16_2015\Take 2015-08-03 11.39.47 AM.csv'; %  Take 2015-10-16 04.25.55 PM.csv
data_file_name = 'D:\co_worker\ground_truth\motion_capture_data\test_10_16_2015\Take 2015-10-16 04.49.46 PM.csv';
%data_file_name = 'C:\Yiming\data_experiments\RS4000_motive_03August_2015\IEKF_data_03August2015\Take 2015-08-03 11.43.13 AM.csv'; % data 4, diff_threshold = 0.00002 $@08/03/2015,data 2$
%data_file_name = 'C:\Yiming\data_experiments\RS4000_motive_03August_2015\IEKF_data_03August2015\Take 2015-08-03 11.46.06 AM.csv'; % data 5, diff_threshold = 0.00002 $@08/03/2015,data 2$
%data_file_name = 'C:\Yiming\data_experiments\RS4000_motive_03August_2015\IEKF_data_03August2015\Take 2015-08-03 11.48.59 AM.csv'; % data 6, diff_threshold = 0.00004 $@08/03/2015,data 2$

% set up the parameters
find_start_end_point=true;
min_marker = 2;
find_pair_method_index = 2;
find_pair_method_list={'NN','TP','ICP'};
find_pair_method = find_pair_method_list{find_pair_method_index};
% open the data file
fid = fopen(data_file_name);
if fid < 0
    error(['Cannot open file ' data_file_name]);
end
%% scan all lines into a cell array
columns=textscan(fid,'%s','delimiter','\n');
fclose(fid);
lines=columns{1};
N=size(lines,1);
frame_number = N-45; % frame_number is the frame number of dataset; (45 is the number of lines of data file header)
gt=[];
gt_total=[];
% figure;
start_frame_index = 0; %500; %2000; %2300; %1737;
finish_frame_index = intmax; %intmax; % ; %2600; %4000; %6300; %4146;

for i=1:N
    line_i=lines{i};
    line_data = textscan(line_i,'%s %d %f %f %f %f %f %f %d %s %f %f %f %d %s %f %f %f %d %s %f %f %f %d %s %f %f %f %d %s','delimiter',',');
    if strcmp(line_data{1}, 'frame')
        if  ~isempty(line_data{6})       
            if line_data{2} > start_frame_index && line_data{2} <= finish_frame_index 
                time_stamp = line_data{3};
                marker=[];
                if line_data{5} >= 5  % original
                %if line_data{5} >= 3  % modified @06/14/2015 
                    for m=1:line_data{5}
                        marker=[marker; [line_data{(m-1)*5+6},line_data{(m-1)*5+7},line_data{(m-1)*5+8}]];
                    end
                    %x= mean([line_data{6}, line_data{11}, line_data{16}]);
                    %y= mean([line_data{7}, line_data{12}, line_data{17}]);
                    %z= mean([line_data{8}, line_data{13}, line_data{18}]);
                    if check_marker_pattern(marker)
                    %if check_marker_pattern_plane_fitting(marker)
                        pos =  mean(marker,1); %[x,y,z]; % [x,y,z]
                        gt= [gt; time_stamp, pos];
                        gt_total = [gt_total; time_stamp, reshape(marker', 1, 15)];%original
                        %gt_total = [gt_total; time_stamp, reshape(marker', 1, 9)];%original
                    end
                    
%                 elseif line_data{5} == 2
%                     marker=[marker; [line_data{6},line_data{7},line_data{8}]];
%                     marker=[marker; [line_data{11},line_data{12},line_data{13}]];
%                     if check_marker_pattern(marker)
%                         %x= mean([line_data{6}, line_data{11}]);
%                         %y= mean([line_data{7}, line_data{12}]);
%                         %z= mean([line_data{8}, line_data{13}]);
%                         pos = mean(marker,1); %[x,y,z]; % [x,y,z]
%                         gt = [gt; time_stamp, pos];
%                     end
                end
%                 else
%                     pos = [line_data{6}, line_data{7}, line_data{8}];
%                 end
%                 gt = [gt; time_stamp, pos];
            end
            % animation
%             plot3(pos(1),pos(2),pos(3),'*-');axis equal; grid;
%             hold on;
%             drawnow;
        end
        
        %line_data = str2num(line_data{1});
        %line_data = textscan(line_i,'%f %f %f',1);
    end
end
% hold off;

%% Find start point and finish point
if find_start_end_point
    % diff_threshold = 0.000035; %0.00002 %0.000012,$@07/30/2015,data 1$; %0.00002, $@07/28/2015,data 4$; % 0.000035,$@06/18/2015,data 1$;  %0.001;0.0001,0.00005, 0.00002% this value should be assigned according to the data number
    diff_threshold = 0.00042; % 0.00032;
    gt_diff = diff(gt(:,2:4),1,1);
    gt_diff_abs = abs(gt_diff);
    gt_length=size(gt_diff,1);
    gt_middle_index = round(gt_length/2);
    
    gt_diff_index = find((gt_diff_abs(1:gt_middle_index,1) <= diff_threshold) & (gt_diff_abs(1:gt_middle_index,2) <= diff_threshold) & (gt_diff_abs(1:gt_middle_index,3) <= diff_threshold));
    start_index = gt_diff_index(end);
    
    gt_diff_index = find((gt_diff_abs(gt_middle_index:end,1) <= diff_threshold) & (gt_diff_abs(gt_middle_index:end,2) <= diff_threshold) & (gt_diff_abs(gt_middle_index:end,3) <= diff_threshold));
    finish_index = gt_diff_index(1)+gt_middle_index-1;
    
    figure;plot(gt_diff);
    line([start_index,start_index],[0,max(max(gt_diff))],'Color','m','LineWidth',2);
    line([start_index,start_index],[0,min(min(gt_diff))],'Color','m','LineWidth',2);
    
    line([finish_index,finish_index],[0,max(max(gt_diff))],'Color','c','LineWidth',2);
    line([finish_index,finish_index],[0,min(min(gt_diff))],'Color','c','LineWidth',2);
    
    % Delete reduntant data
    gt = gt(start_index:finish_index,:);
    gt_total = gt_total(start_index:finish_index,:);
end
 
 % Convert motive poses to world coordinate; added by Yimin Zhao $06/17/2015$
 % X => -X, Y => Z, Z=>Y
 %-------------------------------------------------------------------------
 gt(:,2:4) = gt(:,2:4).*repmat([-1 1 1],size(gt,1),1); % modified by Yimin Zhao $06/17/2015$
 gt_temp = gt; % modified by Yimin Zhao $06/17/2015$
 gt(:,3) = gt_temp(:,4); % modified by Yimin Zhao $06/17/2015$ 
 gt(:,4) = gt_temp(:,3); % modified by Yimin Zhao $06/17/2015$ 
 gt_total(:,2:end) =  gt_total(:,2:end).*repmat([-1 1 1],size(gt,1),5); % modified by Yimin Zhao $06/17/2015$
 gt_total_temp=gt_total; % modified by Yimin Zhao $06/17/2015$
 for k=1:5
     gt_total(:,3+3*(k-1)) = gt_total_temp(:,4+3*(k-1));
     gt_total(:,4+3*(k-1)) = gt_total_temp(:,3+3*(k-1));
 end
%--------------------------------------------------------------------------
% Set first frame is origin.
gt(:,2:4) = gt(:,2:4) - repmat(gt(1,2:4), size(gt,1), 1);
%gt_total(:,2:end) = gt_total(:,2:end) - repmat(gt_total(1,2:end), size(gt_total,1), 1);

if strcmp(find_pair_method, 'NN')
    % Find pairs by nearest neighbor
    gt_total_pair=gt_total(1,:);
    for i=2:size(gt_total,1)
        gt_total_pair(i,1) = gt_total(i,1);
        min_idx_prev=[];
        for j=1:5
            cur = gt_total(i,2+(j-1)*3:4+(j-1)*3);
            diff_dist=[];
            for k=1:5
                pre = gt_total_pair(i-1,2+(k-1)*3:4+(k-1)*3);
                diff_dist = [diff_dist; norm(pre - cur)];
            end
            diff_dist(min_idx_prev)=intmax;
            [~, min_idx] = min(diff_dist);
            min_idx_prev = [min_idx_prev; min_idx];
            gt_total_pair(i,2+(min_idx-1)*3:4+(min_idx-1)*3)=cur;
        end
    end
elseif strcmp(find_pair_method, 'TP')
    [ gt_total_pair ] = find_pair_tp( gt_total );
    [ gt_total_pair(:,11:16)] = find_pair_nn( gt_total_pair(:,11:16));
elseif strcmp(find_pair_method, 'ICP')
    % Find pair by ICP
    [ gt_total_pair ] = find_pair_icp( gt_total );
else
    disp('Find_pair_method is not defined!');
    return;
end

% Delete invalide data
% gt_total_pair(invalid_data_index,:)=[];
% Set the origin of motion capture system at the center of five LEDs in initial positon 
%% added by Yimin Zhao on @13/07/2015
marker=[];
for m=1:5
    marker=[marker; [gt_total_pair(1,(m-1)*3+2),gt_total_pair(1,(m-1)*3+3),gt_total_pair(1,(m-1)*3+4)]];
end
% set the origin of motion capture system to the center of five LEDs in initial position
origin =  mean(marker,1);
gt_total_pair(1,2:4)
gt_total_pair(:,2:end) = gt_total_pair(:,2:end) - repmat(origin, size(gt_total_pair,1), 5); % some concern
%% original of Soonhac
%gt_total_pair(:,2:end) = gt_total_pair(:,2:end) - repmat(gt_total_pair(1,2:4), size(gt_total_pair,1), 5);
%% generate pose
gt_pose=[gt_total_pair(1,1), 0,0,0,1,0,0,0];
gt_pose_euler=[gt_total_pair(1,1), 0,0,0,0,0,0];
distance_total=[];
gt_total_pair;
for i=1:size(gt_total_pair,1)-1
    op_pset1 = [];
    op_pset2 = []; 
    for k=1:5
        op_pset1 = [op_pset1; gt_total_pair(1,2+(k-1)*3:4+(k-1)*3)];
        op_pset2 = [op_pset2; gt_total_pair(i+1,2+(k-1)*3:4+(k-1)*3)];
    end
    [rot, trans, sta] = find_transform_matrix(op_pset2', op_pset1');  

    if sta > 0
%
        q = R2q(rot);
        gt_pose=[gt_pose; gt_total_pair(i+1,1), trans' q'];
%        
        e = R2e(rot);
        gt_pose_euler=[gt_pose_euler; gt_total_pair(i+1,1), trans' e'];
 
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
    else
        sta;
    end

end

save('ground_pose.mat', 'gt_pose', 'frame_number'); % added by Yimin Zhao on $@06/16/2015$
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

%% show rmse of transformation
% figure;
% plot(rmse);
% grid;
% xlabel('Frame');
% ylabel('RMSE of Transformation');

%% show gt_pose
figure;
plot3(gt_pose_euler(:,2),gt_pose_euler(:,3),gt_pose_euler(:,4),'.-');
hold on;
plot3(gt_pose_euler(1,2),gt_pose_euler(1,3),gt_pose_euler(1,4),'g*', 'MarkerSize', 10);
hold off;
axis equal; 
grid;
xlabel('X');ylabel('Y');zlabel('Z');
title('Translaton');

%% Convert Quaternion to Euler angles [roll;pitch;yaw]
% for i=1:size(gt_pose,1)
%     gt_pose_euler(i,:) = q2e(gt_pose(i,5:8))'*180/pi();
% end

figure;
title_list ={'Rx','Ry','Rz'};
for i=1:3
    %plot(gt_pose(:,i+4),plot_colors{i});
    %subplot(3,1,i);plot(gt_pose_euler(:,i),plot_colors{i});
    subplot(3,1,i);plot(gt_pose_euler(:,i+4)*180/pi(),plot_colors{i});
    title(title_list{i});grid;
    %hold on;
end
%plot3(gt_pose(1,2),gt_pose(1,3),gt_pose(1,4),'g*', 'MarkerSize', 10);
%hold off;
%axis equal; 
%grid;
xlabel('frame');
%ylabel('Orientation [quaternion]');
ylabel('Orientation [degree]');
%legend('Rx','Ry','Rz');


%% show ground truth
figure;
plot3(gt(:,2),gt(:,3),gt(:,4),'.-');
hold on;
plot3(gt(1,2),gt(1,3),gt(1,4),'g*', 'MarkerSize', 10);
hold off;
axis equal; 
grid;
xlabel('X');ylabel('Y');zlabel('Z');

%%[vro_poses_trajectory_error, vro_poses_trajectory_length,
%%vro_poses_first_last_distance] = compute_trajectory_error(gt(:,2:4)) %
%%removed by Yimin Zhao $@02/26/2015$

%% show ground truth by pairs
figure;
%plot_colors={'b.-','r.-','g.-','m.-','c.-'};
for i=1:5
    plot3(gt_total_pair(:,2+3*(i-1)),gt_total_pair(:,3+3*(i-1)),gt_total_pair(:,4+3*(i-1)),plot_colors{i});
    hold on;
end
plot3(gt_total_pair(1,2),gt_total_pair(1,3),gt_total_pair(1,4),'g*', 'MarkerSize', 10);
hold off;
axis equal; 
grid;
xlabel('X');ylabel('Y');zlabel('Z');
title('GT pairs');

%% show ground truth
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

%% Save video
% vidObj = VideoWriter(strrep(data_file_name, 'csv','avi'));
% open(vidObj);
% 
% figure;
% for i=1:size(gt,1)
%     plot3(gt(i,2),gt(i,3),gt(i,4),'.-');axis equal; grid;
%     xlabel('X');ylabel('Y');zlabel('Z');
%     hold on;
%     
%     if i ~= size(gt,1)
%         pause(abs(gt(i,1)-gt(i+1,1)));
%     end
%     
%     currFrame = getframe;
%     writeVideo(vidObj,currFrame);
%     
%     drawnow;
% end
% close(vidObj);

%% Save data
if find_start_end_point
    out_file_name=strrep(data_file_name, 'csv','dat_wp');
    total_out_file_name=strrep(data_file_name, 'csv','dat_total_wp');
    gt_pose_out_file_name=strrep(data_file_name, 'csv','dat_pose_wp');
else
    out_file_name=strrep(data_file_name, 'csv','dat_full_wp');
    total_out_file_name=strrep(data_file_name, 'csv','dat_total_full_wp');
    gt_pose_out_file_name=strrep(data_file_name, 'csv','dat_pose_full_wp');
end
dlmwrite(out_file_name,gt,' '); % [time_stamp x y z]
dlmwrite(total_out_file_name,gt_total_pair,' '); % [time_stamp [x y z]*5]
dlmwrite(gt_pose_out_file_name,gt_pose,' '); % [time_stamp [x y z q1 q2 q3 q4]

end

