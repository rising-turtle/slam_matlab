% 
% new T-bar on the robocane for data collection 
% find the initial transformation from world coordinate to camera
% coordinate,                                        z
% the result shows that                             /   
% T pattern, find matched points                   /   
%   x ---|---    5  1  4                          /-----> x 
%        |          2                             |
%       z|          3                             | y
%   p1 (0, 0, 0)                                  |                          
%   p2 (0, 0, -0.0838)
%   p3 (0, 0, -0.1681)
%   p4 (0.127, 0, 0) 
%   p5 (-0.134, 0, 0)
% Author : David Zhang (hxzhang1@ualr.edu)
% Date : Jan. 30 2018

% from led to the front plate of sr4k, consider Tplate_cam later
% z axis offset 22.5 mm
% y axis offset 10.5 mm + (height=65/2) = 10.5 + 32.5 = 43 mm

function [rot, trans] = compute_initial_Tnew(p_world)
if nargin == 0
    p_world = [1.6982 0.6840 2.4577; 
               1.6432 0.7339 2.4971; 
               1.5857 0.7820 2.5376;
               1.7844 0.7082 2.5511;
               1.6088 0.6648 2.3616];
    
end
   z_shift = 0; 
   y_shift = 0; 
   
   %% for different cases, have to pay attention which case fit, by checking that whether the result of 
   % generate_gt_wpattern_syn_zh consistent in plot_gt_and_estimate 
   
   %% case 1
   p_local = [0 0 0; 0 0 -0.0838; 0 0 -0.1681; 0.127, 0, 0; -0.134, 0, 0];
   
   %% case 2
  % p_local = [0 0 0; 0 0 -0.0838; 0 0 -0.1681; 0.1302 0 0; -0.1317 0 0 ];
   
   p_local = p_local + repmat([0 y_shift z_shift], 5, 1);
   
   %% compute the transfrom,  pl = Tlc * pc, Tlc = find_transform_matrix(pl, pc); 
 
   [rot, trans, sta] = find_transform_matrix(p_local', p_world'); 
   
   % [rot, trans] = eq_point(p_local', p_world');
  
   tmp_p_l =  rot * p_world' + repmat(trans, 1, 5);
  
   
   
   
end


function compute_initial_five_pts()
path_dir = '.';
addpath(strcat(path_dir, '\Localization'));
addpath(strcat(path_dir, '\slamtoolbox\slamToolbox_11_09_08\FrameTransforms\Rotations'));

%% Load motion capture data
data_file_name = '.\motion_capture_data\test_10_16_2015\Take 2015-10-16 04.49.46 PM.csv';

%% open and load the data 
fid = fopen(data_file_name);
if fid < 0
    error(['Cannot open file ' data_file_name]);
end

[line_data, gt, gt_total] = scan_data (fid); % retrive data from file
 
%% T pattern, find matched points 
%    ---|---  4/5  1  5/4
%       |          2
%       |          3

% find the T pattern in each frame, and find 5 matched points
[ gt_total_pair ] = find_pair_tp( gt_total );
[ gt_total_pair(:,11:16)] = find_pair_nn( gt_total_pair(:,11:16));

rel_dis = compute_relative_dis(gt_total_pair(:, 2:16));
plot_gt_pairs(gt_total_pair); 
end

function [rel_dis] = compute_relative_dis(pts)
    pt_1 = pts(:, 1:3);  pt_2 = pts(:, 4:6); pt_3 = pts(:, 7:9); 
    pt_4 = pts(:, 10:12); pt_5 = pts(:, 13:15); 
    pt_0 = pt_1; 
    
    pt_1 = pt_1 - pt_0; pt_2 = pt_2 - pt_0; pt_3 = pt_3 - pt_0; 
    pt_4 = pt_4 - pt_0; pt_5 = pt_5 - pt_0; 
    
    d1 = sqrt(diag(pt_1*pt_1'));
    d2 = sqrt(diag(pt_2*pt_2'));
    d3 = sqrt(diag(pt_3*pt_3'));
    d4 = sqrt(diag(pt_4*pt_4'));
    d5 = sqrt(diag(pt_5*pt_5')); 
    rel_dis = [d1 d2 d3 d4 d5];
end

function plot_gt_pairs(gt_total_pair)
%% show ground truth by pairs
plot_colors={'b.','r.','g.','y.','c.'};
figure;
%plot_colors={'b.-','r.-','g.-','m.-','c.-'};
for i=1:5
    plot3(gt_total_pair(:,2+3*(i-1)),gt_total_pair(:,3+3*(i-1)),gt_total_pair(:,4+3*(i-1)),plot_colors{i});
    hold on;
end
plot3(gt_total_pair(1,2),gt_total_pair(1,3),gt_total_pair(1,4),'g*', 'MarkerSize', 10);
hold off;
axis equal;
grid;
xlabel('X');ylabel('Y');zlabel('Z');
title('GT pairs');
end
