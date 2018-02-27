%
% Feb. 21, 2018, He Zhang, hxzhang1@ualr.edu
% 
% compare the trajectories of viorb, okvis, vins-mono
% the realsesne datasets
%

function compare_trajectory(fdir)

if nargin == 0
    fdir = './results/ETAS_2F_640_30'; 
    fdir = './results/ETAS_F4_640_30'; 
end

% load viorb trajectory 
f_viorb = strcat(fdir, '/viorb.log');
T_viorb = load(f_viorb); 

% load okvis trajecotry
f_okvis = strcat(fdir, '/okvis.log');
%f_okvis = strcat(fdir, '/run_7.log');
T_okvis = load(f_okvis); 

% load vins-mono trajectory 
f_vins = strcat(fdir, '/vins-mono.log');
T_vins = load(f_vins);

% load vins-mono_ext trajectory
f_ext = strcat(fdir, '/vins-mono_ext.log');
T_ext = load(f_ext); 

% transform viorb based on the coordinate of VINS-Mono_ext
T_viorb(:, 1:8) = transform_viorb(T_ext(1,1:8), T_viorb(:, 1:8));

plot_xyz(-T_viorb(:,3), -T_viorb(:, 2), T_viorb(:, 4), 'm-'); 
hold on;
plot_xyz(T_okvis(:,2), T_okvis(:, 3), T_okvis(:, 4), 'b:');
hold on; 
% grid on; 
plot_xyz(T_vins(:,2), T_vins(:, 3), T_vins(:, 4), 'r-.');
hold on; 
plot_xyz(T_ext(:,2), T_ext(:, 3), T_ext(:, 4), 'g-');
legend('VIORB', 'OKVIS', 'VINS-Mono', 'Proposed');
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








