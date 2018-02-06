% Compenstate the bad pixel with low confidence by median filter
% Date : 3/13/12
% Author : Soonhac Hong (sxhong1@ualr.edu)

function [img, x, y, z, c] = compensate_badpixel_soonhac(img, x, y, z, c, confidence_cut_off)
e_index = c < confidence_cut_off;
x_median=medfilt2(x, [3 3],'symmetric');
y_median=medfilt2(y, [3 3],'symmetric');
z_median=medfilt2(z, [3 3],'symmetric');
image_median=medfilt2(img, [3 3],'symmetric');
z(e_index) = z_median(e_index);
x(e_index) = x_median(e_index);
y(e_index) = y_median(e_index);
img(e_index) = image_median(e_index);

%
%
%
%
%
%     for i = 1:size(img,1)   % row
%         for j=1:size(img,2) % column
%             if e_index(i,j) == 1
%                 start_i = i-1;
%                 end_i = i+1;
%                 start_j = j-1;
%                 end_j = j+1;
%                 point_i = 2;
%                 point_j = 2;
%                 if i == 1
%                     start_i = i;
%                     point_i = 1;
%                     if j == 1
%                         point_j = 1;
%                     end
%                 end
%                 if i == size(img,1)
%                     end_i = i;
%                     if j == 1
%                         point_j = 1;
%                     end
%                 end
%                 if j == 1
%                     start_j = j;
%                     if i == 1
%                         point_i = 1;
%                     end
%                 end
%                 if j == size(img,2)
%                     end_j = j;
%                     if i == 1
%                         point_i = 1;
%                     end
%                 end
%                 img_unit=medfilt2(img(start_i:end_i,start_j:end_j), [3 3],'symmetric');
%                 x_unit=medfilt2(x(start_i:end_i,start_j:end_j), [3 3],'symmetric');
%                 y_unit=medfilt2(y(start_i:end_i,start_j:end_j), [3 3],'symmetric');
%                 z_unit=medfilt2(z(start_i:end_i,start_j:end_j), [3 3],'symmetric');
%                 img(i,j) = img_unit(point_i,point_j);
%                 x(i,j) = x_unit(point_i,point_j);
%                 y(i,j) = y_unit(point_i,point_j);
%                 z(i,j) = z_unit(point_i,point_j);
%             end
%         end
%     end
% end