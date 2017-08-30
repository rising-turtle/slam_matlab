% This function computes the pose of the sensor between two data set from
% SR400 using SIFT . The orignial function was vot.m in the ASEE/pitch_4_plot1.
% 
% Parameters : 
%   dm : number of prefix of directory containing the first data set.
%   inc : relative number of prefix of directory containing the second data set.
%         The number of prefix of data set 2 will be dm+inc.
%   j : index of frame for data set 1 and data set 2
%   dis : index to display logs and images [1 = display][0 = no display]
%
% Author : Soonhac Hong (sxhong1@ualr.edu)
% Date : 8/30/12


function [phi, theta, psi, trans, error, elapsed, match_num, feature_points, pose_std] = localization_sift_ransac_limit_icp2_cov_fast(image_name, data_name, filter_name, boarder_cut_off, ransac_iteration_limit, valid_ransac, scale, value_type, dm, inc, j, sframe, icp_mode, dis)

if nargin < 14
    dis = 0;
end

%Initilize parameters
error = 0;
sift_threshold = 0; 
%t = clock;

%Read first data set
if strcmp(data_name, 'm') || strcmp(data_name, 'etas') || strcmp(data_name, 'loops2') || strcmp(data_name, 'sparse_feature') % Dynamic data
    cframe = sframe;
else
    cframe = j;
end
first_cframe = cframe;

if check_stored_visual_feature(data_name, dm, cframe) == 0
    
    [img1, x1, y1, z1, c1, elapsed_pre] = LoadSR(data_name, filter_name, boarder_cut_off, dm, cframe, scale, value_type);
    
    if strcmp(image_name, 'depth') %image_name == 'depth'
        %Assign depth image to img1
        img1 = scale_img(z1, 1, value_type);
    end
    
    if dis == 1
        f1 = figure(4); imagesc(img1); colormap(gray); title(['frame ', int2str(j)]);
        %t_sift = clock;
        t_sift = tic;
        [frm1, des1] = sift(img1, 'Verbosity', 1);
        %elapsed_sift = etime(clock,t_sift);
        elapsed_sift = toc(t_sift);
        plotsiftframe(frm1);
    else
        %t_sift = clock;
        t_sift = tic;
        if sift_threshold == 0
            [frm1, des1] = sift(img1);
            %[frm1,des1] = vl_sift(single(img1)) ;
        else
            [frm1, des1] = sift(img1, 'threshold', sift_threshold);
        end
        %elapsed_sift = etime(clock,t_sift);
        elapsed_sift = toc(t_sift);
    end
    
    % confidence filtering
    [frm1, des1] = confidence_filtering(frm1, des1, c1);
    
    save_visual_features(data_name, dm, cframe, frm1, des1, elapsed_sift, img1, x1, y1, z1, c1, elapsed_pre);
    
else
    [frm1, des1, elapsed_sift, img1, x1, y1, z1, c1, elapsed_pre] = load_visual_features(data_name, dm, cframe);
end

%Read second Data set
if strcmp(data_name, 'm') || strcmp(data_name, 'etas') || strcmp(data_name, 'loops2')  || strcmp(data_name, 'sparse_feature')% Dynamic data
    %cframe = j + sframe;
    %cframe = sframe+1;
    cframe = sframe + j;   % Generate constraints
else
    dm=dm+inc;
    cframe = j;
end
second_cframe = cframe;

if check_stored_visual_feature(data_name, dm, cframe) == 0
    
[img2, x2, y2, z2, c2, elapsed_pre2] = LoadSR(data_name, filter_name, boarder_cut_off, dm, cframe, scale, value_type);

if strcmp(image_name, 'depth') %image_name == 'depth'
    %Assign depth image to img1
    img2 = scale_img(z2, 1, value_type);
end

if dis == 1
    f2=figure(5); imagesc(img2); colormap(gray); title(['frame ', int2str(j)]);
    %t_sift = clock;
    t_sift2 = tic;
    [frm2, des2] = sift(img2, 'Verbosity', 1); 
    %elapsed_sift2 = etime(clock, t_sift);
    elapsed_sift2 = toc(t_sift2); 
    plotsiftframe(frm2);
