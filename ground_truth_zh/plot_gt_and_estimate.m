% Author : David Zhang (hxzhang1@ualr.edu)
% Date : 10/23/15
% plot the estimated trajectory and the ground truth

function plot_gt_and_estimate(gt_f, es_f)

if nargin == 0
    
    %% dataset_1 
    %  gt_f = '.\motion_capture_data\test_10_16_2015\Take 2015-10-16 04.25.55 PM.dat_pose_wp';
    % es_f = '.\motion_capture_data\test_10_16_2015\dataset_1\trajectory_vo_estimate.txt';
    % es_f2 = '.\motion_capture_data\test_10_16_2015\dataset_1\trajectory_vo_p_estimate.txt';
    % es_f2 = '.\motion_capture_data\test_10_16_2015\dataset_1\trajectory_vo_pem_estimate.txt';
    
    %% dataset_2
     % gt_f = '.\motion_capture_data\test_10_16_2015\Take 2015-10-16 04.46.44 PM.dat_pose_wp';
     % es_f = '.\motion_capture_data\test_10_16_2015\dataset_2\trajectory_vo_estimate.txt';
     % es_f2 = '.\motion_capture_data\test_10_16_2015\dataset_2\trajectory_vo_p_estimate.txt';
     % es_f2 = '.\motion_capture_data\test_10_16_2015\dataset_2\trajectory_vo_pem_estimate.txt';
    
    %% dataset_3     
     % es_f = '.\motion_capture_data\test_10_16_2015\trajectory_estimate_04.49.46.txt';
     % gt_f = '.\motion_capture_data\test_10_16_2015\Take 2015-10-16 04.49.46 PM.dat_pose_wp';
     % es_f = '.\motion_capture_data\test_10_16_2015\dataset_3\trajectory_vo_estimate.txt';
     % es_f2 = '.\motion_capture_data\test_10_16_2015\dataset_3\trajectory_vo_p_estimate.txt';
     % es_f2 = '.\motion_capture_data\test_10_16_2015\dataset_3\trajectory_vo_pem_estimate.txt';
     
    %% dataset_4 
    % gt_f = '.\motion_capture_data\test_10_16_2015\Take 2015-10-16 04.51.46 PM.dat_pose_wp';
    % es_f = '.\motion_capture_data\test_10_16_2015\dataset_4\trajectory_vo_estimate.txt';
    % es_f2 = '.\motion_capture_data\test_10_16_2015\dataset_4\trajectory_vo_p_estimate.txt';
    
    %% comparison between dense-track and sparse-track, use dataset_3
     gt_f = '.\motion_capture_data\test_10_16_2015\Take 2015-10-16 04.49.46 PM.dat_pose_wp'; % ground truth
     es_f2 ='.\motion_capture_data\test_10_16_2015\dataset_3\compare_lsd_vo\key_frame_trajectory.log'; % lsd-slam
     es_f = '.\motion_capture_data\test_10_16_2015\dataset_3\compare_lsd_vo\trajectory_estimate.txt'; % rgbd-slam
     
     es_f = '.\motion_capture_data\test_10_16_2015\dataset_3\data3_vro_estimate.txt';
     es_f2 = '.\motion_capture_data\test_10_16_2015\dataset_3\data3_plane_em_vro_estimate.txt';

end

gt = load(gt_f); 
es = load(es_f); 
es_p = load(es_f2);

% traj_len = compute_trajectory_length(es_p(:,2:4));

gt = syn_last_frame(gt, es(:,1));

% p = 0.513; %1;
% st = 1;
% et = size(gt,1)*p;
% sti = int32(size(gt,1)*p) ; 
% eti = int32(size(gt,1)*0.763);
% plot_xyz(gt(sti:eti,2), gt(sti:eti,3), gt(sti:eti,4), '-k'); 

gt(:,2:8) = transform_traj(gt(:,2:8)); 
es(:,2:8) = change_order(es(:,2:8)); 
es_p(:,2:8) = change_order(es_p(:,2:8)); 

es(:,2:8) = transform_traj(es(:,2:8)); 
es_p(:,2:8) = transform_traj(es_p(:,2:8));

% plot_xyz(gt(:,2), gt(:,3), gt(:,4), 'k'); 
plot_xyz(gt(:,2), gt(:,3), gt(:,4), 'y');
hold on;
st = 1;% 1200;
et = size(es,1); % 1800
plot_xyz(es(st:et,2), es(st:et,3), es(st:et,4), '-r'); 
hold on;
plot_xyz(es_p(st:et,2), es_p(st:et,3), es_p(st:et,4),'-g');
% legend('GT','VO','VO_P');
h = legend('GroundTruth', 'VO RGBD-SLAM', 'VO LSD-SLAM');
set(h, 'FontSize', 14);
hold on;
plot3(gt(1,2), gt(1,3), gt(1,4), 'g*', 'MarkerSize', 15, 'LineWidth',2);
% plot3(gt(sti,2), gt(sti,3), gt(sti,4), 'k*', 'MarkerSize', 15, 'LineWidth',2);
% plot3(es(st,2), es(st,3), es(st,4), 'r*', 'MarkerSize', 15, 'LineWidth',2);
% plot3(es_p(st,2), es_p(st,3), es_p(st,4), 'b*', 'MarkerSize', 15, 'LineWidth',2);


%% try save meshlab 
% save_meshlab('./tmp/trajectory_mesh_2.ply',gt(:,2:4), es(:, 2:4), es_p(:,2:4));

end


function np = change_order(p)
    np = p ; 
    np(:,5:7) = p(:,4:6);
    np(:,4) = p(:,7);
end


%% save into meshlab 
function save_meshlab(f, gt, es1, es2)
    
    % pts_gt = generate_mesh_pts(gt, [0 0 0]); % black for gt
    % pts_gt = generate_mesh_pts(gt, [153 0 153]); % purple 
    pts_gt = generate_mesh_pts(gt, [255 255 0]); % yellow
    pts_es1 = generate_mesh_pts(es1, [255 0 0]); % red for es1
    pts_es2 = generate_mesh_pts(es2, [0 255 0]); % blue for es2
    
    %% write them into a ply file 
    pts = [pts_gt; pts_es1; pts_es2]; 
    n = size(pts, 1); 
    fid = fopen(f, 'w'); 
    fprintf(fid, 'ply\nformat ascii 1.0\nelement vertex %d\nproperty float x\nproperty float y\nproperty float z\nproperty uchar red\nproperty uchar green\nproperty uchar blue\nend_header\n', n);
    fclose(fid); 
    dlmwrite(f,pts,'-append', 'delimiter',' ');
    
end
function [pts] = generate_mesh_pts(t, c)
    pts = t; 
    pc = repmat( c, size(t,1), 1); 
    pts = [pts pc];
end


function l = compute_trajectory_length(p)
    l = 0;
    for i=2:size(p,1)
        dt = p(i,:) - p(i-1,:);
        l = l + sqrt(dt*dt');
    end
end

function gt = syn_last_frame(gt, es_t)
    time_passed = es_t(end) - es_t(1); 
    index = size(gt,1);
    while gt(index,1) - gt(1,1) > time_passed
        index = index - 1; 
    end
    gt(index+1:size(gt,1), :) = [];
end

function plot_xyz(x, y, z, c)
    plot3(x, y, z, c, 'LineWidth', 2);
    hold on;
    hold off;
    axis equal;
    grid;
    xlabel('X (m)');ylabel('Y (m)');zlabel('Z (m)');
end 

