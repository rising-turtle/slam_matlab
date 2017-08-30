% Scale and smoothing image
%
% Parameters
%   img : input image
%   fw  : the size of median filter
%
% Author : Soonhac Hong (sxhong1@ualr.edu)
% Date : 4/21/11

function [img] = scale_img(img, fw, value_type, data_type)
[m, n, v] = find (img>65000);    %????
imgt=img;
num=size(m,1);
for kk=1:num
    imgt(m(kk), n(kk))=0;
end
imax=max(max(imgt));
for kk=1:num
    img(m(kk),n(kk))=imax;
end

% img=uint8(sqrt(img).*255./sqrt(max(max(img))));
if strcmp(data_type, 'intensity')
    img=sqrt(img).*255./sqrt(max(max(img)));   %This line degrade the performance of SURF
elseif  strcmp(data_type, 'range')
    img_max = max(max(img));
    if img_max <= 5.0
        img_max = 5.0;
    end
    img=sqrt(abs(img)).*255./sqrt(img_max);   %This line degrade the performance of SURF
end

if strcmp(value_type, 'int')
    img = uint8(img);
end

% img=medfilt2(img, [fw fw]);

end