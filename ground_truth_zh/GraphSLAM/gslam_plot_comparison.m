% plot comparison of g2o and isam

function gslam_plot_comparison()


% file_index = 5;     % 5 = whitecane
% dynamic_index = 16;

file_index = 9;     % 5 = whitecane 6 = etas
dynamic_index = 1;     % 15:square_500, 16:square_700, 17:square_swing
etas_nFrame_list = [979 1479 979 1979 1889]; %[3rd_straight, 3rd_swing, 4th_straigth, 4th_swing, 5th_straight, 5th_swing]
loops_nFrame_list = [0 1359 2498 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2669];
kinect_tum_nFrame_list = [0 98 0 0];
m_nFrame_list = [0 5414 0 729];
compensation_option ={'Replace','Linear'};
feature_flag = 0;
etas_vro_size_list = [1260 0 1665 0 9490 0]; %1974
loops_vro_size_list = [0 13098 12476 0 0 0 0 0 0 0 0 0 0 0 0 0 0 26613];
kinect_tum_vro_size_list = [0 98 0 0];
vro_name_list={'vro','vro_icp','vro_icp_ch','icp'};
vro_name_index = 3;
vro_name=vro_name_list{vro_name_index};
loops2_nFrame_list = [582 398 398 832]; %2498 578
loops2_vro_size_list = [2891 0 0 5754]; %4145
loops2_pose_size_list = [582 0 0 832];

switch file_index
    case 5       
        nFrame = m_nFrame_list(dynamic_index - 14);
        vro_size = 6992; %5382; %46; %5365; %5169;
    case 6
        nFrame = etas_nFrame_list(dynamic_index); %289; 5414; %46; %5468; %296; %46; %86; %580; %3920;
        vro_size = 1260; %etas_vro_size_list(dynamic_index); %1951; 1942; %5382; %46; %5365; %5169;
    case 7
        nFrame = loops_nFrame_list(dynamic_index);
        vro_size = loops_vro_size_list(dynamic_index); 
    case 8
        nFrame = kinect_tum_nFrame_list(dynamic_index);
        vro_size = kinect_tum_vro_size_list(dynamic_index); 
    case 9
        nFrame = loops2_nFrame_list(dynamic_index);
        vro_size = loops2_vro_size_list(dynamic_index); 
        pose_size = loops2_pose_size_list(dynamic_index);
end

if feature_flag == 1
    feature_pose_name = 'pose_feature';
else
    feature_pose_name = 'pose_zero';
end

[g2o_result_dir_name, isam_result_dir_name, vro_dir_name, dynamic_dir_name, toro_dir_name] = get_file_names(file_index, dynamic_index);

% switch dynamic_index
%     case 15
%         vro_size = 3616;
%     case 16
%         vro_size = 5169;
%     case 11
%         vro_size = 84;
% end

