% 
% find the initial transformation from world coordinate to camera
% coordinate,                                    y    z
% the result shows that                          |  /   
% T pattern, find matched points                 | /   
%    ---|---  5/4  1  4/5                  x ----|/ 
%       |          2                             
%       |          3                         
%   p1 (0, 0, 0)                                                           
%   p2 (0, 0, -0.0838)
%   p3 (0, 0, -0.1681)
%   p4/5 (-0.1317, 0, 0) 
%   p5/4 (0.1302, 0, 0)
% Author : David Zhang (hxzhang1@ualr.edu)
% Date : 10/23/15

% from led to the front plate of sr4k 
% z axis offset 22.5 mm
% y axis offset 10.5 mm + (height=65/2) = 10.5 + 32.5 = 43 mm

function [rot, trans] = compute_initial_T(p_world)
if nargin == 0
    p_world = [3.2867 0.8038 -1.1012; 
               3.3616 0.8403 -1.0947; 
               3.4369 0.8772 -1.0855;
               3.2812 0.7928 -0.9697;
               3.2941 0.8155 -1.2305];
    
    p_world = [3.3603 0.7747 -1.0545; 
               3.4357 0.8076 -1.039; 
               3.511 0.8418 -1.0212;
               3.3872 0.7772 -1.182;
               3.3349 0.7741 -0.9254];
end
   z_shift = -0.0225; 
   y_shift = +0.043; 
   
   %% for different cases, have to pay attention which case fit, by checking that whether the result of 
   % generate_gt_wpattern_syn_zh consistent in plot_gt_and_estimate 
   
   %% case 1
   p_local = [0 0 0; 0 0 -0.0838; 0 0 -0.1681; -0.1317 0 0; 0.1302 0 0];
   
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
