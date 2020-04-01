function im_out=dyadic2image(img,sz)

d=log2(sz);
d=max(fix(d))+1;
xstart=fix((2^d-sz(1))*0.5);
ystart=fix((2^d-sz(2))*0.5);

im_out=img(xstart+[1:sz(1)],ystart+[1:sz(2)]);