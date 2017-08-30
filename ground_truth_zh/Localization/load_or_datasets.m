function [I X Y Z c rtime] = load_or_datasets(data_name, filter_name, boarder_cut_off, dm, j, scale, type_value)

fw=1;
c=[];
t_pre = tic;

[prefix, confidence_read] = get_sr4k_dataset_prefix(data_name, dm);
[filename, err]=sprintf('%s_%04d.dat', prefix, j);



tmp_data=load(filename);

[m,n]=size(tmp_data);
image_n=n;
image_m=fix(m/4);

I=tmp_data(image_m*0+1:image_m*1,1:image_n);
X=tmp_data(image_m*1+1:image_m*2,1:image_n);
Y=tmp_data(image_m*2+1:image_m*3,1:image_n);
Z=tmp_data(image_m*3+1:image_m*4,1:image_n);

% X=tmp_data(image_m*0+1:image_m*1,1:image_n);
% Y=tmp_data(image_m*1+1:image_m*2,1:image_n);
% Z=tmp_data(image_m*2+1:image_m*3,1:image_n);
% I=tmp_data(image_m*3+1:image_m*4,1:image_n);

%Scale intensity image to [0 255]
if scale == 1
    I = scale_img(I, fw, type_value, 'intensity');
end

rtime = toc(t_pre);
end

