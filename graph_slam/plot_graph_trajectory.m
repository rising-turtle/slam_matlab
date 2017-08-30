function plot_graph_trajectory(gtsam_pose_initial, gtsam_pose_result)
%
% David Z, 3/6/2015 
% draw the trajectory in the graph structure
%
import gtsam.*
plot_xyz_initial = [];
%% plot the initial pose trajectory : VRO result
keys = KeyVector(gtsam_pose_initial.keys);
initial_max_index = keys.size-1;
for i=0:int32(initial_max_index)
    key = keys.at(i);
    x = gtsam_pose_initial.at(key);
    % T = x.matrix();
    % [ry, rx, rz] = rot_to_euler(T(1:3,1:3));
    plot_xyz_initial(i+1,:)=[x.x x.y x.z];
end

plot_xyz_result = [];
%% plot the result pose trajectory : GO graph optimization result
if exist('gtsam_pose_result', 'var')
    keys = KeyVector(gtsam_pose_result.keys);
    initial_max_index = keys.size-1;
    for i=0:int32(initial_max_index)
        key = keys.at(i);
        x = gtsam_pose_result.at(key);
        % T = x.matrix();
        % [ry, rx, rz] = rot_to_euler(T(1:3,1:3));
        plot_xyz_result(i+1,:)=[x.x x.y x.z];
    end    
end

%% plot them
figure(1);
subplot(1,2,2);
plot(plot_xyz_initial(:,1),plot_xyz_initial(:,2),'b-', 'LineWidth', 2);
legend('VRO');
hold on;
plot_start_point(plot_xyz_initial);
if exist('gtsam_pose_result', 'var')
    plot(plot_xyz_result(:,1),plot_xyz_result(:,2),'r-', 'LineWidth', 2);
    legend('PGO');
end
xlabel('X');ylabel('Y');

% Modify size of x in the graph
% xlim([-7 15]); % for etas523_exp2
% xlim([-15 5]);  % for Amir's exp1
% xlim([-10 10]); % for etas523_exp2_lefthallway
% ylim([-5 15]);
global g_dis_x_min g_dis_x_max g_dis_y_min g_dis_y_max
xlim([g_dis_x_min g_dis_x_max]); % for etas523_exp2_lefthallway
ylim([g_dis_y_min g_dis_y_max]);
hold off;
grid;
axis equal;

end


function plot_start_point(plot_xyz_result)
 plot(plot_xyz_result(1,1),plot_xyz_result(1,2),'ko', 'LineWidth', 3,'MarkerSize', 3);
 text(plot_xyz_result(1,1)-1.5,plot_xyz_result(1,2)-1.5,'Start','Color',[0 0 0]);
end
