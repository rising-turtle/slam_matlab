%%%
% to align gt with trajectories from vins, okvis, 
% find out the timestamp at 1350 of gt match to timestamp at 53 of vins
% which means gt's timestamp 12.125 vins' timestamp 1498879054.726535936
% then gt's timestamp 6.925 (at 738) match to vins-mono' start timestamp 1498879049.526535936
% gt's timestamp 7.225 (at 774) match to vins-mono_ext's start timestamp 1498879049.826536192
% gt's timestamp 2.667 (at 237) match to okvis's start timestamp 1498879045.268399370
% gt's timestamp 2.691 (at 240) to viorb's start timestamp 1498879045.293203

function test_gt(st)

if nargin == 0
    st = 1230;
end

% load ground truth 
f_gt = strcat('./results/GT', '/ground_truth_g.log');
T_gt = load(f_gt);

figure;
r = 200;

plot_xyz( -T_gt(st:st+r,2), -T_gt(st:st+r,4), T_gt(st:st+r,3), 'k-');

view(2);

% compute_dx(T_gt(st:st+r,2));

end

function compute_dx(x)
    
m = size(x,1)
x1 = x(2:end);
x0 = x(1:m-1);
dx = abs(1000*(x1 - x0));
plot(dx,'b-*');

end