else
    %t_sift = clock;
    t_sift2 = tic;
    if sift_threshold == 0
        [frm2, des2] = sift(img2);
        %[frm2,des2] = vl_sift(single(img2)) ;
    else
        [frm2, des2] = sift(img2,'threshold', sift_threshold);
    end
    %elapsed_sift2 = etime(clock,t_sift);
    elapsed_sift2 = toc(t_sift2);
end

% confidence filtering
[frm2, des2] = confidence_filtering(frm2, des2, c2);  

save_visual_features(data_name, dm, cframe, frm2, des2, elapsed_sift2, img2, x2, y2, z2, c2, elapsed_pre2);

else
    [frm2, des2, elapsed_sift2, img2, x2, y2, z2, c2, elapsed_pre2] = load_visual_features(data_name, dm, cframe);
end


if check_stored_matched_points(data_name, dm, first_cframe, second_cframe) == 0
    
    %t_match = clock;
    t_match = tic;
    match = siftmatch(des1, des2);
    %[match, scores] = vl_ubcmatch(des1,des2) ;
    
    %elapsed_match = etime(clock,t_match);
    elapsed_match = toc(t_match);
    
    if dis == 1
        f3=figure(6);
        plotmatches(img1,img2,frm1,frm2,match); title('Match of SIFT');
    end
    
    % Eliminate pairwises which have zero in depth image of kinect or less 100 gray level in image of SR4000
    match_new = [];
    cnt_new = 1;
    pnum = size(match, 2);
    if strcmp(data_name, 'kinect_tum')
        for i=1:pnum
            frm1_index=match(1, i);     frm2_index=match(2, i);
            matched_pix1=frm1(:, frm1_index);     COL1=round(matched_pix1(1))+1;     ROW1=round(matched_pix1(2))+1;
            matched_pix2=frm2(:, frm2_index);     COL2=round(matched_pix2(1))+1;     ROW2=round(matched_pix2(2))+1;
            if z1(ROW1, COL1) > 0 && z2(ROW2, COL2) > 0
                match_new(:,cnt_new) = match(:,i);
                cnt_new = cnt_new + 1;
            end
        end
    else
        for i=1:pnum
            frm1_index=match(1, i);     frm2_index=match(2, i);
            matched_pix1=frm1(:, frm1_index);     COL1=round(matched_pix1(1))+1;     ROW1=round(matched_pix1(2))+1;
            matched_pix2=frm2(:, frm2_index);     COL2=round(matched_pix2(1))+1;     ROW2=round(matched_pix2(2))+1;
            if img1(ROW1, COL1) >= 0 && img2(ROW2, COL2) >= 0
                match_new(:,cnt_new) = match(:,i);
                cnt_new = cnt_new + 1;
            end
        end
    end
    match = match_new;
    
    %find the matched two point sets.
    %match = [4 6 21 18; 3 7 19 21];
    
    pnum = size(match, 2);
    if pnum <= 12
        fprintf('too few sift points for ransac.\n');
        error=1;
        phi=0.0; theta=0.0; psi=0.0; trans=[0.0; 0.0; 0.0];
        elapsed_ransac = 0.0;
        elapsed_svd = 0.0;
        match_num = [pnum; 0];
        %rt_total = etime(clock,t);
        elapsed = [elapsed_pre; elapsed_sift; elapsed_pre2; elapsed_sift2; elapsed_match; elapsed_ransac; elapsed_svd; 0];
        feature_points = [];
        pose_std = [0.0; 0.0; 0.0; 0.0; 0.0; 0.0];
        return;
    else
        
        %t_ransac = clock; %cputime;
        t_ransac = tic;
        
        %Eliminate outliers by geometric constraints
        %     for i=1:pnum
        %         frm1_index=match(1, i);     frm2_index=match(2, i);
        %         matched_pix1=frm1(:, frm1_index);     COL1=round(matched_pix1(1));     ROW1=round(matched_pix1(2));
        %         matched_pix2=frm2(:, frm2_index);     COL2=round(matched_pix2(1));     ROW2=round(matched_pix2(2));
        %         pset1(1,i)=-x1(ROW1, COL1);   pset1(2,i)=z1(ROW1, COL1);   pset1(3,i)=y1(ROW1, COL1);
        %         pset2(1,i)=-x2(ROW2, COL2);   pset2(2,i)=z2(ROW2, COL2);   pset2(3,i)=y2(ROW2, COL2);
        %         pset1_index(1,i) = ROW1;
        %         pset1_index(2,i) = COL1;
        %         pset2_index(1,i) = ROW2;
        %         pset2_index(2,i) = COL2;
        %     end
        %
        %     [match] = gc_distance(match, pset1,pset2);
        %
        %     Eliminate outlier by confidence map
        %     [match] = confidence_filter(match, pset1_index, pset2_index, c1, c2);
        
        if ransac_iteration_limit ~= 0
            % Fixed Iteration limit
            %     rst = min(700, nchoosek(pnum, 4));
            rst = min(ransac_iteration_limit, nchoosek(pnum, 4));
            %     rst = nchoosek(pnum, 4);
            %     valid_ransac = 3;
            %     stdev_threshold = 0.5;
            %     stdev_threshold_min_iteration = 30;
            tmp_nmatch=zeros(2, pnum, rst);
            for i=1:rst
                [n_match, rs_match, cnum] = ransac(frm1, frm2, match, x1, y1, z1, x2, y2, z2);
                for k=1:cnum
                    tmp_nmatch(:,k,i) = n_match(:,k);
                end
                tmp_rsmatch(:, :, i) = rs_match;      tmp_cnum(i) = cnum;
                %         total_cnum(i)=cnum;
                %         inliers_std = std(total_cnum);
                %         if i > stdev_threshold_min_iteration && inliers_std < stdev_threshold
                %             break;
                %         end
            end
            
        else
            %Standard termination criterion
            inlier_ratio = 0.15;  % 14 percent
            %     valid_ransac = 3; %inlier_ratio * pnum;
            i=0;
            eta_0 = 0.01;       % 99 percent confidence
            cur_p = 4 / pnum;
            eta = (1-cur_p^4)^i;
            %     stdev_threshold = 0.1;
            %     stdev_count = 0;
            %     count_threshold = 15;
            %     mean_threshold = 0.1;
            %     mean_count = 0;
            %     window_size = 30;
            %     debug_data=[];
            ransac_error = 0;
            max_iteration = 120000;
            while eta > eta_0
                %         t_ransac_internal = clock; %cputime;
                i = i+1;
                [n_match, rs_match, cnum] = ransac(frm1, frm2, match, x1, y1, z1, x2, y2, z2, data_name);
                %       [n_match, rs_match, cnum] = ransac_3point(frm1, frm2, match, x1, y1, z1, x2, y2, z2);
                %ct_internal = cputime - t_ransac_internal;
                %         ct_internal = etime(clock, t_ransac_internal);
                for k=1:cnum
                    tmp_nmatch(:,k,i) = n_match(:,k);
                end
                tmp_rsmatch(:, :, i) = rs_match;      tmp_cnum(i) = cnum;
                %         if cnum >= valid_ransac
                %             break;
                %         end
                %         if cnum/pnum >= inlier_ratio
                %             break;
                %         enddynamic_data_index
                %         total_cnum(i)=cnum;
                %         if i > window_size && inliers_std ~= 0
                %             inliers_std_prev = inliers_std;
                %             inliers_std = std(total_cnum(i-window_size:i));      %Moving STDEV
                %             inliers_std_delta = abs(inliers_std - inliers_std_prev)/inliers_std_prev;
                %
                %             inliers_mean_prev = inliers_mean;
                %             inliers_mean = mean(total_cnum(i-window_size:i));      %Moving STDEV
                %             inliers_mean_delta = abs(inliers_mean - inliers_mean_prev)/inliers_mean_prev;
                %
                %             if inliers_std_delta < stdev_threshold
                %                 stdev_count = stdev_count + 1;
                %             else
                %                 stdev_count = 0;
                %             end
                %
                %             if inliers_mean_delta < mean_threshold
                %                 mean_count = mean_count + 1;
                %             else
                %                 mean_count = 0;
                %             end
                %
                %             inlier_ratio = max(total_cnum)/pnum;
                % %             count_threshold = 120000 / ((inlier_ratio*100)^2); %-26 * (inlier_ratio*100 - 20) + 800;
                %
                %             if stdev_count > count_threshold %&& mean_count > count_threshold
                %                 break;
                %             end
                %         else
                %             inliers_std = std(total_cnum);
                %             inliers_mean = mean(total_cnum);
                %         end
                
                if cnum ~= 0
                    cur_p = cnum/pnum;
                    eta = (1-cur_p^4)^i;
                end
                
                if i > max_iteration
                    ransac_error = 1
                    break;
                end
                %         debug_data(i,:)=[cnum, cur_p, eta, ct_internal];
            end
            ransac_iteration = i;
        end
        [rs_max, rs_ind] = max(tmp_cnum);
        
        op_num = tmp_cnum(rs_ind);
        if(op_num<valid_ransac || ransac_error == 1)
            fprintf('no consensus found, ransac fails.\n');
            error=2;
            phi=0.0; theta=0.0; psi=0.0; trans=[0.0; 0.0; 0.0];
            elapsed_ransac = 0.0;
            elapsed_svd = 0.0;
            match_num = [pnum; op_num];
            %rt_total = etime(clock,t);
            elapsed = [elapsed_pre; elapsed_sift; elapsed_pre2; elapsed_sift2; elapsed_match; elapsed_ransac; elapsed_svd; ransac_iteration];
            feature_points = [];
            pose_std = [0.0; 0.0; 0.0; 0.0; 0.0; 0.0];
            return;
        end
        for k=1:op_num
            op_match(:, k) = tmp_nmatch(:, k, rs_ind);
        end
        
        if dis == 1
            f4=figure(7); plotmatches(img1,img2,frm1,frm2,tmp_rsmatch(:,:,rs_ind)); title('Feature points for RANSAC');
            f5=figure(8); plotmatches(img1,img2,frm1,frm2,op_match); title('Match after RANSAC');
            f6=figure(9); plotmatches_multi(img1,img2,frm1,frm2,op_match,match); title('Match after SIFT');
        end
        %elapsed_ransac = etime(clock, t_ransac); %cputime - t_ransac;
        elapsed_ransac = toc(t_ransac);
        match_num = [pnum; op_num];
    end
    
    %% Run SVD
    %t_svd = clock;
    t_svd = tic;
    op_pset_cnt = 1;
    for i=1:op_num
        frm1_index=op_match(1, i);      frm2_index=op_match(2, i);
        matched_pix1=frm1(:, frm1_index);     COL1=round(matched_pix1(1))+1;     ROW1=round(matched_pix1(2))+1;
        matched_pix2=frm2(:, frm2_index);     COL2=round(matched_pix2(1))+1;     ROW2=round(matched_pix2(2))+1;
        op_pset1_image_index(i,:) = [matched_pix1(1), matched_pix1(2)]; %[COL1, ROW1];
        op_pset2_image_index(i,:) = [matched_pix2(1), matched_pix2(2)]; %[COL2, ROW2];
        %if img1(ROW1, COL1) >= 100 && img2(ROW2, COL2) >= 100
        op_pset1(1,op_pset_cnt)=-x1(ROW1, COL1);   op_pset1(2,op_pset_cnt)=z1(ROW1, COL1);   op_pset1(3,op_pset_cnt)=y1(ROW1, COL1);
        op_pset2(1,op_pset_cnt)=-x2(ROW2, COL2);   op_pset2(2,op_pset_cnt)=z2(ROW2, COL2);   op_pset2(3,op_pset_cnt)=y2(ROW2, COL2);
        op_pset_cnt = op_pset_cnt + 1;
        %end
        %     op_pset1(1,i)=x1(ROW1, COL1);   op_pset1(2,i)=y1(ROW1, COL1);   op_pset1(3,i)=z1(ROW1, COL1);
        %     op_pset2(1,i)=x2(ROW2, COL2);   op_pset2(2,i)=y2(ROW2, COL2);   op_pset2(3,i)=z2(ROW2, COL2);
    end
    
    save_matched_points(data_name, dm, first_cframe, second_cframe, match_num, ransac_iteration, op_pset1_image_index, op_pset2_image_index, op_pset_cnt, elapsed_match, elapsed_ransac, op_pset1, op_pset2);
    