%vro_file_name = sprintf('%s%s_%s_%s_%d.g2o', vro_dir_name, dynamic_dir_name, compensation_option{2}, feature_pose_name, vro_size);
%g2o_result_file_name = sprintf('%s%s_%d.opt', g2o_result_dir_name, dynamic_dir_name, vro_size);
%isam_result_file_name = sprintf('%s%s_%s_%s_zero_%d_isam.opt', isam_result_dir_name, dynamic_dir_name, compensation_option{1}, feature_pose_name, vro_size);
%isp_file_name = sprintf('%s%s_%s_%s_zero_%d.isp', vro_dir_name, dynamic_dir_name, compensation_option{2}, feature_pose_name, 1974);
%isp_file_name_plus1 = sprintf('%s%s_%s_%s_zero_%d_329.isp', vro_dir_name, dynamic_dir_name, compensation_option{1}, feature_pose_name, vro_size);
%isp_file_name_plus2 = sprintf('%s%s_%s_%s_zero_%d_610.isp', vro_dir_name, dynamic_dir_name, compensation_option{1}, feature_pose_name, vro_size);
%isp_file_name_plus3 = sprintf('%s%s_%s_%s_zero_%d_325.isp', vro_dir_name, dynamic_dir_name, compensation_option{1}, feature_pose_name, vro_size);
%isp_file_name_plus1_minlength = sprintf('%s%s_%s_%s_zero_%d.isp', vro_dir_name, dynamic_dir_name, compensation_option{1}, feature_pose_name, 118);
%isp_file_name_plus1_minlength2 = sprintf('%s%s_%s_%s_zero_%d.isp', vro_dir_name, dynamic_dir_name, compensation_option{1}, feature_pose_name, 108);
gtsam_isp_file_name_icp = sprintf('%s%s_%s_%s_%d_%s_gtsam.isp', vro_dir_name, dynamic_dir_name, compensation_option{1}, feature_pose_name, 2873, vro_name_list{2}); %5763
gtsam_isp_file_name_icp_ch = sprintf('%s%s_%s_%s_%d_%s_gtsam.isp', vro_dir_name, dynamic_dir_name, compensation_option{1}, feature_pose_name, vro_size, vro_name_list{3});
icp_ct_file_name = sprintf('%s%s_%s_%s_%d_%d_%s_icp.ct', vro_dir_name, dynamic_dir_name, compensation_option{1}, feature_pose_name, 2873, pose_size, vro_name_list{2}); %5763
icp_ct_file_name_ch = sprintf('%s%s_%s_%s_%d_%d_%s_icp.ct', vro_dir_name, dynamic_dir_name, compensation_option{1}, feature_pose_name, vro_size, pose_size, vro_name_list{3});
%gtsam_result_file_name = sprintf('%s%s_%s_%s_zero_%d_gtsam.opt', isam_result_dir_name, dynamic_dir_name, compensation_option{2}, feature_pose_name, vro_size);
%isp_file_name2 = sprintf('%s%s_%s_%s_%d.isp', vro_dir_name, dynamic_dir_name, compensation_option{2}, feature_pose_name, vro_size);
%isam_result2_file_name = sprintf('%s%s_%s_%s_%d_isam.opt', isam_result_dir_name, dynamic_dir_name, compensation_option{2}, feature_pose_name, vro_size);
%isp2_file_name = sprintf('%s%s_%s_%s_%d.isp', vro_dir_name, dynamic_dir_name, compensation_option{2}, feature_pose_name, vro_size);
%toro_result_file_name = sprintf('%s%s_%s_%s_%d-treeopt-final.graph', toro_dir_name, dynamic_dir_name, compensation_option{1}, feature_pose_name, vro_size);
%toro_vro_file_name = sprintf('%s%s_%s_%s_%d.graph', toro_dir_name, dynamic_dir_name, compensation_option{1}, feature_pose_name, vro_size);
%toro_result2_file_name = sprintf('%s%s_%s_%s_%d-treeopt-final.graph', toro_dir_name, dynamic_dir_name, compensation_option{2}, feature_pose_name, vro_size);
%isp_file_name3 = sprintf('%s%s_%s_%s_zero_%d.isp', vro_dir_name, dynamic_dir_name, compensation_option{2}, feature_pose_name, vro_size);
%isam_result3_file_name = sprintf('%s%s_%s_%s_zero_%d_isam.opt', isam_result_dir_name, dynamic_dir_name, compensation_option{2}, feature_pose_name, vro_size);

%[vro_poses vro_edges] = load_graph_g2o(vro_file_name);
%[g2o_poses g2o_edges] = load_graph_g2o(g2o_result_file_name);
[vro_poses] = load_graph_isp(gtsam_isp_file_name_icp);
[vro_poses2] = load_graph_isp(gtsam_isp_file_name_icp_ch);

[vro_ct] = load(icp_ct_file_name);
[vro_ct_ch] = load(icp_ct_file_name_ch);

[ct_mean, ct_median, ct_std] = compute_ct_statistics(vro_ct);
[ct_mean_ch, ct_median_ch, ct_std_ch] = compute_ct_statistics(vro_ct_ch);

figure;
%errorbar(ct_mean, ct_std,'k','LineWidth',2); %,'k*-'
plot(ct_median,'gd-','LineWidth',2);
hold on;
%errorbar(ct_mean_ch, ct_std_ch,'g','LineWidth',2);
plot(ct_median_ch,'k*-','LineWidth',2);
legend('ICP','Fast ICP');
x_interval=1:5;
set(gca,'XTick',x_interval,'FontSize',12,'FontWeight','bold');
h_xlabel = get(gca,'XLabel');
set(h_xlabel,'FontSize',12,'FontWeight','bold');
h_ylabel = get(gca,'YLabel');
set(h_ylabel,'FontSize',12,'FontWeight','bold');
xlabel('Step');
ylabel('Computational Time [sec]');
ylim([2.5 6]);
grid;
hold off;

%[vro_poses] = load_graph_isp(isp_file_name);
%[vro_poses2] = load_graph_isp(isp_file_name_plus1);
%[vro_poses] = load_graph_isp(isp_file_name_plus2);
%[vro_poses3] = load_graph_isp(isp_file_name_plus3);
%[vro_poses3] = load_graph_isp(isp_file_name_plus1_minlength);
%[vro_poses4] = load_graph_isp(isp_file_name_plus1_minlength2);
%[vro_poses2] = load_graph_isp(isp_file_name2);
%[gtsam_poses] = load_graph_isp(gtsam_result_file_name);
%[isam_poses2] = load_graph_isam(isam_result2_file_name);
%[toro_poses toro_edges toro_fpts_poses toro_fpts_edges] = load_graph_toro(toro_result_file_name);
%[toro_poses2 toro_edges2 toro_fpts_poses2 toro_fpts_edges2] = load_graph_toro(toro_result2_file_name);
%[vro_poses3] = load_graph_isp(isp_file_name3);
%[isam_poses3] = load_graph_isam(isam_result3_file_name);

