% This function computes the pose of the sensor between two data set from
% SR400 using SIFT . The orignial function was vot.m in the ASEE/pitch_4_plot1.
% 
% Parameters : 
%   pt1 : point cloud of data set (n x m) n : data dimensionality
%   pt2 : point cloud of data set (n x m) n : data dimensionality
%   match : match index
%   dis : index to display logs and images [1 = display][0 = no display]
%
% Author : Soonhac Hong (sxhong1@ualr.edu)
% Date : 9/10/12

function [op_match, match_num, rtime, error] = run_ransac_points(pt1, pt2, match, dis)
error = 0;
pnum = size(match, 2);
ransac_error = 0;

if pnum<4
    fprintf('too few sift points for ransac.\n');
    op_num=0;
    op_match=0;
    rtime = 0;
    match_num = [pnum; op_num];
    error=1;
    return;
else
    t_ransac = tic;
    %Standard termination criterion 
    valid_ransac = 12; %inlier_ratio * pnum;
    i=0;
    eta_0 = 0.01;       % 99 percent confidence 
    cur_p = 4 / pnum;
    eta = (1-cur_p^4)^i;
    max_iteration = 120000;
    while eta > eta_0
        i = i+1;
        [n_match, rs_match, cnum] = ransac_gc(pt1, pt2);
        for k=1:cnum
            tmp_nmatch(:,k,i) = n_match(:,k);
        end
        tmp_rsmatch(:, :, i) = rs_match;      tmp_cnum(i) = cnum;
        
        if cnum ~= 0
            cur_p = cnum/pnum;
            eta = (1-cur_p^4)^i;
        end
        if i > max_iteration
            ransac_error = 1;
            break;
        end
    end
    
    [rs_max, rs_ind] = max(tmp_cnum);
    
    op_num = tmp_cnum(rs_ind);
    if(op_num<valid_ransac || ransac_error == 1)
        fprintf('no consensus found, ransac fails.\n');
        op_num=0;
        op_match=0;
        rtime = toc(t_ransac);
        match_num = [pnum; op_num];
        error=2;
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
    rtime = toc(t_ransac);
    match_num = [pnum; op_num];
end
end