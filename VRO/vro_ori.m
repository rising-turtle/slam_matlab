
%%
% Oct. 7, 2015, David Z 
%  VRO using soon's program  
%
%%

addpath('../SIFT/sift-0.9.19-bin/sift');
addpath('../Localization'); 

%% output filess
error_file_name = sprintf('results/vro/error.dat'); 
feature_points_file_name = sprintf('results/vro/feature.dat');
pose_std_file_name = sprintf('results/vro/pose_std.dat'); 

err_fid = fopen(error_file_name, 'w'); 
fp_fid = fopen(feature_points_file_name, 'w'); 
pose_std_fid = fopen(pose_std_file_name, 'w');

%% input parameters 
image_name = 'intensity';
data_name = 'sr4000'; 
filter_name = 'gaissian'; 
boarder_cut_off = 0;
ransac_iteration_limit = 0; 
valid_ransac_num = 3; 
scale = 1;
value_type = 'int';
inc = 1;

sequence_data = 0; 
is_10M_data = 0;
k = 2;
feature_dis = 0;

%% return parameters 
total_tr = [];
rFrame = 0;
frame_index = [];
phi=[]; % roll 
theta=[]; % pitch 
psi=[];  % yaw
trans=[];  % [tx, ty, tz]
error=[]; % what' error 
elapsed=[]; % time 
match_num=[]; % number of matched points 
feature_points={};
pose_std = [];
consecutive_error_count = 0;

%% main loop, doing VRO using frames 
for j = 1:100
    sframe = 1;
    next_frame = j;
    %% VRO
    [phi(j), theta(j), psi(j), trans(:,j), error(j), elapsed(:,j), match_num(:,j), feature_points{j}, pose_std(:,j)]= ...
        localization_sift_ransac_limit_cov_fast_fast_dist2_nobpc_sr(image_name, data_name, filter_name, boarder_cut_off,  ...
        ransac_iteration_limit, valid_ransac_num, scale, value_type, k, inc, next_frame, sframe, sequence_data, is_10M_data, feature_dis);                
    frame_index = [frame_index; j j];
end

%% record the result
    tr =[phi; theta; psi; trans; elapsed; match_num; error]';    
    save_tr = [frame_index tr];
    % fprintf(err_fid,'%d %d %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f\n', save_tr');
    fprintf(err_fid,'%d %d %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f\n', save_tr');
    fclose(err_fid);



