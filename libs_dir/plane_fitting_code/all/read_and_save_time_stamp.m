function read_and_save_time_stamp()
config_file
global myCONFIG
nDataFiles = data_file_counting(myCONFIG.PATH.DATA_FOLDER,'d1');
time_stamp = zeros(2,nDataFiles);
for i=1:nDataFiles
    %     source_data_file = sprintf('%s/d1_%04d.dat',source_folder,i);
    
    [s, err]=sprintf('%s/d1_%04d.dat',myCONFIG.PATH.DATA_FOLDER,i);
    sr_data = load(s);
    
    if size(sr_data,1)==721
        time_stamp(:,i) = [sr_data(721,1);i];
    else
        time_stamp(:,i) = [-1;i];
    end
    i
end

save([myCONFIG.PATH.DATA_FOLDER,'/TimeStamp/TimeStamp.mat'],'time_stamp')
time_difference = time_stamp(1,2:end) - time_stamp(1,1:end-1);
figure;plot(time_difference/1000)
end