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
% Date : 3/10/11
% localization_sift_ransac_limit + covariance
% No bad pixel compensation

function [phi, theta, psi, trans, error, elapsed, match_num, feature_points, pose_std] = localization_sift_ransac_limit_cov_fast_fast_dist2_nobpc_sr(image_name, data_name, filter_name, boarder_cut_off, ransac_iteration_limit, valid_ransac, scale, value_type, dm, inc, j, sframe, sequence_data, is_10M_data, dis)

if nargin < 15
    dis = 0;
end

%Initilize parameters
error = 0;
sift_threshold = 0; 
%t = clock;

%Read first data set
%if strcmp(data_name, 'm') || strcmp(data_name, 'etas') || strcmp(data_name, 'loops') || strcmp(data_name, 'kinect_tum') || strcmp(data_name, 'loops2') || strcmp(data_name, 'sparse_feature') || strcmp(data_name, 'swing') % Dynamic data
if sequence_data == true
    cframe = sframe;
else
    cframe = j;
end
first_cframe = cframe;

%if check_stored_visual_feature(data_name, dm, cframe, sequence_data, image_name) == 0
    
    if strcmp(data_name, 'kinect_tum')
        %[img1, x1, y1, z1, elapsed_pre] = LoadKinect(dm, cframe);
        [img1, x1, y1, z1, elapsed_pre, time_stamp1] = LoadKinect_depthbased(dm, cframe);
    else
        [img1, x1, y1, z1, c1, elapsed_pre] = LoadSR_no_bpc_wu(data_name, filter_name, boarder_cut_off, dm, cframe, scale, value_type);
        %[img1,x1, y1, z1, cor_i1, cor_j1] = load_creative(dm, cframe);%% modify for read data from creative !!!
        
        %[img1,x1, y1, z1] = load_argos3d(dm, cframe);
        
        elapsed_pre=0;
    end
    
    if strcmp(image_name, 'depth') %image_name == 'depth'
        %Assign depth image to img1
        img1 = scale_img(z1, 1, value_type,'range');
    end
    
    if dis == 1 %CHANGE BY WEI FROM 1 TO 0
        f1 = figure(4);
        imagesc(img1); 
        colormap(gray); 
        title(['frame ', int2str(j)]);
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
        else
            [frm1, des1] = sift(img1, 'threshold', sift_threshold);
        end
        %elapsed_sift = etime(clock,t_sift);
        elapsed_sift = toc(t_sift);
    end
    
    % confidence filtering
    [frm1, des1] = confidence_filtering(frm1, des1, c1);
    %save_visual_features(data_name, dm, cframe, frm1, des1, elapsed_sift, img1, x1, y1, z1, c1, elapsed_pre, sequence_data, image_name);
    
% else
%     [frm1, des1, elapsed_sift, img1, x1, y1, z1, c1, elapsed_pre] = load_visual_features(data_name, dm, cframe, sequence_data, image_name);
% end

%Read second Data set
%if strcmp(data_name, 'm') || strcmp(data_name, 'etas') || strcmp(data_name, 'loops') || strcmp(data_name, 'kinect_tum') || strcmp(data_name, 'loops2') || strcmp(data_name, 'sparse_feature') || strcmp(data_name, 'swing') % Dynamic data
if sequence_data == true
    %cframe = j + sframe;
    %cframe = sframe+1;
    cframe = sframe + j;   % Generate constraints
else
    dm=dm+inc;
    cframe = j;
end
second_cframe = cframe;

%if check_stored_visual_feature(data_name, dm, cframe, sequence_data, image_name) == 0
    
    if strcmp(data_name, 'kinect_tum')
        %[img2, x2, y2, z2, elapsed_pre2] = LoadKinect(dm, cframe);
        [img2, x2, y2, z2, elapsed_pre2, time_stamp2] = LoadKinect_depthbased(dm, cframe);
    else
        [img2, x2, y2, z2, c2, elapsed_pre2] = LoadSR_no_bpc_wu(data_name, filter_name, boarder_cut_off, dm, cframe, scale, value_type);
        %[img2,x2, y2, z2, cor_i2, cor_j2] = load_creative(dm, cframe);
        
        %[img2,x2, y2, z2] = load_argos3d(dm, cframe);
        elapsed_pre2=0;
        %% modify for read data from creative !!!
    end
    if strcmp(image_name, 'depth') %image_name == 'depth'
        %Assign depth image to img1
        img2 = scale_img(z2, 1, value_type, 'range');
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
        else
            [frm2, des2] = sift(img2,'threshold', sift_threshold);
        end
        %elapsed_sift2 = etime(clock,t_sift);
        elapsed_sift2 = toc(t_sift2);
    end
    
    % confidence filtering
    [frm2, des2] = confidence_filtering(frm2, des2, c2);
    
