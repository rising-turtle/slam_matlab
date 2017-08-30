% Check the distance of feaure points 
%
% Author : Soonhac Hong (sxhong1@ualr.edu)
% Date : 4/5/13

function [op_pset1, op_pset2] = check_feature_distance_icp(op_pset1, op_pset2)
distance_min = 0.8;
distance_max = 5;

op_pset1_distance = sqrt(sum(op_pset1.^2));
op_pset2_distance = sqrt(sum(op_pset2.^2));

op_pset1_distance_flag = (op_pset1_distance < distance_min | op_pset1_distance > distance_max);
op_pset2_distance_flag = (op_pset2_distance < distance_min | op_pset2_distance > distance_max);

%debug
% if sum(op_pset1_distance_flag) > 0 || sum(op_pset2_distance_flag) > 0
%     disp('Distance filter is working');
% end

op_pset1(:, op_pset1_distance_flag)=[];   % delete invalid feature points
op_pset2(:, op_pset2_distance_flag)=[];   % delete invalid feature points

end