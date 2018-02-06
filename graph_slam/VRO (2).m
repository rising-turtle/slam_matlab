function [t, pose_std, e] = VRO(id1, id2, img1, img2, des1, frm1, p1, des2, frm2, p2)
%
% March 3th, 2015, David Z
% match two images and return the transformation between img1 and img2 
% t : [ phi, theta, psi, trans]; 
% pose_std: pose covariance 
% e : error
%

%% extract features, match img1 to img2 
if ~exist('des1','var')
    [frm1, des1] = sift(img1);
end
if ~exist('des2','var')
    [frm2, des2] = sift(img2);
end

%% pose covariance
pose_std = []; 

if file_exist(id1, id2) ~= 0 %% match points stored in a middle file
    [op_match, e] = load_matched_points_zh(id1, id2);
    if e > 0
       [t,e] = error_exist('ransac filter failed!', 2);
       return ;
    end
else
    %% if save the intermiddle data, do it 
global g_save_feature_for_debug
    if g_save_feature_for_debug
        ftar_name = sprintf('tar_nodes/node_%d.log', id1);
        fsrc_name = sprintf('src_nodes/node_%d.log', id2);
        save_feature(ftar_name, des1, frm1, p1, id1); 
        save_feature(fsrc_name, des2, frm2, p2, id2);
    end
    
    %% first, sift feature match
    match = siftmatch(des1, des2, 2.);
    % fprintf('VRO.m after siftmatch, matched num: %d\n',size(match,2));
    
    %% valid depth filter match correspondences
    global g_depth_filter_max g_minimum_ransac_num
    match = depth_filter(match, g_depth_filter_max, 0, frm1, frm2, p1, p2);
    % fprintf('VRO.m after depth_filter, matched num: %d\n',size(match,2));
    
    pnum = size(match,2); % pnum: matched feature pairs
    if pnum <= g_minimum_ransac_num
        [t,e] = error_exist('too few valid sift points for ransac!', 1);
        return;
    end
    
    %% second, ransac to obtain the final transformation result
    [op_match, e] = ransac_filter(match, frm1, frm2, p1, p2);
    % op_match = match;
    if e > 0
        [t,e] = error_exist('ransac filter failed!', 2);
        save_matched_points_zh(id1, id2, op_match, e);
        return ;
    end
    %% save the match points 
    global g_save_vro_middle_result
    if g_save_vro_middle_result
        save_matched_points_zh(id1, id2, op_match);
    end
end
%% lastly, SVD to compute the transformation 
[t, pose_std, e] = svd_transformation(op_match, frm1, frm2, p1, p2); 

end