%     save_visual_features(data_name, dm, cframe, frm2, des2, elapsed_sift2, img2, x2, y2, z2, c2, elapsed_pre2, sequence_data, image_name);
%     
% else
%     [frm2, des2, elapsed_sift2, img2, x2, y2, z2, c2, elapsed_pre2] = load_visual_features(data_name, dm, cframe, sequence_data, image_name);
% end


%if check_stored_matched_points(data_name, dm, first_cframe, second_cframe, 'none', sequence_data) == 0
    
    %t_match = clock;
    t_match = tic;
    match = siftmatch(des1, des2);
    %elapsed_match = etime(clock,t_match);
    elapsed_match = toc(t_match);
    
    if dis == 1 %changed from 1 to 0 by wei
        f3=figure(6);
        plotmatches(img1,img2,frm1,frm2,match); title('Match of SIFT');
%         f4=figure(7);
%         imshow(match);
    end
    
    
    % distance filtering
%     if is_10M_data == 1
%         valid_dist_max = 8;  % 5m
%     else
%         valid_dist_max = 5;  % 5m
%     end
%     valid_dist_min = 0.8; % 0.8m
    
    %%debugging
%     figure;
%     imshow(img1);
%     figure;
%     z1_dis=z1;
%     z1_dis_max=max(max(z1));
%     idx=find(z1==z1_dis_max);
%     z1_dis(idx)=0;
%     imshow(z1_dis, [0 255]);


    valid_dist_max =1.5; % [m]
    valid_dist_min =0.15; % [m]
    
    match_new = [];
    match_image1=[];
    match_image2=[];
    match_depth1=[];
    match_depth2=[];
    cnt_new = 1;
    pnum = size(match, 2);
    intensity_threshold = 0;
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
            

              %mapped cor_j1 is 320*240 matrix, then know the row and col
              %of matched point
              %[row1,col1]=Search_RowandCol(cor_j1,ROW1,cor_i1,COL1);            
              %[row2,col2]=Search_RowandCol(cor_j2,ROW2,cor_i2,COL2);
              % if col1~=0&&row1~=0&&col2~=0&&row2~=0
              % temp_pt1=[-x1(row1, col1), z1(row1, col1), y1(row1, col1)];
              % temp_pt2=[-x2(row2, col2), z2(row2, col2), y2(row2, col2)];
              % temp_pt1_dist = sqrt(sum(temp_pt1.^2));
              % temp_pt2_dist = sqrt(sum(temp_pt2.^2));
              %%%%%above comment for creative

               temp_pt1=[-x1(ROW1, COL1), z1(ROW1, COL1), y1(ROW1, COL1)];
               temp_pt2=[-x2(ROW2, COL2), z2(ROW2, COL2), y2(ROW2, COL2)];
               temp_pt2_dist = sqrt(sum(temp_pt2.^2));
               temp_pt1_dist = sqrt(sum(temp_pt1.^2));
               
            if temp_pt1_dist >= valid_dist_min && temp_pt1_dist <= valid_dist_max && temp_pt2_dist >= valid_dist_min && temp_pt2_dist <= valid_dist_max
            %if img1(ROW1, COL1) >= intensity_threshold && img2(ROW2, COL2) >= intensity_threshold
                match_new(:,cnt_new) = match(:,i);
               % match_image1(:,cnt_new)=[ROW1 COL1]';
               % match_image2(:,cnt_new)=[ROW2 COL2]';
               % match_depth1(:,cnt_new)=[ROW1 COL1]';
               % match_depth2(:,cnt_new)=[ROW2 COL2]';
                cnt_new = cnt_new + 1;
            end
            end
       
    end
    match = match_new;
    
    %find the matched two point sets.
    %match = [4 6 21 18; 3 7 19 21];
    
    pnum = size(match, 2);
    if pnum <= 12 % 39
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
                %[n_match, rs_match, cnum] = ransac(frm1, frm2, match, x1, y1, z1, x2, y2, z2, data_name);
                [n_match, rs_match, cnum] = ransac_argos3d(frm1, frm2, match, x1, y1, z1, x2, y2, z2, data_name);
               
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
            ransac_error = 0;
            max_iteration = 120000;
            while eta > eta_0
                %         t_ransac_internal = clock; %cputime;
                i = i+1;
                %[n_match, rs_match, cnum] = ransac(frm1, frm2, match, x1, y1, z1, x2, y2, z2, data_name);
                % [n_match, rs_match, cnum] = ransac_creative(frm1, frm2, match, x1, y1, z1, x2, y2, z2,cor_i1,cor_j1,cor_i2,cor_j2, data_name);
                 %[n_match, rs_match, cnum] = ransac_creative(frm1, frm2, match, x1, y1, z1, x2, y2, z2,match_image1,match_image2,match_depth1,match_depth2, data_name);
                 [n_match, rs_match, cnum] = ransac(frm1, frm2, match, x1, y1, z1, x2, y2, z2, data_name);
                 %       [n_match, rs_match, cnum] = ransac_3point(frm1, frm2, match, x1, y1, z1, x2, y2, z2);
                %ct_internal = cputime - t_ransac_internal;
                %         ct_internal = etime(clock, t_ransac_internal);
                for k=1:cnum
                    tmp_nmatch(:,k,i) = n_match(:,k);
                end
                tmp_rsmatch(:, :, i) = rs_match;      tmp_cnum(i) = cnum;
                
                cnum
                if cnum ~= 0
                    cur_p = cnum/pnum;
                    eta = (1-cur_p^4)^i
                end
                
                if i > max_iteration
                    ransac_error = 1;
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
    %        f6=figure(9); plotmatches_multi(img1,img2,frm1,frm2,op_match,match); title('Match after SIFT');
        end
        %elapsed_ransac = etime(clock, t_ransac); %cputime - t_ransac;
        elapsed_ransac = toc(t_ransac);
        match_num = [pnum; op_num];
    end
    
    %t_svd = clock;
    t_svd = tic;
    op_pset_cnt = 1;
    for i=1:op_num
        frm1_index=op_match(1, i);      frm2_index=op_match(2, i);
        matched_pix1=frm1(:, frm1_index);     COL1=round(matched_pix1(1))+1;     ROW1=round(matched_pix1(2))+1;
        matched_pix2=frm2(:, frm2_index);     COL2=round(matched_pix2(1))+1;     ROW2=round(matched_pix2(2))+1;
        op_pset1_image_index(i,:) = [matched_pix1(1), matched_pix1(2)]; %[COL1, ROW1];
        op_pset2_image_index(i,:) = [matched_pix2(1), matched_pix2(2)]; %[COL2, ROW2];
        if strcmp(data_name, 'kinect_tum')
            %op_pset1(1,op_pset_cnt)=x1(ROW1, COL1);   op_pset1(2,op_pset_cnt)=z1(ROW1, COL1);   op_pset1(3,op_pset_cnt)=-y1(ROW1, COL1);
            %op_pset2(1,op_pset_cnt)=x2(ROW2, COL2);   op_pset2(2,op_pset_cnt)=z2(ROW2, COL2);   op_pset2(3,op_pset_cnt)=-y2(ROW2, COL2);
            op_pset1(1,op_pset_cnt)=x1(ROW1, COL1);   op_pset1(2,op_pset_cnt)=y1(ROW1, COL1);   op_pset1(3,op_pset_cnt)=z1(ROW1, COL1);
            op_pset2(1,op_pset_cnt)=x2(ROW2, COL2);   op_pset2(2,op_pset_cnt)=y2(ROW2, COL2);   op_pset2(3,op_pset_cnt)=z2(ROW2, COL2);
            op_pset_cnt = op_pset_cnt + 1;
        else
            %if img1(ROW1, COL1) >= 100 && img2(ROW2, COL2) >= 100
