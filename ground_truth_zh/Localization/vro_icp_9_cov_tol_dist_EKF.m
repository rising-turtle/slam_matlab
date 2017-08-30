% This function compute the transformation of two 3D point clouds by ICP
% 
% Parameters : 
%
% Author : Soonhac Hong (sxhong1@ualr.edu)
% Date : 9/20/12
% ICP6 + convexhull = ICP9
% ICP9_cov + tolerance adjustment = ICP9_cov_tol
% ICP9_cov_tol_dist + adjust coordinate for EKF = ICP9_cov_tol_dist_EKF

function [phi_icp, theta_icp, psi_icp, trans_icp, match_rmse, match_num, elapsed_time, sta_icp, error, pose_std] = vro_icp_9_cov_tol_dist_EKF(op_pset1, op_pset2, rot, trans, x1, y1, z1, img1, c1, x2, y2, z2, img2, c2)

error = 0;
sta_icp = 1;

t_icp = tic;

% test for local minimum in optimization
%trans = [0; 0; 0];
%rot = euler_to_rot(0, 27, 0);

if size(op_pset1,2) <= 8 || size(op_pset2,2) <= 8
    fprintf('Error in less point for convex hull.\n');
    error=6;
    phi_icp = 0.0; theta_icp = 0.0; psi_icp = 0.0; trans_icp = [0.0; 0.0; 0.0];
    elapsed_time = [0.0, 0.0, 0.0, 0.0, 0.0]; sta_icp = 0;
    match_rmse = 0.0;
    match_num = [0; 0];
    pose_std = [0.0; 0.0; 0.0; 0.0; 0.0; 0.0];
    return;
end

