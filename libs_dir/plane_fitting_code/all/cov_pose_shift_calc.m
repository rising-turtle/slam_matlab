function cov_pose_shift = cov_pose_shift_calc(Ya,Yb,R,T)
q_ab = R2q(R);
cov_pose_shift = zeros(7,7);
for i=1:size(Ya,2)
    f_p = Ya(:,i);
    f_n = Yb(:,i);
%     cov_f_p = calc_cov_point(f_p);
%     cov_f_n = calc_cov_point(f_n);
    d2E_dX2_value = d2E_dX2_4cov(f_p,f_n,q_ab,T);
    d2E_dFdX_value = [d2E_dfp_dX_4cov(f_p,f_n,q_ab,T)  d2E_dfn_dX_4cov(f_p,f_n,q_ab,T)];
    [cov_cart_f_p,tt,ttt] = calc_point_cov_jacobian(f_p);
    [cov_cart_f_n,tt,ttt] = calc_point_cov_jacobian(f_n);
    try
    J_X2F = -pinv(d2E_dX2_value)*d2E_dFdX_value;
    catch
        disp('J_X2F calculation failed ! \n')
    end
    
    cov_pose_shift = cov_pose_shift + J_X2F*blkdiag(cov_cart_f_p,cov_cart_f_n)*J_X2F';
    
    
end
end
function [cov_cart,J_sph2cart,cov_spher] = calc_point_cov_jacobian(point)

[azimuth,elevation,r] = cart2sph(point(1),point(2),point(3));
x = r .* cos(elevation) .* cos(azimuth);
y = r .* cos(elevation) .* sin(azimuth);
z = r .* sin(elevation);
%%% check correctness
if norm([x,y,z]-[point(1),point(2),point(3)])>0.000000001
    disp('ERROR OCCURRED IN SHP<-->CART CONVERISON')
end

J_sph2cart = [cos(elevation) * cos(azimuth)   -r * cos(elevation) * sin(azimuth)   -r * sin(elevation) * cos(azimuth);...
    cos(elevation) * sin(azimuth)     r * cos(elevation) * cos(azimuth)   -r * sin(elevation) * sin(azimuth);...
    sin(elevation)                   0                                    r .* cos(elevation)              ];
cov_spher = diag( [ (0.01/3)^2 , (0.24*pi/180/10)^2 .* [ 1 1 ] ]  );   %%% uncertaint of the range is 1cm and I assume the uncertsainty of the azimuth and elevation is equal

%%% to sensor's angular resolution (0.24 degrees)
cov_cart = J_sph2cart*cov_spher*J_sph2cart';
end