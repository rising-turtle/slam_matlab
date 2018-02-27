%%%
% transform coordinates from world to IMU
% Now this file has been extended to show the trajectory comparison of the
% R200_GT_DENSE_SLOW dataset 
% Feb. 26 2018, He Zhang, hxzhang1@ualr.edu

function traj_in_IMU(fdir)

if nargin == 0
    fdir = './results/GT'; 
end

addpath('../ground_truth_zh');

% load viorb trajectory 
% f_viorb = strcat(fdir, '/viorb.log');
% T_viorb = load(f_viorb); 

% load okvis trajecotry
 f_okvis = strcat(fdir, '/okvis.log');
 T_okvis = load(f_okvis); 

% load vins-mono trajectory 
 f_vins = strcat(fdir, '/vins-mono.log');
 T_vins = load(f_vins);

% load vins-mono_ext trajectory
 f_ext = strcat(fdir, '/vins-mono_ext.log');
 T_ext = load(f_ext); 

% transform viorb based on the coordinate of VINS-Mono_ext
% T_viorb(:, 1:8) = transform_viorb(T_ext(1,1:8), T_viorb(:, 1:8));

% load ground truth 
f_gt = strcat(fdir, '/ground_truth_g.log');
T_gt = load(f_gt);

s = 1;
e = 200;

%% transform into the coordinate of the first pose
T_okvis = transform_to_first(T_okvis);
T_vins = transform_to_first(T_vins);
T_ext = transform_to_first(T_ext);

%% transform to synchronized pose got from test_gt,
% and then align with gt's trajectory
T_vins = align_transform(T_vins, T_gt);
T_ext = align_transform(T_ext, T_gt);
T_okvis = align_transform(T_okvis, T_gt);
% T_okvis = transform_to_synchronized(T_okvis, T_gt, 237);

% plot_xyz(-T_viorb(:,3), -T_viorb(:, 2), T_viorb(:, 4), 'm-'); 
% plot_xyz(T_viorb(:,2), -T_viorb(:, 3), T_viorb(:, 4), 'm-');
% hold on;
 plot_xyz(T_okvis(:,2), T_okvis(:, 4), T_okvis(:, 3), 'b:');
 hold on; 

% plot_xyz( T_gt(:,4), -T_gt(:,2),T_gt(:,3), 'k-');

plot_xyz(T_vins(:,2), T_vins(:, 4), T_vins(:, 3), 'r--.');
hold on;
plot_xyz(T_ext(:,2), T_ext(:, 4), T_ext(:, 3), 'g-.');
hold on;
plot_xyz( T_gt(:,2), T_gt(:,4), T_gt(:,3), 'k-');
grid on;
% legend('VIORB', 'OKVIS', 'VINS-Mono', 'Proposed');
legend('OKVIS', 'VINS-Mono', 'Proposed', 'GT');


end


