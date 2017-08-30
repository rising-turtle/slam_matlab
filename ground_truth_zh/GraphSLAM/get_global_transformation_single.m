% Get global transformation for each data set with the first frame
%
% Author : Soonhac Hong (sxhong1@uarl.edu)
% Date : 3/27/14

function [h_global] = get_global_transformation_single(data_name)

addpath('D:\Soonhac\SW\slamtoolbox\slamToolbox_11_09_08\FrameTransforms\Rotations');

% rx, ry, rz : [degree]
% tx, ty, tz : [mm]
rx=0;  ry=0;   rz=0;  tx=0;  ty=0;  tz=0;
 
euler=plane_fit_to_data_single(data_name);
rx=euler(1);
ry=euler(2);
rz=euler(3);

h_global = [euler_to_rot(rz, rx, ry) [tx ty tz]'; 0 0 0 1];
end