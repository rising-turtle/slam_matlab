function [trans] = match_two_frames()

% Parameters :
% Dec. 22, 2014, David Z
% 
% match two Kinect frames using SIFT match 
%


%% Load two images 

i = 5;
target_image_index = 1;
source_image_index = 2;

[img1, x1, y1, z1] = LoadPrimesense_model(target_image_index, i);
[img2, x2, y2, z2] = LoadPrimesense_model(source_image_index, i);

%% Extract sift features 

[frm1, des1] = sift(img1);
[frm2, des2] = sift(img2);

%% Match the sift features 

match  = siftmatch(des1, des2); 
data_name = 'primesense';

%% valid depth filter match correspodences
    valid_dist_max = 1.400;  % [m]
    valid_dist_min = 0.150; % [m]
    
    match_new = [];
    match_image1=[];
    match_image2=[];
    match_depth1=[];
    match_depth2=[];
    cnt_new = 1;
    pnum = size(match, 2);
    intensity_threshold = 0;
    for i=1:pnum
        frm1_index=match(1, i);     frm2_index=match(2, i);
        matched_pix1=frm1(:, frm1_index);     COL1=round(matched_pix1(1))+1;     ROW1=round(matched_pix1(2))+1;
        matched_pix2=frm2(:, frm2_index);     COL2=round(matched_pix2(1))+1;     ROW2=round(matched_pix2(2))+1;
        if z1(ROW1, COL1) > valid_dist_min &&z1(ROW1, COL1)<valid_dist_max&& z2(ROW2, COL2) > valid_dist_min&&z2(ROW2, COL2)<valid_dist_max
            match_new(:,cnt_new) = match(:,i);
            cnt_new = cnt_new + 1;
        end
    end
    match = match_new;
    pnum = size(match, 2);
 
    %% RANSAC match the two descriptors
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
        [n_match, rs_match, cnum] = ransac_primesense(frm1, frm2, match, x1, y1, z1, x2, y2, z2, data_name);
        %       [n_match, rs_match, cnum] = ransac_3point(frm1, frm2, match, x1, y1, z1, x2, y2, z2);
        %ct_internal = cputime - t_ransac_internal;
        %         ct_internal = etime(clock, t_ransac_internal);
        for k=1:cnum
            tmp_nmatch(:,k,i) = n_match(:,k);
        end
        tmp_rsmatch(:, :, i) = rs_match;      tmp_cnum(i) = cnum;
        
        % cnum
        if cnum ~= 0
            cur_p = cnum/pnum;
            eta = (1-cur_p^4)^i;
        end
        
        if i > max_iteration
            ransac_error = 1;
            break;
        end
        %         debug_data(i,:)=[cnum, cur_p, eta, ct_internal];
    end
    ransac_iteration = i;
    [rs_max, rs_ind] = max(tmp_cnum);
    op_num = tmp_cnum(rs_ind);
    for k=1:op_num
        op_match(:, k) = tmp_nmatch(:, k, rs_ind);
    end
    match_num = [pnum; op_num];
    
   %% SVD decomposition 
    op_pset_cnt = 1;
    for i=1:op_num
        frm1_index=op_match(1, i);      frm2_index=op_match(2, i);
        matched_pix1=frm1(:, frm1_index);     COL1=round(matched_pix1(1))+1;     ROW1=round(matched_pix1(2))+1;
        matched_pix2=frm2(:, frm2_index);     COL2=round(matched_pix2(1))+1;     ROW2=round(matched_pix2(2))+1;
        op_pset1_image_index(i,:) = [matched_pix1(1), matched_pix1(2)]; %[COL1, ROW1];
        op_pset2_image_index(i,:) = [matched_pix2(1), matched_pix2(2)]; %[COL2, ROW2];
        if strcmp(data_name, 'primesense')
            %op_pset1(1,op_pset_cnt)=x1(ROW1, COL1);   op_pset1(2,op_pset_cnt)=z1(ROW1, COL1);   op_pset1(3,op_pset_cnt)=-y1(ROW1, COL1);
            %op_pset2(1,op_pset_cnt)=x2(ROW2, COL2);   op_pset2(2,op_pset_cnt)=z2(ROW2, COL2);   op_pset2(3,op_pset_cnt)=-y2(ROW2, COL2);
            op_pset1(1,op_pset_cnt)=x1(ROW1, COL1);   op_pset1(2,op_pset_cnt)=z1(ROW1, COL1);   op_pset1(3,op_pset_cnt)=-y1(ROW1, COL1);
            op_pset2(1,op_pset_cnt)=x2(ROW2, COL2);   op_pset2(2,op_pset_cnt)=z2(ROW2, COL2);   op_pset2(3,op_pset_cnt)=-y2(ROW2, COL2);
            op_pset_cnt = op_pset_cnt + 1;
        end
    end
    
    %% transformation 
    [rot, trans, sta] = find_transform_matrix(op_pset1, op_pset2);
    [phi, theta, psi] = rot_to_euler(rot); 
    
    %% Save feature points
    feature_points_1 =[repmat(1,[op_pset_cnt-1 1]) op_pset1' op_pset1_image_index];
    feature_points_2 =[repmat(2,[op_pset_cnt-1 1]) op_pset2' op_pset2_image_index];
    feature_points = [feature_points_1; feature_points_2];
       
end 
    
