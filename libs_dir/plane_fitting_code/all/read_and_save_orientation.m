function read_and_save_orientation()
config_file
global myCONFIG

nDataFiles = data_file_counting(myCONFIG.PATH.DATA_FOLDER,'d1');
for i=1:nDataFiles
    [R,T] = plane_fit_to_data(i);
    Step_idx = i;
    R= R';
    q=R2q(R);
    %     file_name =
    
    
    [file_name, err]=sprintf('%s/orientation_%04d.dat',[myCONFIG.PATH.DATA_FOLDER,'/OrientationData/'],i);
    
    save(file_name,'R','q','Step_idx')
    i
end

end


