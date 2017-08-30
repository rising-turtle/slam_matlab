function sift_image(img_name)

if nargin == 0
    img_name ='image_15.png';
end

img = imread(img_name);
[frm, des] = sift(img);

imshow(img);

end