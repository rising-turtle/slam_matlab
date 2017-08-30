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



if file_index<11
   z_file_name=sprintf('D:/image/pm5_roll/image%d/depth/00%d.png',dm-1,file_index-1);
   img_file_name=sprintf('D:/image/pm5_roll/image%d/rgb/00%d.png',dm-1,file_index-1);
  
elseif file_index<101
   z_file_name=sprintf('D:/image/pm5_roll/image%d/depth/0%d.png',dm-1,file_index-1); 
   img_file_name=sprintf('D:/image/pm5_roll/image%d/rgb/0%d.png',dm-1,file_index-1);
  
elseif file_index<605
   z_file_name=sprintf('D:/image/pm5_roll/image%d/depth/%d.png',dm-1,file_index-1);
   img_file_name=sprintf('D:/image/pm5_roll/image%d/rgb/%d.png',dm-1,file_index-1);
  
end
    
depth_img=imread(z_file_name);
depth_img=double(depth_img);

img1=imread(img_file_name);
img=rgb2gray(img1);

gaussian_h = fspecial('gaussian',[3 3],1); 
img=imfilter(img, gaussian_h,'replicate');

%img=im2double(img);

%Rt=[  0.99977    0.010962   -0.018654    0.023278;
 %     -0.010059  0.9988     0.047831     -0.0097038;
  %     0.019156  -0.047632  0.99868      -0.0093007  ]; % add calibration R and T
% R=[   1.0000    -0.0033    0.0028  26.87065;
%       0.0033    1.0000     0.0043  0.9;
%       -0.0028   -0.0042    1.0000  6.7;
%            0        0        0      1    ] ;
       
 R=[   1.0000    0    0    25;
        0        1    0    0.9;
        0        0    1    0.9;
        0        0    0      1    ] ;      
       
       
IR=[1 0 0 0;
    0 1 0 0;
    0 0 1 0];

Kr=[ 552     0        321;
      0      552      227;
      0       0        1];



[imh, imw] = size(depth_img);
X=zeros(imh,imw);
Y=zeros(imh,imw);
Z=zeros(imh,imw);

 fx = 584;  %# focal length x 551.0/420
 fy = 584;  %# focal length y 548.0/420
 cx = 318;  %# optical center x //319.5
 cy = 238;  %# optical center y ///239.5
 ds = 1.0;   %# depth scaling
 
 factor = 1; %# for the 16-bit PNG files

 for v=1:size(depth_img,1) %height
   for u=1:size(depth_img,2) %width
     z = (depth_img(v,u) / factor) * ds;
     x = (u - cx) * z / fx;
     y = (v - cy) * z / fy;
%      X(v,u) = x;
%      Y(v,u) = y;
%      Z(v,u) = z;
    
     uv_vector1=R*[x y z 1]';
     uv_vector=Kr*IR*uv_vector1;
     u_vector=ceil(uv_vector(1,:)/uv_vector(3,:));
     v_vector=ceil(uv_vector(2,:)/uv_vector(3,:));
    
     
     
     %u_vector=round(uv_vector(1,:)/uv_vector(3,:));
     %v_vector=round(uv_vector(2,:)/uv_vector(3,:));
     if u_vector>0 && u_vector<640 &&v_vector>0 && v_vector<480
        X(v_vector,u_vector)=uv_vector1(1,:);
        Y(v_vector,u_vector)=uv_vector1(2,:);
        Z(v_vector,u_vector)=uv_vector1(3,:);
    
         
     end
 end
end


