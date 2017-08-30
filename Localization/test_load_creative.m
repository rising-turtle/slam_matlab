% Test load_creative


[img,x, y, z, cor_i, cor_j] = load_creative('image0', 4);


%show data in plot
figure;imshow(img);

figure;
imagesc(x);
colormap(gray)
axis image

figure;
imagesc(y);
colormap(gray)
axis image

figure;
imagesc(z);
colormap(gray)
axis image

figure;
plot3(x(2:end-1,2:end-1),y(2:end-1,2:end-1),z(2:end-1,2:end-1),'k.');
xlabel('X');
ylabel('Y');
zlabel('Z');
axis equal;
grid;

figure;
sampling_interval =5;
plot3(x(2:sampling_interval:end-1,2:sampling_interval:end-1),y(2:sampling_interval:end-1,2:sampling_interval:end-1),z(2:sampling_interval:end-1,2:sampling_interval:end-1),'b.');
xlabel('X');
ylabel('Y');
zlabel('Z');
axis equal;
grid;