%% SVD transformation 
function [t, pose_std, e] = svd_transformation(op_match, frm1, frm2, p1, p2)
  e = 0; 
  op_num = size(op_match, 2); 
  op_pset_cnt = 1; 
  x1 = p1(:,:,1); y1 = p1(:,:,2); z1 = p1(:,:,3); 
  x2 = p2(:,:,1); y2 = p2(:,:,2); z2 = p2(:,:,3);
  for i=1:op_num
      frm1_index=op_match(1, i);      frm2_index=op_match(2, i);
      matched_pix1=frm1(:, frm1_index);  COL1=round(matched_pix1(1))+1;     ROW1=round(matched_pix1(2))+1;
      matched_pix2=frm2(:, frm2_index);  COL2=round(matched_pix2(1))+1;     ROW2=round(matched_pix2(2))+1;
      op_pset1_image_index(i,:) = [matched_pix1(1), matched_pix1(2)]; %[COL1, ROW1];
      op_pset2_image_index(i,:) = [matched_pix2(1), matched_pix2(2)]; %[COL2, ROW2];
      op_pset1(1,op_pset_cnt)=-x1(ROW1, COL1);   op_pset1(2,op_pset_cnt)=z1(ROW1, COL1);   op_pset1(3,op_pset_cnt)=y1(ROW1, COL1);
      op_pset2(1,op_pset_cnt)=-x2(ROW2, COL2);   op_pset2(2,op_pset_cnt)=z2(ROW2, COL2);   op_pset2(3,op_pset_cnt)=y2(ROW2, COL2);
      op_pset_cnt = op_pset_cnt + 1;
  end

  %% SVD solve
  [rot, trans, sta] = find_transform_matrix_e6(op_pset1, op_pset2);
  [phi, theta, psi] = rot_to_euler(rot); 
  t = [ phi, theta, psi, trans']; 
  if sta <= 0
      [t,e] = error_exist('no solution in SVD.', 3);
  end
  
  %% compute pose convariance 
  [pose_std] = compute_pose_std(op_pset1,op_pset2, rot, trans);
  pose_std = pose_std';
  
end

%% delete the pairs that contain (0,0,0) points
function match = filter_zero_pairs(match, frm1, frm2, p1, p2)
    pnum = size(match, 2);
    r_match  = []; % return match
    x1 = p1(:,:,1); y1 = p1(:,:,2); z1 = p1(:,:,3); 
    x2 = p2(:,:,1); y2 = p2(:,:,2); z2 = p2(:,:,3);
    for i=1:pnum
        frm1_index=match(1, i);     frm2_index=match(2, i);
        matched_pix1=frm1(:, frm1_index);     COL1=round(matched_pix1(1))+1;     ROW1=round(matched_pix1(2))+1;
        matched_pix2=frm2(:, frm2_index);     COL2=round(matched_pix2(1))+1;     ROW2=round(matched_pix2(2))+1;
        
        p1x=-x1(ROW1, COL1);   p1z=z1(ROW1, COL1);   p1y=y1(ROW1, COL1);
        p2x=-x2(ROW2, COL2);   p2z=z2(ROW2, COL2);   p2y=y2(ROW2, COL2);
        %% deletet the zero pairs
        if (p1x + p1z + p1y == 0) || (p2x + p2y + p2z == 0) 
            continue;
        end
        r_match = [r_match match(:,i)];
    end
    match = r_match;
end



%% ransac transformation to get the result 
function [op_match, error] = ransac_filter(match, frm1, frm2, p1, p2)
global g_ransac_iteration_limit 

% pnum = size(match,2); % number of matched pairs 
error = 0; 
op_match = [];

%% delete the pairs that contain (0,0,0) points
match = filter_zero_pairs(match, frm1, frm2, p1, p2); 
pnum = size(match,2); % number of matched pairs 

%% ransac with a limited number 
if g_ransac_iteration_limit > 0 
    % rst = min(g_ransac_iteration_limit, nchoosek(pnum, 4)); % at least C_n^4 times
    rst = g_ransac_iteration_limit; 
    tmp_nmatch = zeros(2, pnum, rst);
    tmp_cnum = zeros(rst,1);
    for i=1:rst
        [n_match, rs_match, cnum, translation] = ransac(frm1, frm2, match, p1(:,:,1),...
            p1(:,:,2), p1(:,:,3), p2(:,:,1), p2(:,:,2), p2(:,:,3), 'SwissRange', i);
        % tmp_nmatch(:,1:cnum, i) = n_match(:,1:cnum);
        for k=1:cnum
            tmp_nmatch(:,k,i) = n_match(:,k);
        end
        tmp_cnum(i) = cnum;
        if cnum > 0
            fprintf('iteration %d inlier num: %d, translation %f %f %f\n', i, cnum, translation);
        end
    end
else 
    %Standard termination criterion
    inlier_ratio = 0.15;  % 14 percent
    i=0;
    eta_0 = 0.03;       % 97 percent confidence
    cur_p = 4 / pnum;
    eta = (1-cur_p^4)^i;
    max_iteration = 120000;
    while eta > eta_0
        i = i+1; 
        [n_match, rs_match, cnum] = ransac(frm1, frm2, match, p1(:,:,1),...
          p1(:,:,2), p1(:,:,3), p2(:,:,1), p2(:,:,2), p2(:,:,3), 'SwissRange');
      for k=1:cnum
          tmp_nmatch(:,k,i) = n_match(:,k);
      end
      %  tmp_nmatch(:,1:cnum,i) = n_match(:,1:cnum); 
        tmp_cnum(i) = cnum;
        if cnum > 0
            cur_p = cnum/pnum; 
            eta = (1-cur_p^4)^i;
        end
        if i > max_iteration
            error = 1;
            break;
        end
    end
    ransac_iteration = i;
end
   valid_ransac = 3; % this is the least valid number 
  [rs_max, rs_ind] = max(tmp_cnum);
  fprintf('select %d with matched num = %d\n', rs_ind, rs_max);
   op_num = tmp_cnum(rs_ind);
   if (op_num < valid_ransac || error > 0)
       error = 1;
       return;
   end
   
   %% optimal matched pair set 
   op_match(:, 1:op_num) = tmp_nmatch(:, 1:op_num, rs_ind); 
   
end

%% error exist 
function [t, e] = error_exist(msg_err, e_type)
    fprintf('VRO.m: %s\n', msg_err); 
    e = e_type; 
    t = zeros(1,6); 
end

%% using depth to filter the erroreous matches
% p1 [x1 y1 z1] p2 [x2 y2 z2]
% 
function match = depth_filter(m, max_d, min_d, frm1, frm2, p1, p2)
    match = []; 
    m_img1 = []; 
    m_img2 = []; 
    m_dpt1 = []; 
    m_dpt2 = [];
    cnt_new = 1; 
    pnum = size(m,2);
    for i=1:pnum
        frm1_index = m(1,i); frm2_index = m(2,i);
        m_pix1 = frm1(:, frm1_index); m_pix2 = frm2(:, frm2_index);
        COL1 = round(m_pix1(1))+1;  COL2 = round(m_pix2(1))+1;
        ROW1 = round(m_pix1(2))+1;  ROW2 = round(m_pix2(2))+1;
        %% ? row, col is right? 
        %% this match is a valid pair, this test is for Kinect
%         if z(ROW1, COL1) > min_d && z(ROW1, COL1) < max_d ...
%                 && z(ROW2, COL2) > min_d && z(ROW2, COL2) < max_d
%             ...
%         end
        temp_pt1=[-p1(ROW1, COL1, 1), p1(ROW1, COL1, 3), p1(ROW1, COL1, 2)];
        temp_pt2=[-p2(ROW2, COL2, 1), p2(ROW2, COL2, 3), p2(ROW2, COL2, 2)];
        temp_pt1_dist = sqrt(sum(temp_pt1.^2));
        temp_pt2_dist = sqrt(sum(temp_pt2.^2));
        if temp_pt1_dist >= min_d && temp_pt1_dist <= max_d ... 
                && temp_pt2_dist >= min_d && temp_pt2_dist <= max_d
                match(:,cnt_new) = m(:,i);
                cnt_new = cnt_new + 1;
        end 
    end
end

%% check weather this matched file exist 
function [exist_flag] = file_exist(id1, id2)
%% get file name  
global g_data_dir g_data_prefix g_matched_dir
file_name = sprintf('%s/%s/%s_%04d_%04d.mat', g_data_dir, g_matched_dir ...
    ,g_data_prefix, id1, id2); 
exist_flag = exist(file_name, 'file'); 
end

%% save feature in a style that can be loaded into vo in my sr_slam 
function save_feature(fname, des, frm, p, id)
    %% open file 
    fid = fopen(fname, 'w'); 
        
    %% save feature loaction, size, orientation 
    M = size(frm, 2); 
    fprintf(fid, '-1 -1 %d 1 0\n', id);
    fprintf(fid, '%d\n', M);
    
    %% sift 2d information 
    response = zeros(1, M);
    octave = zeros(1, M);
    class_id = ones(1, M).*-1;
    sift_loc_2d = [frm; response; octave; class_id]';
    fprintf(fid, '%f %f %f %f %f %d %d \n', sift_loc_2d'); 
    
    %% sift 3d location 
    sift_loc_3d = zeros(M, 4);
    for i=1:M
        m_pix = frm(:, i);
        COL = round(m_pix(1))+1;  
        ROW = round(m_pix(2))+1; 
        pt =[-p(ROW, COL, 1), p(ROW, COL, 3), p(ROW, COL, 2)];
        sift_loc_3d(i,1:3) = pt(1:3); sift_loc_3d(i,4) = 1;
    end
    fprintf(fid, '%f %f %f %f\n', sift_loc_3d');
    
    %% sift descriptors 
    D_SIZE = size(des, 1);
    fprintf(fid, '%d\n', D_SIZE); 
    for i=1:M
        for j=1:D_SIZE
            fprintf(fid, '%f ', des(j,i));
        end
        fprintf(fid, '\n');
    end
    
    fclose(fid); 
end



