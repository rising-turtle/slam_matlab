function im_out=image2dyadic(img,sz);
img = reshape(img,sz);
d=log2(sz);
d=max(fix(d))+1;
xstart=fix((2^d-sz(1))*0.5);
ystart=fix((2^d-sz(2))*0.5);
im_out=zeros(2^d);
im_out(xstart+[1:sz(1)],ystart+[1:sz(2)])=img;