% compute 3D convex hull
t_convex = tic;
convexhull_1 = convhulln(op_pset1',{'Qt','Pp'});
convexhull_2 = convhulln(op_pset2',{'Qt','Pp'});

% %show convexhull
convexhull_1_x =[];
convexhull_1_y =[];
convexhull_1_z =[];

for i=1:size(convexhull_1,1)
    for j=1:3
        convexhull_1_x = [convexhull_1_x op_pset1(1,convexhull_1(i,j))];
        convexhull_1_y = [convexhull_1_y op_pset1(2,convexhull_1(i,j))];
        convexhull_1_z = [convexhull_1_z op_pset1(3,convexhull_1(i,j))];
    end
end

% plot3(convexhull_1_x, convexhull_1_y, convexhull_1_z,'d-');
% grid;
% axis equal;

%draw_data = [convexhull_1_x' convexhull_1_y' convexhull_1_z'];
%mesh(draw_data);


%M = op_pset1;
%D = op_pset2;
M_k = 1;
D_k = 1;
M=[];
D=[];
convex_check = 1; % check convex hull
convexhull_tolerance = 0.1;  %[m]
max_confidence_1 = max(c1(:));
max_confidence_2 = max(c2(:));
threshold = 0.5;
confidence_thresh_1 = threshold * max_confidence_1;
confidence_thresh_2 = threshold * max_confidence_2;
%Initialize data by trans
subsampling_factor = 2;
h_border_cutoff = round(size(x1,2)*0.1/2);
v_border_cutoff = round(size(x1,1)*0.1/2);
for i=1+v_border_cutoff:subsampling_factor:size(x1,1)-v_border_cutoff
    for j=1+h_border_cutoff:subsampling_factor:size(x1,2)-h_border_cutoff
        M_test = [-x1(i,j) -y1(i,j) z1(i,j)];
        M_in_flag = inhull(M_test,op_pset1',convexhull_1,convexhull_tolerance);
        D_test = [-x2(i,j) -y2(i,j) z2(i,j)];
        D_in_flag = inhull(D_test,op_pset2',convexhull_2,convexhull_tolerance);
        if M_in_flag == 1 || convex_check == 0 % test point locates in the convex hull
            %if img1(i,j) >= 50  % intensity filtering for less noise
            if c1(i,j) >= confidence_thresh_1 % confidence filtering
                M(:,M_k) = M_test'; %[-x1(i,j); z1(i,j); y1(i,j)];
                M_k = M_k + 1;
            end
        end
        if D_in_flag == 1 || convex_check == 0
            %if img2(i,j) >= 50  % intensity filtering for less noise
            if c2(i,j) >= confidence_thresh_2 % confidence filtering
                D(:,D_k) = D_test'; %[-x2(i,j); z2(i,j); y2(i,j)];
                D_k = D_k + 1;
            end
        end
        %temp_pt2 = [-x2(i,j); z2(i,j); y2(i,j)];
        %D(:,k) = rot*temp_pt2 + trans;
        %transed_pt1 = rot*temp_pt + trans;
        %k = k + 1;
    end
end
elapsed_convex = toc(t_convex);

%distance filter
[M, D] = check_feature_distance_icp(M, D);

ap_size=size(M,2);

if isempty(M) || isempty(D)
    fprintf('Error in less point for ICP.\n');
    error=6;
    phi_icp = 0.0; theta_icp = 0.0; psi_icp = 0.0; trans_icp = [0.0; 0.0; 0.0];
    elapsed_time = [0.0, 0.0, 0.0, 0.0, 0.0]; sta_icp = 0;
    match_rmse = 0.0;
    match_num = [0; 0];
    pose_std = [0.0; 0.0; 0.0; 0.0; 0.0; 0.0];
    return;
end

%t_icp = tic;
%[Ricp, Ticp, ER, t]=icp(M, D,'Minimize','plane');
%elapsed_icp = toc(t_icp);
%[phi_icp, theta_icp, psi_icp] = rot_to_euler(Ricp); 

%Transform data-matrix using ICP result
%Dicp = Ricp * D + repmat(Ticp, 1, n);

t_icp_icp = tic;
converged = 0;
rmse_total=[];
rot_total=[];
trans_total=[];
match_num_total=[];
while_cnt = 1;
while converged == 0
    % find correspondent assoicate
    Dicp = rot * D + repmat(trans, 1, size(D,2));
    
    %p = rand( 20, 2 ); % input data (m x n); n dimensionality
    %q = rand( 10, 2 ); % query data (d x n)
    t_kdtree = tic;
    pt1=[];
    pt2=[];
    if size(M,2) > size (D,2)
        tree = kdtree_build( M' );
        correspondent_idxs = kdtree_nearest_neighbor(tree, Dicp');
        pt2 = D;
        for i=1:size(correspondent_idxs,1)
            pt1(:,i) = M(:,correspondent_idxs(i));
        end
    else
        tree = kdtree_build( Dicp' );
        correspondent_idxs = kdtree_nearest_neighbor(tree, M');
        pt1 = M;
        for i=1:size(correspondent_idxs,1)
            pt2(:,i) = D(:,correspondent_idxs(i));
        end
    end
    elapsed_kdtree = toc(t_kdtree);
    
    
    %[R_icp, trans_icp, ER, t]=icp(pt1, pt2,'Minimize','plane','WorstRejection',0.1);
    %[phi_icp, theta_icp, psi_icp] = rot_to_euler(R_icp); 
    
    % Outlier removal
    % Compute error
    t_icp_ransac = tic;
    pt2_transed= rot * pt2 + repmat(trans, 1, size(pt2,2));
    new_cnt = 1;
    pt1_new=[];
    pt2_new=[];
    correspondent_idxs_new=[];
    for i=1:size(pt1,2)
        unit_rmse = sqrt(sum((pt2_transed(:,i) - pt1(:,i)).^2));
        if unit_rmse < 0.03
            pt1_new(:,new_cnt) = pt1(:,i);
            pt2_new(:,new_cnt) = pt2(:,i);
            correspondent_idxs_new(new_cnt) = correspondent_idxs(i);
            new_cnt = new_cnt + 1;
        end
    end
    pt1 = pt1_new;
    pt2 = pt2_new;
    correspondent_idxs = correspondent_idxs_new';
    
    % Delete duplicates in correspondent points
%     correspondent_unique = unique(correspondent_idxs);
%     correspondent_unique_idx = ones(size(correspondent_idxs));
%     for i=1:length(correspondent_unique)
%         unit_idx = find(correspondent_idxs == correspondent_unique(i));
%         if length(unit_idx) > 1
%             correspondent_unique_idx(unit_idx)=0;
%         end
%     end
%     
%     correspondent_delete_idx=find(correspondent_unique_idx == 0);
%     pt1(:,correspondent_delete_idx') = [];
%     pt2(:,correspondent_delete_idx') = [];
%     correspondent_idxs(correspondent_delete_idx,:) = [];
    
    
    if isempty(pt1) || isempty(pt2)
         fprintf('Error in RANSAC with additional points.\n');
        error=5;
        phi_icp = 0.0; theta_icp = 0.0; psi_icp = 0.0; trans_icp = [0.0; 0.0; 0.0];
        elapsed_time = [0.0, 0.0, 0.0, 0.0, 0.0]; sta_icp = 0;
        match_rmse = 0.0;
        match_num=[ap_size;0];
        pose_std = [0.0; 0.0; 0.0; 0.0; 0.0; 0.0];
        return;
    end
    
%    op_pset1_icp = pt1_new;
%    op_pset2_icp = pt2_new;
%    elapsed_icp_ransac = toc(t_icp_ransac);
    
    %t_icp_ransac = tic;
    [op_match, match_num, rtime, error_ransac] = run_ransac_points(pt1, pt2, correspondent_idxs', 0);  
    
    if error_ransac ~= 0     % Error in RANSAC
        fprintf('Error in RANSAC with additional points.\n');
        error=5;
        phi_icp = 0.0; theta_icp = 0.0; psi_icp = 0.0; trans_icp = [0.0; 0.0; 0.0];
        elapsed_time = [0.0, 0.0, 0.0, 0.0, 0.0]; sta_icp = 0;
        match_rmse = 0.0;
        pose_std = [0.0; 0.0; 0.0; 0.0; 0.0; 0.0];
        return;
    end
    
    op_pset1_icp = [];
    op_pset2_icp = [];
    for i=1:match_num(2)
        op_pset1_icp(:,i) = pt1(:,op_match(1,i));
        op_pset2_icp(:,i) = pt2(:,op_match(2,i));
    end
    elapsed_icp_ransac = toc(t_icp_ransac);
    
    % SVD
    t_svd_icp = tic;
    %[rot_icp, trans_icp, sta_icp] = find_transform_matrix(op_pset1_icp, op_pset2_icp);
    %[phi_icp, theta_icp, psi_icp] = rot_to_euler(rot_icp);
    %elapsed_svd = etime(clock, t_svd);
    sta_icp =1;
    
    t_init = zeros(6,1);
    %[t_init(2), t_init(1), t_init(3)] = rot_to_euler(rot);
    [t_init(1:3)] = R2e(rot); 
    t_init(4:6) = trans;
    [rot_icp, trans_icp] = lm_point_EKF(op_pset1_icp, op_pset2_icp, t_init);
    %[rot_icp, trans_icp] = lm_point2plane(op_pset1, op_pset2, t_init);
    elapsed_svd = toc(t_svd_icp);
  
%     M = op_pset1_icp;
%     D = op_pset2_icp;
    rot = rot_icp;
    trans = trans_icp;
    rot_total(:,:,while_cnt) = rot;
    trans_total(:,:,while_cnt) = trans;
    match_num_total(while_cnt) = size(op_pset1_icp,2);
    
    % Plot
%     figure;
%     plot3(op_pset1_icp(1,:),op_pset1_icp(2,:),op_pset1_icp(3,:),'b*-');
%     hold on;
%     plot3(op_pset2_icp(1,:),op_pset2_icp(2,:),op_pset2_icp(3,:),'ro-');
%     xlabel('X');
%     ylabel('Y');
%     zlabel('Z');
%     grid;
%     hold off;
    
    
    % Compute error
    op_pset1_icp_normal = lsqnormest(op_pset1_icp,4);
    op_pset2_icp_transed= rot * op_pset2_icp + repmat(trans, 1, size(op_pset2_icp,2));
%     rmse_icp = 0;
%     for i=1:size(M,2)
%         unit_rmse = sqrt(sum((D_transed(:,i) - M(:,i)).^2)/3);
%         rmse_icp = rmse_icp + unit_rmse;
%     end
%     rmse_icp = rmse_icp / size(M,2);
    
    %rmse_icp = rms_error(op_pset1_icp, op_pset2_icp_transed);
    rmse_icp = rms_error_normal(op_pset1_icp, op_pset2_icp_transed, op_pset1_icp_normal); % point-to-plain
    
    op_pset2_transed= rot * op_pset2 + repmat(trans, 1, size(op_pset2,2));
%     rmse_feature = 0;
%     for i=1:size(op_pset1,2)
%         unit_rmse = sqrt(sum((op_pset2_transed(:,i) - op_pset1(:,i)).^2)/3);
%         rmse_feature = rmse_feature + unit_rmse;
%     end
%     rmse_feature = rmse_feature / size(op_pset1,2);
    rmse_feature= rms_error(op_pset1,op_pset2_transed);
    
    rmse_total = [rmse_total (rmse_icp+rmse_feature)/2];
    %rmse_total = [rmse_total rmse_icp];
    rmse_thresh = 0.001;
    if length(rmse_total) > 3
        rmse_diff = abs(diff(rmse_total));
        rmse_diff_length = length(rmse_diff);
        if rmse_diff(rmse_diff_length) < rmse_thresh && rmse_diff(rmse_diff_length-1) < rmse_thresh && rmse_diff(rmse_diff_length-2) < rmse_thresh
            converged = 1;
        end
    end 
    while_cnt = while_cnt + 1;
end


[match_rmse match_rmse_idx] = min(rmse_total);
%match_rmse = rmse_total(end);
%match_rmse_idx = size(rmse_total,2);
match_num = [ap_size; match_num_total(match_rmse_idx)];
rot_icp = rot_total(:,:,match_rmse_idx);
trans_icp = trans_total(:,:,match_rmse_idx);
%[phi_icp, theta_icp, psi_icp] = rot_to_euler(rot_icp);
[euler_icp] = R2e(rot_icp); %rot_to_euler(rot_icp);
phi_icp = euler_icp(1);
theta_icp = euler_icp(2);
psi_icp = euler_icp(3);

elapsed_icp_icp = toc(t_icp_icp);

%t_icp_icp = tic;
%[Ricp, trans_icp, ER, t]=icp(op_pset1_icp, op_pset2_icp,'Minimize','plane');
%elapsed_icp_icp = toc(t_icp_icp);
%[phi_icp, theta_icp, psi_icp] = rot_to_euler(Ricp); 

elapsed_icp = toc(t_icp);
elapsed_time = [elapsed_convex, elapsed_kdtree, elapsed_icp_ransac, elapsed_icp_icp, elapsed_icp];

%Compute covariane
%[pose_std] = compute_pose_std(op_pset1_icp,op_pset2_icp, rot_icp, trans_icp);
%pose_std = pose_std';
pose_std = [];


% M = [];
% D = [];
% pt1 = [];
% pt2 = [];
% pt1_new=[];
% pt2_new=[];
% op_pset1 = [];
% op_pset2 = [];
% op_pset1_icp = [];
% op_pset2_icp = [];
% tree = [];
% convexhull_1=[];
% convexhull_2=[];
% M_in_flag=[];
% D_in_flag=[];

clear M D pt1 pt2 pt1_new pt2_new op_pset1 op_pset2 op_pset1_icp op_pset2_icp tree convexhull_1 convexhull_2 M_in_flag D_in_flag convexhull_1_x convexhull_1_y convexhull_1_z
clear FUN

end