%               [row1,col1]=Search_RowandCol(cor_j1,ROW1,cor_i1,COL1);
%               [row2,col2]=Search_RowandCol(cor_j2,ROW2,cor_i2,COL2);
%             if col1~=0&&row1~=0&&col2~=0&&row2~=0
%               [row1,col1]=match_rowandcol(match_image1,match_depth1,ROW1,COL1);
              %[row1,col1]=match_rowandcol(match_image1,match_depth1,ROW1,COL1);
             % [row2,col2]=match_rowandcol(match_image2,match_depth2,ROW2,COL2);
             op_pset1(1,op_pset_cnt)=-x1(ROW1, COL1);   op_pset1(2,op_pset_cnt)=z1(ROW1, COL1);   op_pset1(3,op_pset_cnt)=y1(ROW1, COL1);
             op_pset2(1,op_pset_cnt)=-x2(ROW2, COL2);   op_pset2(2,op_pset_cnt)=z2(ROW2, COL2);   op_pset2(3,op_pset_cnt)=y2(ROW2, COL2);
             op_pset_cnt = op_pset_cnt + 1;  %changed by wu 
            %end
%             end
            %% Modify coordinate according to Creative !! done
            
        end
        %     op_pset1(1,i)=x1(ROW1, COL1);   op_pset1(2,i)=y1(ROW1, COL1);   op_pset1(3,i)=z1(ROW1, COL1);
        %     op_pset2(1,i)=x2(ROW2, COL2);   op_pset2(2,i)=y2(ROW2, COL2);   op_pset2(3,i)=z2(ROW2, COL2);
    end
    
    
