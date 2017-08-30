% Analysis of distance and intensity of SR4000.


data_name='pitch_2_interval_blackout_noae';
filter_name = 'none'; %'Gaussian';
boarder_cut_off = 0;
scale = 0;  % 1 : Scale an intensity image to [0,255], 0: No scale
value_type = 'int';

for d=1:16
    for i=1:1000
        [d,i]
        % Load data
        [img1, x1, y1, z1, c1, elapsed_pre] = LoadSR_no_bpc(data_name, filter_name, boarder_cut_off, d, i, scale, value_type);
        
        % Compute ratio of distance and intensity near 2-neighbor center
        size_img=size(img1);
        distance(d,i) = mean([z1(size_img(1)/2, size_img(2)/2), z1(size_img(1)/2, size_img(2)/2+1)]);
        intensity(d,i) = mean([img1(size_img(1)/2, size_img(2)/2), img1(size_img(1)/2, size_img(2)/2+1)]);
    end
end

% Comopute mean
mean_distance=mean(distance,2);
std_distance=std(distance,0,2);
mean_intensity=mean(intensity,2);
std_intensity=std(intensity,0,2);

% plot results
figure;
errorbar(mean_intensity, mean_distance, std_distance,'r.-');
grid;
xlabel('Intensity');
ylabel('Distance [m]');

figure;
plot(mean_intensity,std_intensity,'bd-');
grid;
xlabel('Mean of Intensity');
ylabel('Standard Deviation of Intensity');