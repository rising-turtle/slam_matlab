function get_ground_truth_pose()
%
% Author : David Zhang (hxzhang1@ualr.edu)
% Date : 08/08/16
% get the ground truth pose of the keyframes
%

gt_f = '.\motion_capture_data\test_10_16_2015\Take 2015-10-16 04.49.46 PM.dat_pose_wp';
es_f = '.\motion_capture_data\test_10_16_2015\dataset_3\compare_lsd_vo\key_frame_trajectory.log'; % lsd-vo
% es_f = '.\motion_capture_data\test_10_16_2015\dataset_3\compare_lsd_vo\trajectory_estimate.txt';  % rgbd-vo

add_path_zh;

gt = load(gt_f); 
es = load(es_f); 


%% synchroization with time 
[es_syn, gt_syn] = syn_time_with_gt(es, gt);

% gt sequence: timestamp x y z qw qx qy qz => timestamp x y z qx qy qz qw
gt = [es_syn(:,1) gt_syn(:,2:4) gt_syn(:, 6:8) gt_syn(:, 5)]; 
% dlmwrite('.\tmp\data_3_rgbd_gt_pose.log', gt, 'delimiter', ' ');
dlmwrite('.\tmp\data_3_lsd_gt_pose.log', gt, 'delimiter', ' ');

sid = 1; 
eid = 100; %size(gt,1);
plot3(gt(sid:eid,2), gt(sid:eid,3), gt(sid:eid,4), 'k-*');
hold on; 
plot3(es_syn(sid:eid,2), es_syn(sid:eid,3), es_syn(sid:eid,4), 'b*-');
% test_gt(gt_syn(1:end,2:8));


end

%% test whether the gt's transformation works correctly 
function test_gt(gt)
    
    tmp_v = [0 0 0 1 0 0 0];
    pre_gt = gt(1,:); 
    T_g1 = toTrans(pre_gt);
    T_n1 = toTrans(tmp_v);
    nv = tmp_v;
    for i=2:size(gt,1)
       cur_gt = gt(i,:); 
       T_g2 = toTrans(cur_gt);
       
       % gt incremental transformation
       inc_trans = T_g1\T_g2;   % inv(Tg1)*Tg2
       T_n2 = T_n1*inc_trans;
       cur_v = toPose(T_n2);
       nv = [nv; cur_v];
       
       % next iteration 
       T_n1 = T_n2; 
       T_g1 = T_g2; 
    end
    hold on;
    plot3(nv(:,1), nv(:,2), nv(:,3), 'b*-');
end

function T = toTrans(p)
   % R = quat2rmat(p(4), p(5), p(6), p(7)); 
   q = p(4:7); 
   t = p(1:3); 
   R = quat2rmat(q');
   T = [R t'; 0 0 0 1]; 
end

function p = toPose(T)
   R = T(1:3,1:3);
   q = rmat2quat(R);
   t = T(1:3,4);
   p(1:3) = t'; 
   p(4:7) = q'; 
end