%     save_matched_points(data_name, dm, first_cframe, second_cframe, match_num, ransac_iteration, op_pset1_image_index, op_pset2_image_index, op_pset_cnt, elapsed_match, elapsed_ransac, op_pset1, op_pset2, 'none', sequence_data);
%     
% else
%     [match_num, ransac_iteration, op_pset1_image_index, op_pset2_image_index, op_pset_cnt, elapsed_match, elapsed_ransac, op_pset1, op_pset2] = load_matched_points(data_name, dm, first_cframe, second_cframe, 'none', sequence_data);
%     t_svd = tic;
% end

%[op_pset1, op_pset2, op_pset_cnt, op_pset1_image_index, op_pset2_image_index] = check_feature_distance(op_pset1, op_pset2, op_pset_cnt, op_pset1_image_index, op_pset2_image_index);

[rot, trans, sta] = find_transform_matrix(op_pset1, op_pset2);
[phi, theta, psi] = rot_to_euler(rot); 
%elapsed_svd = etime(clock, t_svd);
elapsed_svd = toc(t_svd);

%Check status of SVD
if sta <= 0    % No Solution
    fprintf('no solution in SVD.\n');
    error=3;
    phi=0.0; theta=0.0; psi=0.0; trans=[0.0; 0.0; 0.0];
    elapsed_ransac = 0.0;
    elapsed_svd = 0.0;
    %elapsed_icp = 0.0;
    %match_num = [pnum; gc_num; op_num];
    elapsed = [elapsed_pre; elapsed_sift; elapsed_pre2; elapsed_sift2; elapsed_match; elapsed_ransac; elapsed_svd; ransac_iteration];
    feature_points = [];
    pose_std = [0.0; 0.0; 0.0; 0.0; 0.0; 0.0];
    return;
elseif sta == 2
    fprintf('Points are in co-planar.\n');
    error=4;
    phi=0.0; theta=0.0; psi=0.0; trans=[0.0; 0.0; 0.0];
    elapsed_ransac = 0.0;
    elapsed_svd = 0.0;
    %elapsed_icp = 0.0;
    %match_num = [pnum; gc_num; op_num];
    elapsed = [elapsed_pre; elapsed_sift; elapsed_pre2; elapsed_sift2; elapsed_match; elapsed_ransac; elapsed_svd; ransac_iteration];
    feature_points = [];
    pose_std = [0.0; 0.0; 0.0; 0.0; 0.0; 0.0];
    return; 
end




% Save feature points
%feature_points_1 =[repmat(1,[op_num 1]) op_pset1'];
%feature_points_2 =[repmat(2,[op_num 1]) op_pset2'];
feature_points_1 =[repmat(1,[op_pset_cnt-1 1]) op_pset1' op_pset1_image_index];
feature_points_2 =[repmat(2,[op_pset_cnt-1 1]) op_pset2' op_pset2_image_index];
feature_points = [feature_points_1; feature_points_2];
    
%Compute the elapsed time
%rt_total = etime(clock,t);
if strcmp(data_name, 'kinect_tum')
    elapsed = [elapsed_pre; elapsed_sift; elapsed_pre2; elapsed_sift2; elapsed_match; elapsed_ransac; time_stamp1; ransac_iteration];
else
   elapsed = [elapsed_pre; elapsed_sift; elapsed_pre2; elapsed_sift2; elapsed_match; elapsed_ransac; elapsed_svd; ransac_iteration];
end

%Compute covariane
% if check_stored_pose_std(data_name, dm, first_cframe, second_cframe, 'none', sequence_data) == 0

    [pose_std] = compute_pose_std(op_pset1,op_pset2, rot, trans);
    pose_std = pose_std';
    
%   %  save_pose_std(data_name, dm, first_cframe, second_cframe, pose_std, 'none', sequence_data);
%  else
%     [pose_std] = load_pose_std(data_name, dm, first_cframe, second_cframe, 'none', sequence_data);
%  end


%convert degree
%r2d=180.0/pi;
%phi=phi*r2d;
%theta=theta*r2d;
%psi=psi*r2d;
%trans';
end
