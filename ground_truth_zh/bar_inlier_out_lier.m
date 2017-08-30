function bar_inlier_out_lier( file )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

if nargin == 0
    % file = './tmp/rgbd_inlier_outlier.log'; 
    file = './tmp/LSD_inlier_outlier.log'; 
end

d = load(file);
% in = d(:,1); 
% ou = d(:,2); 

hBar = bar(d(:,2:3), 'stacked'); 

set(hBar,{'FaceColor'},{'b';'r'});
xlabel('Number of Keyframes #', 'FontSize', 17);
ylabel('Number of Matched Points #', 'FontSize', 17);
h = legend('inliers', 'outliers');
set(h, 'FontSize', 24); 
set(gca,'fontsize', 20);
end

