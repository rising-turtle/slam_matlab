function [rmse, E_sq, E_ab] = compute_error(gt_f, es_f, mode)
% 
% Author : David Zhang (hxzhang1@ualr.edu)
% Date : 11/06/15
% compute the RMSE of the relative displacement error, following 
% kuemmerl09auro's approach, RTE, and ATE,  
%
if nargin == 0
    
    %% dataset_1 
    % gt_f = '.\motion_capture_data\test_10_16_2015\Take 2015-10-16 04.25.55 PM.dat_pose_wp';
    % es_f = '.\motion_capture_data\test_10_16_2015\dataset_1\trajectory_vo_estimate.txt';
    % es_f = '.\motion_capture_data\test_10_16_2015\dataset_1\trajectory_vo_p_estimate.txt';
    % es_f = '.\motion_capture_data\test_10_16_2015\dataset_1\trajectory_vo_pem_estimate.txt';
    
    %% dataset_2
     % gt_f = '.\motion_capture_data\test_10_16_2015\Take 2015-10-16 04.46.44 PM.dat_pose_wp';
     % es_f = '.\motion_capture_data\test_10_16_2015\dataset_2\trajectory_vo_estimate.txt';
     % es_f = '.\motion_capture_data\test_10_16_2015\dataset_2\trajectory_vo_pem_estimate.txt';
     % es_f = '.\motion_capture_data\test_10_16_2015\dataset_2\trajectory_vo_p_estimate.txt';
    
    %% dataset_3 
    gt_f = '.\motion_capture_data\test_10_16_2015\Take 2015-10-16 04.49.46 PM.dat_pose_wp';
    % es_f = '.\motion_capture_data\test_10_16_2015\dataset_3\trajectory_vo_estimate.txt';
    % es_f = '.\motion_capture_data\test_10_16_2015\dataset_3\trajectory_vo_p_estimate.txt';
    %es_f = '.\motion_capture_data\test_10_16_2015\dataset_3\trajectory_vo_pem_estimate.txt';
    es_f = '.\motion_capture_data\test_10_16_2015\dataset_3\data3_vro_estimate.txt';
    es_f = '.\motion_capture_data\test_10_16_2015\dataset_3\data3_plane_em_vro_2_estimate.txt';
    
    %% comparison between dense-track and sparse-track, use dataset_3
    % gt_f = '.\motion_capture_data\test_10_16_2015\Take 2015-10-16 04.49.46 PM.dat_pose_wp';
    % es_f = '.\motion_capture_data\test_10_16_2015\dataset_3\compare_lsd_vo\key_frame_trajectory.log'; % lsd-vo
    % es_f = '.\motion_capture_data\test_10_16_2015\dataset_3\compare_lsd_vo\trajectory_estimate.txt';  % rgbd-vo
    
    mode = 'RTE'; % 'RTE'
end

if nargin == 2
    mode = 'ATE'; % 'RTE'
end

add_path_zh;

gt = load(gt_f); 
es = load(es_f); 
% es2 = load(es_f2);

%% synchroization with time 
[es_syn, gt_syn] = syn_time_with_gt(es, gt);

%% statistically collect error information 
% compute the relative transformation between any two VO pairs, and then 
% collect translation error and rotational error 
% [es_syn2, gt_syn2] = syn_time_with_gt(es2, gt);
% 
 st = 120;
et = st + 30;
plot_xyz(es_syn(st:et, 2), es_syn(st:et, 3), es_syn(st:et, 4), 'b*-');
hold on; 
plot_xyz(gt_syn(st:et, 2), gt_syn(st:et, 3), gt_syn(st:et, 4), 'k*-');
% hold on;
% plot_xyz(es_syn2(st:et, 2), es_syn2(st:et, 3), es_syn2(st:et, 4), '-r');
% hold on; 
% plot_xyz(gt_syn2(st:et, 2), gt_syn2(st:et, 3), gt_syn2(st:et, 4), '-c');

% es_syn = es_syn2(st:et, :); 
% gt_syn = gt_syn(st:et, :);

if strcmp(mode,'RTE')
    [E_ab, E_sq] = computeRTE(es_syn, gt_syn);
else
    [E_ab, E_sq] = computeATE(es_syn, gt_syn);
end

E = E_ab; 
plot_error(E); 
me = mean(E);
stde = std(E);
maxe = max(E);
fprintf('\n');
fprintf('E_abs mean: %f %f, std: %f %f \n', me(1), me(2), stde(1), stde(2));
fprintf('E_abs max: %f %f \n', maxe(1), maxe(2));

