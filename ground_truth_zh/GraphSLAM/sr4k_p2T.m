% Compute transfomation matrix from 6 parameters[x,y,z,rx,ry,rz]
%
% Author : Soonhac Hong (sxhong1@ualr.edu)
% Date : 3/15/13
% Note : This funcion is limited for only SR4000 convention.

function T = sr4k_p2T(x)

Rx = @(a)[1     0       0;
          0     cos(a)  -sin(a);
          0     sin(a)  cos(a)];
      
Ry = @(b)[cos(b)    0   sin(b);
          0         1   0;
          -sin(b)   0   cos(b)];
      
Rz = @(c)[cos(c)    -sin(c) 0;
          sin(c)    cos(c)  0;
          0         0       1];

Rot = @(x)Rz(x(3))*Rx(x(1))*Ry(x(2));  % SR4000 project; see euler_to_rot.m
T = [Rot(x(4:6)) [x(1), x(2), x(3)]'; 0 0 0 1];

end