%isam_poses(133:size(isam_poses,1),:) = isam_poses(133:size(isam_poses,1),:) + repmat(isam_poses(132,:), size(isam_poses,1)-132, 1);

%gt_name = sprintf('../data/dynamic/%s/d1_gt.dat',dynamic_dir_name);
%gt = {load(gt_name)};
%gt_x = cumsum(diff(gt{1,1}(6:20,1)))/1000;

start_index = 1;
%end_index = min([size(vro_poses,1) size(toro_poses,1) size(isam_poses,1)]); %80;
end_index = min([size(vro_poses,1) size(vro_poses2,1)]); %80;
if size(vro_poses,2) >= 3     % SE3
    figure; 
    %plot3(vro_poses(start_index:end_index,1), vro_poses(start_index:end_index,2), vro_poses(start_index:end_index,3),'b-','LineWidth',2);
    %plot3(vro_poses(:,1), vro_poses(:,2), vro_poses(:,3),'b-','LineWidth',2);
    plot(vro_poses(:,1), vro_poses(:,2), 'g-','LineWidth',2);
    hold on;
    %plot3(vro_poses2(start_index:end_index,1), vro_poses2(start_index:end_index,2), vro_poses2(start_index:end_index,3), 'm-','LineWidth',2);
    %plot3(vro_poses3(:,1), vro_poses3(:,2), vro_poses3(:,3), 'g-','LineWidth',2);
    plot(vro_poses2(:,1), vro_poses2(:,2), 'k-','LineWidth',2);
    %plot3(vro_poses2(:,1), vro_poses2(:,2), vro_poses2(:,3), 'm-','LineWidth',2);
    %plot3(vro_poses3(1:98,1), vro_poses3(1:98,2), vro_poses3(1:98,3), 'r-','LineWidth',2);
    %plot3(vro_poses4(1:98,1), vro_poses4(1:98,2), vro_poses4(1:98,3), 'g-','LineWidth',2);
    %hold on;
    %plot(vro_poses3(:,1), vro_poses3(:,2),'k-','LineWidth',2);
    %plot(vro_poses(start_index:end_index,1), 'b*-','LineWidth',2);
    %xlabel('X [m]');
    %ylabel('Y [m]');
    %grid;[e_t_pose e_o_pose] = convert_o2p(f_index, t_pose, o_pose)
    %figure; 
    %hold on;
    %plot3(toro_poses(:,1), toro_poses(:,2), toro_poses(:,3),'g-','LineWidth',2);
    %plot(toro_poses2(:,1), toro_poses2(:,2),'r-','LineWidth',2);
    %plot3(isam_poses(:,1), isam_poses(:,2), isam_poses(:,3),'m-','LineWidth',2);
    %plot3(gtsam_poses(:,1), gtsam_poses(:,2), gtsam_poses(:,3),'b-','LineWidth',2);
    %plot(isam_poses2(:,1), isam_poses2(:,2),'c-','LineWidth',2);
    %plot(isam_poses3(:,1), isam_poses3(:,2),'m-','LineWidth',2);
    %plot(g2o_poses(start_index:end_index,1), 'ro-','LineWidth',2);
    %plot(isam_poses(start_index:end_index,1), 'md-','LineWidth',2);
    %plot(gt_x, 'g+-','LineWidth',2);
    %plot_groundtruth();
    %plot_gt_etas();
    xlabel('X [m]');
    ylabel('Y [m]');
    zlabel('Z [m]');
    grid;
    legend('ICP','Fast ICP'); %,'iSAM_R','GT_e');
    %legend('VRO_R','VRO_L','GT_e');
    %legend('vro','Toro_R','Toro_L','isam_R','isam_L','gt_e');
    %legend('VRO Dense','VRO Sparse','VRO Adaptive'); %,'iSAM_R','GT_e');
    %legend('VRO','TORO_R','TORO_L','GT_e');
    %legend('VRO','iSAM_R','iSAM_L','GT_e');
    %legend('VRO_L','TORO_L','iSAM_L','GT_e');
    %legend('VRO_L','VRO_Zeor','TORO_L','iSAM_L','iSAM_zero','GT_e');
    %xlim([-0.1 0.6]);
    %ylim([-0.1 0.6]);
    set(gca,'FontSize',12,'FontWeight','bold');
    h_xlabel = get(gca,'XLabel');
    set(h_xlabel,'FontSize',12,'FontWeight','bold');
    h_ylabel = get(gca,'YLabel');
    set(h_ylabel,'FontSize',12,'FontWeight','bold');
    h_zlabel = get(gca,'ZLabel');
    set(h_zlabel,'FontSize',12,'FontWeight','bold');
    hold off;
    axis equal;
end

end

function plot_groundtruth()
    gt_x = [0 0 2135 2135 0];
    gt_y = [0 1220 1220 0 0];
    gt_x = gt_x / 1000; % [mm] -> [m]
    gt_y = gt_y / 1000; % [mm] -> [m]
    plot(gt_x,gt_y,'g-','LineWidth',2);
end