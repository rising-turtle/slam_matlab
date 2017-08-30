% Calculate the euler angle(yaw, pitch, roll) from rotation matrix
%
% Yaw is a counterclockwise rotation of phi(alpha) about the z-axis
% Pitch is a counterclockwise rotation of theta(beta) about the y-axis
% Roll is a counterclockwise rotation of psi(gamma) about the x-axis
%
% Author : Soonhac Hong (sxhong1@ualr.edu)
% Date : 3/19/2011
% Reference : S.M. Lavalle : Planning Algorithm (p.97-100)

function [phi, theta, psi] = rot_to_euler(rot)
%      phi= atan2(rot(2,1), rot(1,1));
%      theta = atan2(-rot(3,1), sqrt(rot(3,2)^2+rot(3,3)^2));
%      psi = atan2(rot(3,2), rot(3,3));
%      psi= atan2(rot(2,1), rot(1,1));
%      phi = atan2(-rot(3,1), sqrt(rot(3,2)^2+rot(3,3)^2));
%      theta = atan2(rot(3,2), rot(3,3));
     
     
    
    % Original code from Dr. Ye
 psi = atan2(-rot(1,2), rot(2, 2));  % yaw about z --->this code is right, but the thesis is wrong.
 theta = atan2(rot(3,2), -rot(1,2)*sin(psi)+rot(2,2)*cos(psi)); % pitch about x
 phi = atan2(rot(1,3)*cos(psi)+rot(2,3)*sin(psi),rot(1,1)*cos(psi)+rot(2,1)*sin(psi)); % roll about y
end