else
    [match_num, ransac_iteration, op_pset1_image_index, op_pset2_image_index, op_pset_cnt, elapsed_match, elapsed_ransac, op_pset1, op_pset2] = load_matched_points(data_name, dm, first_cframe, second_cframe);
    t_svd = tic;
end

[rot, trans, sta] = find_transform_matrix(op_pset1, op_pset2);
[phi, theta, psi] = rot_to_euler(rot); 
%elapsed_svd = etime(clock, t_svd);
elapsed_svd = toc(t_svd);

%Test LM
%[rot_lm, trans_lm] = lm_point(op_pset1, op_pset2);
% [rot_lm, trans_lm] = lm_point2plane(op_pset1, op_pset2);
% [phi_lm, theta_lm, psi_lm] = rot_to_euler(rot_lm); 
% [theta*180/pi theta_lm*180/pi]
% [phi*180/pi phi_lm*180/pi]
% [psi*180/pi psi_lm*180/pi]


% Save feature points
%feature_points_1 =[repmat(1,[op_pset_cnt-1 1]) op_pset1'];
%feature_points_2 =[repmat(2,[op_pset_cnt-1 1]) op_pset2'];
feature_points_1 =[repmat(1,[op_pset_cnt-1 1]) op_pset1' op_pset1_image_index];
feature_points_2 =[repmat(2,[op_pset_cnt-1 1]) op_pset2' op_pset2_image_index];
feature_points = [feature_points_1; feature_points_2];

% Compute RMSE
op_pset2_transed= rot * op_pset2 + repmat(trans, 1, size(op_pset2,2));
% rmse = 0;
% for i=1:size(op_pset1,2)
%     unit_rmse = sqrt(sum((op_pset2_transed(:,i) - op_pset1(:,i)).^2)/3);
%     rmse = rmse + unit_rmse;
% end
% rmse_feature = rmse / size(op_pset1,2);
%rmse_feature = rms_error(op_pset1, op_pset2_transed);

% Show correspondent points
% plot3(op_pset1(1,:),op_pset1(2,:),op_pset1(3,:),'b*-');
% hold on;
% plot3(op_pset2(1,:),op_pset2(2,:),op_pset2(3,:),'ro-');
% xlabel('X');
% ylabel('Y');
% zlabel('Z');
% grid;
% hold off;

%Compute the elapsed time
%rt_total = etime(clock,t);
%elapsed = [elapsed_pre; elapsed_sift; elapsed_pre2; elapsed_sift2; elapsed_match; elapsed_ransac; elapsed_svd; ransac_iteration];

%% Run ICP

%[phi_icp, theta_icp, psi_icp, trans_icp, match_num, elapsed_icp, sta_icp, error] = vro_icp(op_pset1, op_pset2, rot, trans, x1, y1, z1, img1, x2, y2, z2, img2);
%[phi_icp, theta_icp, psi_icp, trans_icp, rmse_icp, match_num, elapsed_icp, sta_icp, error] = vro_icp_2(op_pset1, op_pset2, rot, trans, x1, y1, z1, img1, x2, y2, z2, img2);
%[phi_icp, theta_icp, psi_icp, trans_icp, rmse_icp, match_num, elapsed_icp, sta_icp, error] = vro_icp_3(op_pset1, op_pset2, rot, trans, x1, y1, z1, img1, x2, y2, z2, img2);
%[phi_icp, theta_icp, psi_icp, trans_icp, rmse_icp, match_num, elapsed_icp, sta_icp, error] = vro_icp_4(op_pset1, op_pset2, rot, trans, x1, y1, z1, img1, x2, y2, z2, img2);
%[phi_icp, theta_icp, psi_icp, trans_icp, rmse_icp, match_num, elapsed_icp, sta_icp, error] = vro_icp_5(op_pset1, op_pset2, rot, trans, x1, y1, z1, img1, x2, y2, z2, img2);
if strcmp(icp_mode, 'icp_ch')
    [phi_icp, theta_icp, psi_icp, trans_icp, rmse_icp, match_num, elapsed_icp, sta_icp, error, pose_std] = vro_icp_9_cov_tol_batch(op_pset1, op_pset2, rot, trans, x1, y1, z1, img1, c1, x2, y2, z2, img2, c2);
    %[phi_icp, theta_icp, psi_icp, trans_icp, rmse_icp, match_num, elapsed_icp, sta_icp, error, pose_std] = vro_icp_9_cov_tol(op_pset1, op_pset2, rot, trans, x1, y1, z1, img1, c1, x2, y2, z2, img2, c2);
else
    [phi_icp, theta_icp, psi_icp, trans_icp, rmse_icp, match_num, elapsed_icp, sta_icp, error, pose_std] = vro_icp_6_cov(op_pset1, op_pset2, rot, trans, x1, y1, z1, img1, c1, x2, y2, z2, img2, c2);
end

%[phi_icp, theta_icp, psi_icp, trans_icp, rmse_icp, match_num, elapsed_icp, sta_icp, error] = vro_icp_10(op_pset1, op_pset2, rot, trans, x1, y1, z1, img1, x2, y2, z2, img2);
%[phi_icp, theta_icp, psi_icp, trans_icp, rmse_icp, match_num, elapsed_icp, sta_icp, error] = vro_icp_13(op_pset1, op_pset2, rot, trans, x1, y1, z1, img1, x2, y2, z2, img2);

%Check status of SVD
if sta_icp == 0  || error ~= 0   % No Solution
    fprintf('no solution in SVD.\n');
    error=3;
    phi=0.0; theta=0.0; psi=0.0; trans=[0.0; 0.0; 0.0];
    elapsed_ransac = 0.0;
    elapsed_svd = 0.0;
    %elapsed_icp = 0.0;
    %match_num = [pnum; gc_num; op_num];
    elapsed = [elapsed_pre; elapsed_sift; elapsed_pre2; elapsed_sift2; elapsed_match; elapsed_ransac; elapsed_svd; elapsed_icp(5)];
    feature_points = [];
    pose_std = [0.0; 0.0; 0.0; 0.0; 0.0; 0.0];
    return;
elseif sta_icp == 2
    fprintf('Points are in co-planar.\n');
    error=4;
    phi=0.0; theta=0.0; psi=0.0; trans=[0.0; 0.0; 0.0];
    elapsed_ransac = 0.0;
    elapsed_svd = 0.0;
    %elapsed_icp = 0.0;
    %match_num = [pnum; gc_num; op_num];
    elapsed = [elapsed_pre; elapsed_sift; elapsed_pre2; elapsed_sift2; elapsed_match; elapsed_ransac; elapsed_svd; elapsed_icp(5)];
    feature_points = [];
    pose_std = [0.0; 0.0; 0.0; 0.0; 0.0; 0.0];
    return; 
end

%elapsed_icp = toc(t_icp);

elapsed = [elapsed_pre; elapsed_sift; elapsed_pre2; elapsed_sift2; elapsed_match; elapsed_ransac; elapsed_svd; elapsed_icp(5)];

%rot = rot_icp;
% [rmse_feature rmse_icp]
% [theta*180/pi theta_icp*180/pi]
% [trans(1) trans_icp(1)]
%if rmse_icp <= rmse_feature
    trans = trans_icp;
    phi = phi_icp;
    theta = theta_icp;
    psi = psi_icp;
%end

%convert degree
% r2d=180.0/pi;
% phi=phi*r2d;
% theta=theta*r2d;
% psi=psi*r2d;
%trans';
end
