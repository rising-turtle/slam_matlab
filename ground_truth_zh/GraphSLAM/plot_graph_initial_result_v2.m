% Show plots of inital pose and optimized pose
%
% Author : Soonhac Hong (sxhong1@ualr.edu)
% History :
% 3/27/14 : Created
%

function [location_file_index, location_info_history] = plot_graph_initial_result_v2(gtsam_pose_initial, gtsam_pose_result, location_flag, location_file_index, location_info_history, lcd_found)

import gtsam.*

% data_name_list = {'ODOMETRY','LANDMARK','EDGE3','VERTEX_SE3'};
keys = KeyVector(gtsam_pose_initial.keys);

% isp_fd = fopen(file_name_pose, 'w');
initial_max_index = keys.size-1;
for i=0:initial_max_index
    key = keys.at(i);
    x = gtsam_pose_initial.at(key);
    T = x.matrix();
    [ry, rx, rz] = rot_to_euler(T(1:3,1:3));
    plot_xyz_initial(i+1,:)=[x.x x.y x.z];
end

keys = KeyVector(gtsam_pose_result.keys);

initial_max_index = keys.size-1;
for i=0:initial_max_index
    key = keys.at(i);
    x = gtsam_pose_result.at(key);
    T = x.matrix();
    [ry, rx, rz] = rot_to_euler(T(1:3,1:3));
    plot_xyz_result(i+1,:)=[x.x x.y x.z];
end

location_info=[];
if location_flag == true && lcd_found == true
    [location_info, location_file_index] = generate_location_info_v2([], plot_xyz_result, location_file_index);
end

figure(1);
subplot(1,2,2);

plot(plot_xyz_result(:,1),plot_xyz_result(:,2),'r-', 'LineWidth', 2);
hold on;
plot(plot_xyz_result(1,1),plot_xyz_result(1,2),'ko', 'LineWidth', 3,'MarkerSize', 3);
xlabel('X');ylabel('Y');

% for Amir's exp1
% xlim([-15 5]);  
% ylim([-5 15]);
% text_offset=[1,0];

% for motive #34
% xlim([-5 1]);  
% ylim([-2 5]);
% for swing #25
xlim([-4 2]);  
ylim([-3 7]);

text_offset=[0.4,0];

% Display location information
if ~isempty(location_info_history)
    for i=1:size(location_info_history,1)
        text_xy=[location_info_history{i,1}+text_offset(i,1),location_info_history{i,2}+text_offset(i,2)];
        text(text_xy(1), text_xy(2),location_info_history(i,3),'Color',[0 0 1]);
        plot(location_info_history{i,1}, location_info_history{i,2},'bd', 'LineWidth', 2, 'MarkerSize', 5);
    end
end
if ~isempty(location_info)
    text_xy=[plot_xyz_result(end,1)+text_offset(location_file_index-1,1), plot_xyz_result(end,2)+text_offset(location_file_index-1,2)];
    text(text_xy(1), text_xy(2),location_info,  'Color',[0 0 1]);
    location_info_history(location_file_index-1,:) ={plot_xyz_result(end,1),plot_xyz_result(end,2),location_info};
    plot(plot_xyz_result(end,1), plot_xyz_result(end,2),'bd', 'LineWidth', 2, 'MarkerSize', 5);
end
hold off;
grid;
legend('PGO');
axis equal;

drawnow;

end