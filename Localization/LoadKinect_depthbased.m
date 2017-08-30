% Load data from Kinect
%
% Parameters
%   data_name : the directory name of data
%   dm : index of directory of data
%   j  : index of frame
%
% Author : Soonhac Hong (sxhong1@ualr.edu)
% Date : 4/20/11

function [img, X, Y, Z, rtime, depth_time_stamp] = LoadKinect_depthbased(dm, j)

t_load = tic;

dir_name_list = get_kinect_tum_dir_name();
dir_name = dir_name_list{dm};

% Load depth image
[depth_data_dir, err] = sprintf('D:/Soonhac/Data/kinect_tum/%s/depth',dir_name);
dirData = dir(depth_data_dir);     %# Get the data for the current directory
dirIndex = [dirData.isdir];  %# Find the index for directories
file_list = {dirData(~dirIndex).name}';
[file_name_full, err]=sprintf('%s/%s',depth_data_dir,file_list{j});
[file_name, err] = sprintf('%s',file_list{j});
depth_time_stamp = str2double(strrep(file_name, '.png',''));
depth_img = imread(file_name_full);
%figure;imshow(depth_img);
depth_img = double(depth_img);

[rgb_data_dir, err] = sprintf('D:/Soonhac/Data/kinect_tum/%s/rgb',dir_name);

dirData = dir(rgb_data_dir);     %# Get the data for the current directory
dirIndex = [dirData.isdir];  %# Find the index for directories
file_list = {dirData(~dirIndex).name}';
for i=1:size(file_list,1)
    [color_file_name, err]=sprintf('%s',file_list{i});
    color_time_stamp(i,1) = str2double(strrep(color_file_name, '.png',''));
end
% find nearest tiem stamp of color image
color_file_nearest_index = find(color_time_stamp > depth_time_stamp, 1);
if color_file_nearest_index ~= 1 && ((color_time_stamp(color_file_nearest_index,1) - depth_time_stamp) > (depth_time_stamp - color_time_stamp(color_file_nearest_index-1,1)))
    color_file_nearest_index = color_file_nearest_index - 1;
end

[file_name, err]=sprintf('%s/%s',rgb_data_dir,file_list{color_file_nearest_index});
rgb_img = imread(file_name);
img = rgb2gray(rgb_img);
%figure;imshow(rgb_img);
%figure;imshow(img);

%Noise reduction by Gaussian filter
gaussian_h = fspecial('gaussian',[3 3],1); 
img=imfilter(img, gaussian_h,'replicate');



fx = 525.0;  %# focal length x
fy = 525.0;  %# focal length y
cx = 319.5;  %# optical center x
cy = 239.5;  %# optical center y
ds = 1.0;   %# depth scaling

factor = 5000.0; %# for the 16-bit PNG files
%# OR: factor = 1 %# for the 32-bit float images in the ROS bag files

for v=1:size(depth_img,1) %height
  for u=1:size(depth_img,2) %width
    z = (depth_img(v,u) / factor) * ds;
    x = (u - cx) * z / fx;
    y = (v - cy) * z / fy;
    X(v,u) = x;
    Y(v,u) = y;
    Z(v,u) = z;
  end
end

rtime = toc(t_load);

%figure;imagesc(X);
%figure;imagesc(Y);
%figure;imagesc(Z);
end