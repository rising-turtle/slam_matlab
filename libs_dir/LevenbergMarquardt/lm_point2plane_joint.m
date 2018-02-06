function [ R, T ] = lm_point2plane_joint( p_feature, q_feature, p_icp, q_icp )
% p is a 3xm matrix and q is a 3xn matrix.
% p_feature = T * q_feature;
% p_icp = T * q_icp;

p_icp_normal = lsqnormest(p_icp,4);
p_icp_length = size(p_icp,2);
p_feature_length = size(p_feature,2);

Rx = @(a)[1     0       0;
          0     cos(a)  -sin(a);
          0     sin(a)  cos(a)];
      
Ry = @(b)[cos(b)    0   sin(b);
          0         1   0;
          -sin(b)   0   cos(b)];
      
Rz = @(g)[cos(g)    -sin(g) 0;
          sin(g)    cos(g)  0;
          0         0       1];

%Rot = @(x)Rx(x(1))*Ry(x(2))*Rz(x(3));
Rot = @(x)Rz(x(3))*Rx(x(1))*Ry(x(2));  % SR4000 project; see euler_to_rot.m

myfun = @(x,xdata)(Rot(x(1:3))*xdata+repmat(x(4:6),1,length(xdata)))+((Rot(x(1:3))*xdata+repmat(x(4:6),1,length(xdata))).*p_icp_normal);


options = optimset('Algorithm', 'levenberg-marquardt');
%x = lsqcurvefit(myfun, zeros(6,1), p, q, [], [], options);

x = lsqcurvefit(myfun, zeros(6,1), q, (p.*p_normal), [], [], options);

R = Rot(x(1:3));
T = x(4:6);

end

