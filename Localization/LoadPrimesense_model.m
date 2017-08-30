% Load data from Kinect
%
% Parameters
%   data_name : the directory name of data
%   dm : index of directory of data
%   j  : index of frame
%
% Author : Soonhac Hong (sxhong1@ualr.edu)
% Date : 4/20/11

function [img, X, Y, Z] = LoadPrimesense_model(dm, file_index)

%t_load = tic;

%dir_name_list = get_kinect_tum_dir_name();
%dir_name = dir_name_list{dm};

% Load depth image
%[depth_data_dir, err] = sprintf('D:/Soonhac/Data/kinect_tum/%s/depth',dir_name);
%dirData = dir(depth_data_dir);     %# Get the data for the current directory
%dirIndex = [dirData.isdir];  %# Find the index for directories
%file_list = {dirData(~dirIndex).name}';
%[file_name_full, err]=sprintf('%s/%s',depth_data_dir,file_list{j});
%[file_name, err] = sprintf('%s',file_list{j});
%depth_time_stamp = str2double(strrep(file_name, '.png',''));
%depth_img = imread(file_name_full);
%figure;imshow(depth_img);
%depth_img = double(depth_img);
if file_index<11
   z_file_name=sprintf('D:/image/prime/12mm_primesense_registered2/image%d/depth/00%d.png',dm-1,file_index-1);
   img_file_name=sprintf('D:/image/prime/12mm_primesense_registered2/image%d/rgb/00%d.png',dm-1,file_index-1);
   %x_file_name=sprintf('D:/image/image%d/depth/00%dx.dat',dm-1,file_index-1);
   %y_file_name=sprintf('D:/image/image%d/depth/00%dy.dat',dm-1,file_index-1);
elseif file_index<101
   z_file_name=sprintf('D:/image/prime/12mm_primesense_registered2/image%d/depth/0%d.png',dm-1,file_index-1); 
   img_file_name=sprintf('D:/image/prime/12mm_primesense_registered2/image%d/rgb/0%d.png',dm-1,file_index-1);
   %x_file_name=sprintf('D:/image/image%d/depth/0%dx.dat',dm-1,file_index-1);
  % y_file_name=sprintf('D:/image/image%d/depth/0%dy.dat',dm-1,file_index-1);
elseif file_index<605
   z_file_name=sprintf('D:/image/prime/12mm_primesense_registered2/image%d/depth/%d.png',dm-1,file_index-1);
   img_file_name=sprintf('D:/image/prime/12mm_primesense_registered2/image%d/rgb/%d.png',dm-1,file_index-1);
  % x_file_name=sprintf('D:/image/image%d/depth/%dx.dat',dm-1,file_index-1);
  % y_file_name=sprintf('D:/image/image%d/depth/%dy.dat',dm-1,file_index-1);
    
end
    
depth_img=imread(z_file_name);
depth_img=double(depth_img);

img1=imread(img_file_name);
img=rgb2gray(img1);
img=im2double(img);

% center=[320,240];
% [imh, imw] = size(depth_img);
% %constant = 570.3;
% constant = 573; %constant = focal;
% factor=1;
% % convert depth image to 3d point clouds
% %pclouds = zeros(imh,imw,3);
% xgrid = ones(imh,1)*(1:imw)  - center(1);
% ygrid = (1:imh)'*ones(1,imw)  - center(2);
% X = xgrid.*depth_img/constant/factor;
% Y = ygrid.*depth_img/constant/factor;
% Z = depth_img/factor;

fx = 543.0;  %# focal length x
fy = 543.0;  %# focal length y
cx = 319.5;  %# optical center x
cy = 239.5;  %# optical center y
ds = 1.0;   %# depth scaling

factor = 1; %# for the 16-bit PNG files
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

% distance = sqrt(sum(pclouds.^2,3));

























%rgb_img = imread(file_name);
%img = rgb2gray(rgb_img);
%figure;imshow(rgb_img);
%figure;imshow(img);

%Noise reduction by Gaussian filter
%gaussian_h = fspecial('gaussian',[3 3],1); 
%img=imfilter(img, gaussian_h,'replicate');



%  fx = 570.3;  %# focal length x 551.0/420
%  fy = 570.3;  %# focal length y 548.0/420
%  cx = 320;  %# optical center x //319.5
%  cy = 240;  %# optical center y ///239.5
%  ds = 1.0;   %# depth scaling
%  
%  factor = 1; %# for the 16-bit PNG files
% % %# OR: factor = 1 %# for the 32-bit float images in the ROS bag files
% % 
%  for v=1:size(depth_img,1) %height
%    for u=1:size(depth_img,2) %width
%      z = (depth_img(v,u) / factor) * ds;
%      x = (u - cx) * z / fx;
%      y = (v - cy) * z / fy;
%      X(v,u) = x;
%      Y(v,u) = y;
%      Z(v,u) = z;
%    end
%  end

%rtime = toc(t_load);

%figure;imagesc(X);
%figure;imagesc(Y);
%figure;imagesc(Z);
end