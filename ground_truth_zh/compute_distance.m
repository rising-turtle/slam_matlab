%% compute sum of mutual distance between all points
function [sum_dis] = compute_distance(pts)
    [row, col] = size(pts); 
    global g_TN;
    sum_dis = zeros(row, col/3); 
    
    for i=1:row
        pt_dis = zeros(1, g_TN); 
        for m=1:g_TN
            pt = pts(i, (m-1)*3+1:(m*3));
            dis_m = 0; % sum of point i to all other points
            for n =1:g_TN
                pt_j = pts(i, (n-1)*3+1:(n*3));
                d_pt = pt_j - pt;
                dis_m = dis_m + sqrt(sum(d_pt.*d_pt));
            end
            pt_dis(1, m) = dis_m;
        end
        sorted_dis = sort(pt_dis);
        sum_dis(i,:) = sorted_dis; 
    end
end
