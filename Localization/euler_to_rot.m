function [rot] = euler_to_rot(phi, theta, psi)
% rot = rot_z * rot_x * rot_y

d2r=pi/180.0;
phi=phi*d2r;    theta=theta*d2r;    psi=psi*d2r;
rot=[cos(psi)*cos(phi)-sin(psi)*sin(theta)*sin(phi) -sin(psi)*cos(theta) cos(psi)*sin(phi)+sin(psi)*sin(theta)*cos(phi);
     sin(psi)*cos(phi)+cos(psi)*sin(theta)*sin(phi) cos(psi)*cos(theta)  sin(psi)*sin(phi)-cos(psi)*sin(theta)*cos(phi);
     -cos(theta)*sin(phi)                           sin(theta)           cos(theta)*cos(phi)                             ];
