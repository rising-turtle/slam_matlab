%
% Feb. 24, 2018, He Zhang, hxzhang1@ualr.edu
% 
% compare the trajectories of viorb, okvis, vins-mono
% the realsesne datasets
%

function compare_trajectory_with_gt(fdir)

if nargin == 0
    fdir = './results/GT'; 
end

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
f_gt = strcat(fdir, '/ground_truth.log');
T_gt = load(f_gt);

s = 1;
e = 1000;
% plot_xyz(-T_viorb(:,3), -T_viorb(:, 2), T_viorb(:, 4), 'm-'); 
% plot_xyz(T_viorb(:,2), -T_viorb(:, 3), T_viorb(:, 4), 'm-');
% hold on;
plot_xyz(T_okvis(s:e,2), T_okvis(s:e, 3), T_okvis(s:e, 4), 'b:');
hold on; 
plot_xyz(T_gt(s:2*e,2), -T_gt(s:2*e,4),T_gt(s:2*e,3), 'k-');
grid on;
hold on;
 plot_xyz(T_vins(s:e,2), T_vins(s:e, 3), T_vins(s:e, 4), 'r-.');
 hold on; 
 plot_xyz(T_ext(s:e,2), T_ext(s:e, 3), T_ext(s:e, 4), 'g-');
% legend('VIORB', 'OKVIS', 'VINS-Mono', 'Proposed');
legend('OKVIS', 'GT','VINS-Mono', 'Proposed');
% title('Trajectory Comparison');
end

%% viorb's coordinate is different from vins-mono and okvis 
function pose = transform_viorb( pose_base, pose)
   Too = construct(pose(1, 2:8));
   Too_inv = inv(Too); 
   Tg2s = construct(pose_base(2:8)); 
   Ts2c = [1 0 0 0; 
           0 0 1 0;
           0 -1 0 0;
           0 0 0 1];
   
   for i=1:size(pose,1)
       Tii = construct(pose(i, 2:8));
       Tc2i = Too_inv * Tii; 
       Tg2i = Tg2s * Ts2c * Tc2i; 
       [q, t] = deconstruct(Tg2i); 
       % Tb2i = Tb2o * To2i;
       % [q, t] = deconstruct(Tb2i);
       pose(i, 2:4) = t(:);
       pose(i, 5:8) = q(:);
   end
end








