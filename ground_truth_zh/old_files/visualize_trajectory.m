clear all
close all
clc
config_file
global myCONFIG
%%
tic
fig_anim = figure();
axis vis3d off
% view([0 0]);
% campos_ = [0.0369   -9.9043  -16.3406];
% camtarget_ = [-0.1364    0.0253    2.3371];
% camva(6.5)
daspect([1 1 1])

%% Update paper data by Soonhac
visual_final_step = 470;%581;%797;%625;%2488;%1056;%518;%572;%715; %2806; %3675;% %2806; %3675; %1056;%3675;%2806;%570;%895;%1056 %518;% 572; %434;%524;% 570;%715; %2095;%715; %755; %491;% 2095;%491;%755;%491;
visual_sample_step = 7;
%data_directory='F:\RS4000_datasets_Zhao\Indoor_terrian_data\data_02Feb2015\SR4k_data 4\'; % experiment 6 in the conference paper
%data_directory='F:\RS4000_datasets_Zhao\Outdoor_terrain_data\data_04Feb2015\SR4k_data 3\'; % experiment 3 in the conference paper
%data_directory='F:\RS4000_datasets_Zhao\Indoor_terrian_data\data_02Feb2015\SR4k_data 5\';  % experiment 8 in the conference paper
%data_directory='F:\RS4000_datasets_Zhao\OutdoorDataset_25April_2015\SR4k_data 1\'; % experiment 10 in the conference paper
%data_directory='F:\RS4000_datasets_Zhao\OutdoorDataset_02April_2015\SR4k_data 1\'; % experiment 9 in the conference paper
%data_directory ='F:\RS4000_datasets_Zhao\OutdoorDataset_15April_2015\SR4k_data 1\'; % experiment 11 in the conference paper
%data_directory='F:\RS4000_datasets_Zhao\Indoor_terrian_data\data_30Jan2015\SR4k_data 1\';
%data_directory='C:\Yiming\data_experiments\RS4000_motive_28July_2015\SR4k_data 4\';
data_directory='C:\Yiming\data_experiments\RS4000_motive_18June_2015\SR4k_data 1\';
pm_result_file_name=sprintf('%s\\PM_result\\PM_result.mat', data_directory);
vro_result_file_name=sprintf('%s\\VRO_result\\VRO_result.mat', data_directory);

%% Load data files
load(pm_result_file_name) % trajectory
load(vro_result_file_name) % xx

%% Set output file names
ply_file_name = sprintf('%s\\visualization\\map_floor_plane.ply', data_directory);
vro_ply_file_name = sprintf('%s\\visualization\\vro_trajectory.ply', data_directory);
pm_ply_file_name = sprintf('%s\\visualization\\pm_trajectory.ply', data_directory);

%% Write vro trajectory to a ply file
vro_color=[0,255,0]; % green
write_trajectory2ply(xx(:,5:visual_final_step), vro_ply_file_name, vro_color);

%% Write pm trajectory to a ply file
pm_color=[153,153,0]; % green
%pm_color=[255,255,0]; % yellow
%pm_color=[255,0,0]; % red
write_trajectory2ply(trajectory(:,5:visual_final_step), pm_ply_file_name, pm_color);

xx(2,:) = xx(2,:)-0.8;
figure(fig_anim)
N_point_cloud = 0;


for idx=5:visual_sample_step:visual_final_step %min(size(xx,2),size(trajectory,2))
    idx
    [x_sr,y_sr,z_sr,im,time_stamp,conf_] = read_xyz_sr4000_test(myCONFIG.PATH.DATA_FOLDER,idx);
    img2=im;
    [m, n, v] = find(im>65000);
    G = fspecial('gaussian',[3 3],2); 
    num=size(m,1);
    for kk=1:num
        img2(m(kk), n(kk))=0;
    end
    imax=max(max(img2));
    for ii=1:num
        im(m(ii), n(ii))=imax;
    end
    im= uint8(normalzie_image(double(im)));

    if idx==5
        
        mean_img_old = uint8(mean(im(:)));
        im_ref = im;

    end
    
    im_ref = (im);
    
    mean_img_new =mean(im(:))
    max_img_new =max(im(:))
    im = adapthisteq((im),'clipLimit',0.005,'Distribution','rayleigh');

    x = -x_sr; y = -y_sr; z = z_sr; %%% transform it into camera coordinate
    im =double(im);
    x_k_k = [trajectory(1,idx);trajectory(2,idx);trajectory(3:end,idx)];

    T = x_k_k(1:3);%%p_intersect2';
    R = q2r(x_k_k(4:7));
    H = [R,T;0 0 0 1];

    XYZ_ORIGIN = H*[x(:)';y(:)';z(:)';ones(1,length(y(:)))];
    IM_ = im(:);
    conf_vector = conf_(:);
    max_conf = max(conf_vector);
    XYZ_ORIGIN(:,conf_vector<max_conf*0.8)=[];
    IM_(conf_vector<max_conf*0.8)=[];
    DEPTH_ = sqrt((XYZ_ORIGIN(1,:) - T(1)).^2 + (XYZ_ORIGIN(2,:)- T(2)).^2 + (XYZ_ORIGIN(3,:)- T(3)).^2);
    
    XYZ_ORIGIN(:,DEPTH_>3 | DEPTH_<0.5 )=[];
    
    IM_(DEPTH_>3 | DEPTH_<0.5) =[];
    dlmwrite(ply_file_name,...
        [XYZ_ORIGIN(1,:)',XYZ_ORIGIN(2,:)',XYZ_ORIGIN(3,:)',IM_,IM_,IM_],...
        '-append', 'delimiter',' ');
    
    % one_matrix = ones(size(trajectory,2),1);
    % zero_matrix = zeros(size(trajectory,2),1);
    % dlmwrite('D:\trajectory_reset.ply',...
    % [trajectory(1,:)',trajectory(2,:)'+0.8,trajectory(3,:)',one_matrix,zero_matrix,zero_matrix], '-append', 'delimiter',' ');

    N_point_cloud = N_point_cloud + length(XYZ_ORIGIN(1,:));
    drawnow

end

N_point_cloud
toc
