function  find_orien_gt()
% Oct. 7 2018, He Zhang, hzhang8@vcu.edu
% read points tracked by motion capture and estimate the square model in
%   the camera coordinate system, 
%   then compute the normal of the torsor 

M = csvread('gt_seq_07.csv');

vt = M(:,1); 
pts_T = M(:,2:13);
pts_S = M(:,14:25); 

mean_pts_T = mean(pts_T); 

T_T2w = compute_transform(mean_pts_T); 
T_c2T = [1 0 0 -0.055; 
         0 1 0 -0.05; 
         0 0 1 -0.0075; 
         0 0 0 1;];
T_c2w = T_c2T * T_T2w; 

[vyaw, vpos] = compute_yaw_and_pos(pts_S, T_c2w); 


D = [vt vyaw vpos];
dlmwrite('gt_orien_07.log', D, 'delimiter', '\t');

end

%% compute yaw 
function [vyaw, vpos] = compute_yaw_and_pos(pts_S, T_c2w)

[row, col] = size(pts_S); 
N = row*col; 
pts_S = reshape(pts_S', [1, N]); 
ps = reshape(pts_S, [3, N/3]); 

[R, t] = decompose(T_c2w);
ps = R * ps + repmat(t, 1, N/3); 

vyaw = zeros(row, 1); 
vpos = zeros(row, 3); 

%% compute norm
j = 1;
for i = 1:4:size(ps, 2)
    psi = ps(:,i:i+3); 
    ni = compute_normal(psi);
    central_pt = mean(psi,2); 
    vyaw(j) = compute_yaw_norm(ni);
    vpos(j, :) = central_pt';
    j = j + 1;
end

end

%% compute yaw
function yaw = compute_yaw_norm(n)
    yaw = asin(n(1)/sqrt(n(1)*n(1)+n(3)*n(3))) * 180. /pi;
end

%% compute normal 
function n = compute_normal(pts)
    
    mean_pt = mean(pts, 2); 
    pts = pts - mean_pt; 
    Cov = pts*pts'; 
    [V,D] = eig(Cov); 
    n = V(:,1); 
    if n(3) > 0
        n= n * -1.;
    end
end

%% estimate 
function T = compute_transform(p_w)

% T pattern 
% 

p_world = reshape(p_w, [3, 4]);

p_local = [0, 0, -0.04;
           0.03, 0, 0; 
           0, 0, 0; 
           -0.06, 0, 0];

[rot, trans] = find_transform_matrix( p_local', p_world); 

tmp_p_l = rot * p_world + repmat(trans, 1, 4); 

T = combine(rot, trans); 

end 

function [T] = combine(R, t)
    T = [R t; 0 0 0 1];
end

function [R, t] = decompose(T)
    R = T(1:3, 1:3); 
    t = T(1:3, 4);
end