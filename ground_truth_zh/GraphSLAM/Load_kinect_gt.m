% Load data from Kinect data
%
% Parameters
%   data_name : the directory name of data
%   dm : index of directory of data
%   j  : index of frame
%
% Author : Soonhac Hong (sxhong1@ualr.edu)
% Date : 4/20/11

function [gt rgbdslam rtime] = Load_kinect_gt(dm, dis)

if nargin < 2
    dis = 0;
end

t_load = tic;

%dir_name={'rgbd_dataset_freiburg1_xyz'};
dir_name_list = get_kinect_tum_dir_name();
[file_name, err] = sprintf('E:/data/kinect_tum/%s/groundtruth.txt',dir_name_list{dm});
[time tx ty tz qx qy qz qw] = textread(file_name,'%f %f %f %f %f %f %f %f','commentstyle','shell');

prefix_name = strrep(dir_name_list{dm}, 'rgbd_dataset_','');
[rgbdslam_file_name, err] = sprintf('E:/data/kinect_tum/%s/%s-rgbdslam.txt',dir_name_list{dm},prefix_name);
[stime stx sty stz sqx sqy sqz sqw] = textread(rgbdslam_file_name,'%f %f %f %f %f %f %f %f','commentstyle','shell');

rtime = toc(t_load);

gt = [time tx ty tz qx qy qz qw];
rgbdslam = [stime stx sty stz sqx sqy sqz sqw];

if dis == 1
    plot3(tx, ty, tz, 'r-');
    hold on;
    plot3(stx, sty, stz, 'b:');
    hold off;
    grid;
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
end

end