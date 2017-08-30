% Show plots of inital pose and optimized pose
%
% Author : Soonhac Hong (sxhong1@ualr.edu)
% History :
% 3/27/14 : Created
%

function [location_file_index, location_info_history] = plot_graph_initial_result(gtsam_pose_initial, gtsam_pose_result, location_flag, location_file_index, location_info_history)

import gtsam.*

keys = KeyVector(gtsam_pose_initial.keys);

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
if location_flag == true
    [location_info, location_file_index] = generate_location_info([], plot_xyz_result, location_file_index);  % for finding rooms
end

figure(1);
subplot(1,2,2);

plot(plot_xyz_result(:,1),plot_xyz_result(:,2),'r-', 'LineWidth', 2);
hold on;
plot(plot_xyz_result(1,1),plot_xyz_result(1,2),'ko', 'LineWidth', 3,'MarkerSize', 3);
text(plot_xyz_result(1,1)-1.5,plot_xyz_result(1,2)-1.5,'Start','Color',[0 0 0]);
xlabel('X');ylabel('Y');
% Modify size of x in the graph
%xlim([-7 15]); % for etas523_exp2
%xlim([-15 5]);  % for Amir's exp1
xlim([-10 10]); % for etas523_exp2_lefthallway
ylim([-5 15]);

% Display location information
text_offset=[1,0; -6.5,0; -1,2; -1,-1.5; 0,-1.5]; % etas etas 523 exp2
%text_offset=[-6,0; 1,0; 1,0; 1,0; 0,2]; % etas etas 523 lefthallway
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