E = E_sq;
N = size(E,1);
rmse = sqrt(sum(E)./N);
me = mean(E);
stde = std(E);
fprintf('E_sqr mean: %f %f, std: %f %f  rmse %f %f \n', me(1), me(2), stde(1), ...
    stde(2), rmse(1), rmse(2));

end

function [E_ab, E_sq] = computeATE(es_syn, gt_syn)
    E_sq = zeros(size(es_syn,1), 2); 
    E_ab = zeros(size(es_syn,1), 2);
    
    for i=2:size(es_syn,1)
        
        pe_2 = es_syn(i, 2:end); 
        pe_2_seq = pe_2(4:7); pe_2_seq(2:4) = pe_2(4:6); pe_2_seq(1) = pe_2(7);
        pg_2 = gt_syn(i, 2:end);
        
        Re_2 = quat2rmat(pe_2_seq'); 
        te_2 = pe_2(1:3)';
        Rg_2 = quat2rmat(pg_2(4:7)');
        tg_2 = pg_2(1:3)'; 
        
        Te_2 = combine(Re_2, te_2); 
        Tg_2 = combine(Rg_2, tg_2);
        
        deltaT = Te_2\Tg_2; 
        [R, t] = decompose(deltaT); 
        e = R2e(R);
        e = e.*180./pi;
        t_sq = t'*t;
        r_sq = e'*e; 
        
        E_sq(i,1) = t_sq; E_sq(i, 2) = r_sq; 
        E_ab(i,1) = sqrt(t_sq); E_ab(i,2) = sqrt(r_sq);
    end
    
end

function [E_ab, E_sq] = computeRTE(es_syn, gt_syn)

E_sq = zeros(size(es_syn,1), 2); 
E_ab = zeros(size(es_syn,1), 2);

Te_1 = eye(4); 
Tg_1 = eye(4); 
j = 1;
for i=2:1:size(es_syn,1)
    pe_2 = es_syn(i, 2:end); 
    pe_2_seq = pe_2(4:7); pe_2_seq(2:4) = pe_2(4:6); pe_2_seq(1) = pe_2(7);
    pg_2 = gt_syn(i, 2:end);
    
    Re_2 = quat2rmat(pe_2_seq'); 
    te_2 = pe_2(1:3)';
   % pg_2(5:6) = pg_2(5:6)*-1; % why gt's qx qy is has different signs with vo's qx qy
    Rg_2 = quat2rmat(pg_2(4:7)');
    tg_2 = pg_2(1:3)'; 
    
    Te_2 = combine(Re_2, te_2); 
    Tg_2 = combine(Rg_2, tg_2);
    [t_sq, r_sq] = compute_squared_error(Te_1, Te_2, Tg_1, Tg_2); 
    
    E_sq(j,1) = t_sq; E_sq(j, 2) = r_sq; 
    E_ab(j,1) = sqrt(t_sq); E_ab(j,2) = sqrt(r_sq);
    
    j = j+1;
    Te_1 = Te_2; 
    Tg_1 = Tg_2;
end
E_sq(j:end,:) = [];
E_ab(j:end,:) = [];
end

function plot_error(E)

       et = E(:,1); 
       er = E(:,2); 
       plot(et, 'r-*'); 
       xlabel('relation #');
       ylabel('translational error [m]'); 
%        figure; 
%        plot(er, 'r+');
%        xlabel('relation #');
%        ylabel('angular error [deg]');
end

function [t_sq, r_sq] = compute_squared_error(Te_1, Te_2, Tg_1, Tg_2)
    dTe12 = Te_1\Te_2;  % inv(Te_1)*Te_2; 
    dTg12 = Tg_1\Tg_2;  %inv(Tg_1)*Tg_2;
    deltaT = dTe12\dTg12; % inv(dTe12)*dTg12; 
    [R, t] = decompose(deltaT); 
    e = R2e(R);
    e = e.*180./pi;
    t_sq = t'*t;
    r_sq = e'*e; 
end



function plot_xyz(x, y, z, c)
    plot3(x, y, z, c, 'LineWidth', 2);
    hold on;
    hold off;
    axis equal;
    grid;
    xlabel('X (m)');ylabel('Y (m)');zlabel('Z (m)');
end 

function [T] = combine(R, t)
    T = [R t; 0 0 0 1];
end

function [R, t] = decompose(T)
    R = T(1:3, 1:3); 
    t = T(1:3, 4);
end
