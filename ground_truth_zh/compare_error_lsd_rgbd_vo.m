function compare_error_lsd_rgbd_vo()
%% 
% Author : David Zhang (hxzhang1@ualr.edu)
% Date : 08/08/16
% compute the RMSE of the relative displacement error given the result
% from VO of LSDSLAM and of RGBDSLAM 

 %% comparison between dense-track and sparse-track, use dataset_3
 gt_f = '.\motion_capture_data\test_10_16_2015\Take 2015-10-16 04.49.46 PM.dat_pose_wp';
 es_f = '.\motion_capture_data\test_10_16_2015\dataset_3\compare_lsd_vo\key_frame_trajectory.log'; % lsd-vo
 es_f2 = '.\motion_capture_data\test_10_16_2015\dataset_3\compare_lsd_vo\trajectory_estimate.txt';  % rgbd-vo
 es_f2 = '.\motion_capture_data\test_10_16_2015\dataset_3\data3_vro_estimate.txt';
 es_f = '.\motion_capture_data\test_10_16_2015\dataset_3\data3_plane_em_vro_4_estimate.txt';
 
 add_path_zh;

 %% compute RTE for rgbd's vo and lsd's vo respectively 
 E_lsd = computeRTE(gt_f, es_f); 
 E_rgbd = computeRTE(gt_f, es_f2); 
 
 %% draw them 
 st = 2; 
 et = min(size(E_rgbd,1), size(E_lsd,1));
 e_lsd = E_lsd(st:et,1); 
 plot(e_lsd, 'b-*'); 
 xlabel('Number of Keyframes #', 'FontSize', 20);
 ylabel('Relative Translational Error [m]', 'FontSize', 20); 
 hold on; 

 e_rgbd = E_rgbd(st:et,1); 
 plot(e_rgbd, 'r-*'); 
 
 set(gca, 'fontsize', 17);
 h = legend('VO LSD-SLAM', 'VO RGBD-SLAM');
 set(h, 'FontSize', 24);
 grid on;
 
end



function [E_ab, E_sq] = computeRTE(gt_f, es_f)

gt = load(gt_f); 
es = load(es_f); 
% es2 = load(es_f2);

%% synchroization with time 
[es_syn, gt_syn] = syn_time_with_gt(es, gt);

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

function [T] = combine(R, t)
    T = [R t; 0 0 0 1];
end


function [R, t] = decompose(T)
    R = T(1:3, 1:3); 
    t = T(1:3, 4);
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
