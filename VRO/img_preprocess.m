function [ img ] = img_preprocess( data_name,  old_file_version)
%IMG_PREPROCESS Summary of this function goes here
%   Detailed explanation goes here

if nargin < 1
    old_file_version = 1; % 1; 
    % data_name='/home/davidz/work/EmbMess/mesa/pcl_mesa/build/bin/sr_data/d1_0001.bdat';
    data_name='/home/davidz/work/data/SwissRanger4000/try/d1_0001.bdat'; 
end

fileID=fopen(data_name);
if fileID==-1
    %disp('File open fails !!');
    return;
end

sr4k_image_width = 176; 
sr4k_image_height = 144;

if old_file_version
    z=fread(fileID,[sr4k_image_width,sr4k_image_height],'float');
    x=fread(fileID,[sr4k_image_width,sr4k_image_height],'float');
    y=fread(fileID,[sr4k_image_width,sr4k_image_height],'float');
    img=fread(fileID,[sr4k_image_width,sr4k_image_height],'uint16');
    % img=fread(fileID,[144,176],'uint16');
else
    img=fread(fileID,[sr4k_image_width,sr4k_image_height],'uint16');
    dis=fread(fileID,[sr4k_image_width,sr4k_image_height],'uint16');
    dis = dis';
    dis = scale_image(dis);
    imshow(dis);
end

img = img';
img = scale_image(img); 
imshow(img);

end


function [img] = scale_image(img)
%% set the pixels that is larger than limit = 65000, to 0
[m, n] = find (img>65000);    %????
imgt=img;
num=size(m,1);
for kk=1:num
    imgt(m(kk), n(kk))=0;
end

%% set the pixels larger than limit, to max(imgt) value
imax=max(max(imgt));
for kk=1:num
    img(m(kk),n(kk))=imax;
end

%% sqrt(img) and rescale to 0-255
img=sqrt(img).*255./sqrt(max(max(img)));   %This line degrade the performance of SURF
img = uint8(img);

%% Adaptive histogram equalization
% img = adapthisteq(img);

%% gaussian filter
gaussian_h = fspecial('gaussian',[3 3],1);  %sigma = 1
% img=imfilter(img, gaussian_h,'replicate');
end

