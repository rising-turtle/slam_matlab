% Analysis of distance and intensity of SR4000.


data_name='pitch_2_interval_blackout_noae';
filter_name = 'none'; %'Gaussian';
boarder_cut_off = 0;
scale = 0;  % 1 : Scale an intensity image to [0,255], 0: No scale
value_type = 'int';

for d=1:16
    for i=1:540
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

pitch=10:2:40;
pitch_arc=pitch*pi/180;
h_pt_table=0.06425;
cam_fp=0.1;
init_distance=(mean_distance(1)+cam_fp)*cos(pitch_arc(1)) - h_pt_table*sin(pitch_arc(1))-cam_fp;
true_distance=(init_distance+cam_fp)./cos(pitch_arc) + h_pt_table*tan(pitch_arc)-cam_fp;
mean_distance_error=mean_distance - true_distance';

figure;
%set(gca, 'fontsize', 20);
[haxes,hline1,hline2] = plotyy(pitch(1:11), mean_distance_error(1:11)*1000, pitch(1:11), mean_intensity(1:11)/1000);
ylabel(haxes(1), 'Mean distance error (mm)');
ylabel(haxes(2), 'Mean intensity');
xlabel(haxes(2), 'Pitch (deg)'); 
%set(gca, 'YTick', [-2:2:14]);
set(hline1, 'Linestyle', '--', 'LineWidth', 2);
set(hline2, 'Linestyle', '-', 'Marker', '^', 'MarkerSize', 6, 'LineWidth', 2);
grid(haxes(1), 'on');
hold on;
errorbar(pitch(1:11), mean_distance_error(1:11)*1000, std_distance(1:11)*1000, '--o', 'MarkerSize', 6, 'LineWidth', 2);
%set(gca, 'XTick', [8:2:32]);
hold off;

