% Copy files to a designated directory from text to binary
%
% Author : Soonhac Hong (sxhong1@ualr.edu)
% Date : 2/15/13

function copy_sr4k_files_t2b()

source_dir = 'D:\Soonhac\Data\sr4k\swing\revisiting9'; %'E:\data\Amir\processed_data\exp1_bus_door_straight_150_Copy'; %'E:\data\swing\revisiting2_10m\processed_data'; %'E:\data\swing\revisiting10_10m' %; % %''E:/data/sparse_feature/exp4_etas_2nd'
destination_dir = sprintf('%s/binary_data',source_dir);
mkdir(source_dir,'binary_data');
%destination_dir = 'E:\data\sparse_feature\exp15_etas_4th_swing_2culling\processed_data';

% Get file names from source directory
dirData = dir(source_dir);     %# Get the data for the current directory
dirIndex = [dirData.isdir];  %# Find the index for directories
file_list = {dirData(~dirIndex).name}';

interval = 1;
destination_file_idx=1;
first_file_number = 1; %1;
last_file_number =size(file_list,1)
for i=first_file_number:interval:last_file_number
    source_file_name = sprintf('%s/%s',source_dir, file_list{i});
    unit_destination_file_name = sprintf('d1_%04d.bdat',destination_file_idx);
    destination_file_name = sprintf('%s/%s',destination_dir,unit_destination_file_name);
    
    %copyfile(source_file_name, destination_file_name);
    % Load a text file
    a = load(source_file_name);    % elapsed time := 0.2 sec
    k=144*3+1;
    img = double(a(k:k+143, :));
    z = a(1:144, :);   x = a(145:288, :);     y = a(289:144*3, :);
    c = a(144*4+1:144*5, :);
    
    %Save a binary file
    fid = fopen(destination_file_name,'w+b');
    fwrite(fid,z','float');
    fwrite(fid,x','float');
    fwrite(fid,y','float');
    fwrite(fid,img','uint16');
    fwrite(fid,c','uint16');
    fclose(fid);
    
    destination_file_idx = destination_file_idx + 1;
end

end