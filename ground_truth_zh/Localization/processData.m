function [ X Y Z I ] = processData( filename )
tmp_data=load(filename);
[m,n]=size(tmp_data);
image_n=n;
image_m=fix(m/5);
X=tmp_data(image_m*0+1:image_m*1,1:image_n);
Y=tmp_data(image_m*1+1:image_m*2,1:image_n);
Z=tmp_data(image_m*2+1:image_m*3,1:image_n);
I=tmp_data(image_m*3+1:image_m*4,1:image_n);
end

