% Show plots of inital pose and optimized pose
%
% Author : Soonhac Hong (sxhong1@ualr.edu)
% History :
% 3/27/14 : Created
%

function plot_graph_initial_result_v0(gtsam_pose_initial, gtsam_pose_result)

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

figure(1);
subplot(1,2,2);

plot(plot_xyz_initial(:,1),plot_xyz_initial(:,2),'g-', 'LineWidth', 2);
hold on;
plot(plot_xyz_result(:,1),plot_xyz_result(:,2),'r-', 'LineWidth', 2);
plot(plot_xyz_initial(1,1),plot_xyz_initial(1,2),'go', 'LineWidth', 3,'MarkerSize', 3);
xlabel('X');ylabel('Y');
hold off;
grid;
legend('DR','PGO');
axis equal;

drawnow;

end