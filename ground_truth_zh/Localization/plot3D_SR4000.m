% Each .dat file is a data frame captured from the camera. It contains five 2-D arrays each of which 
% represent z (Calibrated Distance), x (Calibrated xVector), y (Calibrated xVector), Amplitude, and Confidence Map.
% The following code read and render the Amplitude (intensity) image.

% Add showing the depth image
% Author : Soonhac Hong (sxhong1@ualr.edu)
% Date : 3/8/2011

%function plot3D_SR4000(data_name,filter_name, boarder_cut_off,dir_index)
function plot3D_SR4000(data_name,dir_index)

addpath('..\freezeColors');

filter_name = 'gaussian';
boarder_cut_off = 0;

% switch data_name
%     case 'pitch'
%         dir_name = sprintf('../data/pitch_3_interval/d%d_-%d/d%d',dir_index,43-dir_index*3,dir_index);
%     case 'pan'
%         dir_name = sprintf('../data/pan_3_interval/d%d_%d/d%d',dir_index,44-(dir_index-1)*3,dir_index);
%     case 'x'
%         dir_name = sprintf('../data/x/x%d/frm',dir_index);
%     case 'y'
%         dir_name = sprintf('../data/y/y%d/frm',dir_index);
%     otherwise
%         disp('Data cannot be found');
%         return;
% end

%figure;
scale = 1;
value_type = 'int';
%figure;
j = 0;
%30

%[nFrame, vro_size, pose_size, vro_icp_size, pose_vro_icp_size, vro_icp_ch_size, pose_vro_icp_ch_size] = get_nframe_nvro_npose(14, dir_index);

% [prefix, confidence_read] = get_sr4k_dataset_prefix(data_name, dir_index);
% vidObj = VideoWriter(sprintf('%s.avi', prefix));
% open(vidObj);

%loops2_nFrame_list = [830 582 830 832 649 930 479 580 699 458 368 239];
previous_rtime = [];
first_frame =440;
last_frame = 700;
interval = 1;
for i=first_frame:interval:last_frame %1:1:nFrame%700:1000
    i
    %[img, x, y, z, c, rtime] = LoadSR_no_bpc(data_name, filter_name, boarder_cut_off, dir_index, i, scale, value_type); %LoadSR(data_name, dir_index, i);
    %[img, x, y, z, c, rtime, time_stamp, prefix] = LoadSR_no_bpc_time(data_name, filter_name, boarder_cut_off, dir_index, i, scale, value_type);
    
    %[img, x, y, z, c, rtime] = LoadSR_no_bpc_time_single(data_name, filter_name, boarder_cut_off, dir_index, i, scale, value_type);
    [img, x, y, z, c, rtime] = LoadSR_no_bpc_time_single_binary(data_name, filter_name, boarder_cut_off, dir_index, i, scale, value_type);
    
    %[img, x, y, z, c, rtime] = LoadSR_wobpc(data_name, filter_name, boarder_cut_off, dir_index, i, scale, value_type); 
    
%     fw=1;
%     a = load('sample/sample_sr4000_0001.dat');    % elapsed time := 0.2 sec
%     k=144*3+1;
%     img = double(a(k:k+143, :));
%     z = a(1:144, :);   x = a(145:288, :);     y = a(289:144*3, :);
%     z = medfilt2(z,[fw fw]);  x = medfilt2(x, [fw fw]);      y = medfilt2(y, [fw fw]); 
    
    %subplot(1,2,1);
    figure(1);
    %j = j + 1;
    %subplot(1,4,j);
%     subplot(2,2,1);
    imagesc(img); colormap(gray); axis image;
    set(gca,'XTick',[]);
    set(gca,'YTick',[]);
    
    %title('Intensity Image'); %['frame ', int2str(i)]);
%     if i==first_frame
%         title(sprintf('frame %d', i)); %'Frame %d', 2));
%     else
%         title(sprintf('frame %d (%4.2f [msec/frame])', i, abs(time_stamp-previous_rtime(end)))); %'Frame %d', 2));
%     end
%     
%     previous_rtime = [previous_rtime; time_stamp];
    
%     currFrame = getframe;
%     writeVideo(vidObj,currFrame);
       
%     freezeColors;    % Don't chage the previous sub plots
%     figure(2);
%     subplot(2,2,2);
%     imagesc(z);colormap(jet); colorbar(); 
%     %title('Range Image'); 
%     axis image; %colorbar()
%     set(gca,'XTick',[]);
%     set(gca,'YTick',[]);
%     subplot(2,2,3);imagesc(x);colormap(jet);axis image; colorbar();title('X Image');
%     subplot(2,2,4);imagesc(y);colormap(jet);axis image; colorbar();title('Y Image');
%     figure; 
%     plot3(x,y,z,'b.'); 
%     surf(x,y,z);
%     imagesc(c);colormap(jet); colorbar(); title('Confidence Image');
    
   drawnow;
end

% close(vidObj);

figure;
plot(diff(previous_rtime),'.-');
ylabel('Time per frame');
xlabel('Frame');
grid;

end

