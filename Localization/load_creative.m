function [img,x, y, z, cor_i, cor_j] = load_creative(dm, file_index)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
img_file_name=sprintf('d:/image/creative_90cm_decrease_z50mm/image%d/image%d.png',dm-1,file_index-1);
img1 = imread(img_file_name);
img1=rgb2gray(img1);
img=im2double(img1);

x_file_name=sprintf('d:/image/creative_90cm_decrease_z50mm/image%d/x%d.txt',dm-1,file_index-1);
x=load(x_file_name);

y_file_name=sprintf('d:/image/creative_90cm_decrease_z50mm/image%d/y%d.txt',dm-1,file_index-1);
y=load(y_file_name);

z_file_name=sprintf('d:/image/creative_90cm_decrease_z50mm/image%d/z%d.txt',dm-1,file_index-1);
z=load(z_file_name);

cor_i_file_name=sprintf('d:/image/creative_90cm_decrease_z50mm/image%d/Color_I%d.txt',dm-1,file_index-1);
cor_i=load(cor_i_file_name);

cor_j_file_name=sprintf('d:/image/creative_90cm_decrease_z50mm/image%d/Color_J%d.txt',dm-1,file_index-1);
cor_j=load(cor_j_file_name);


end

