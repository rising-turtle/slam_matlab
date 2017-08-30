% Run pose graph based SLAM for Smart Cane
% Assumption : Every frame of SR4000 is transmitted from a portable computer to the desktop computer.
%
% Author : David Z (hxzhang1@ualr.edu)
% History : 
% 3/4/2015 : Created

clear;
clc;
clf;

import gtsam.*

global_def; 
global g_ws_dir g_data_dir g_display 

%% add module path for: graph gtsam, kdtree, LM, SIFT, plane_fitting, 
%% two modified modules: localization, graphSLAM
graphslam_addpath; 

% check weather the data folder has /visual_feature, /matched_points,
% /pose_std
pre_check_dir(g_data_dir);

%% Set initila parameters
global g_camera_type g_delete_previous_data g_measure_ct
data_name = g_camera_type;
% feature_dis = 0; % 1 = display features; 0 = display no features

meaure_ct_flag = g_measure_ct;  % true = Measure computational time

%% these are the variables used in graph
vro_result=[];
vro_pose_std=[];
graph = NonlinearFactorGraph;
initial = Values;

%% video parameter
global g_video_name g_record_video
record_video_flag=g_record_video; %true;  % true = Record the plot as videos

% h_global=[];
% location_info_history={};
% pgo_interval = 5; % 20; % Interval of running PGO
% display_flag = true; %false;  % true = display plots; 
% location_flag = true; %true; % true = generate a location information file for TTS; 
% save_result_file_flag=true;  % true = Save result files


%% weather to delete the recorded data
if g_delete_previous_data == true
     delete(strcat(g_data_dir, '/visual_feature_zh/*.mat'));
     delete(strcat(g_data_dir, '/matched_points_zh/*.mat'));
     delete(strcat(g_data_dir, '/pose_std_zh/*.mat'));
end

%% start to record video
if g_display
    figure(1);
    if record_video_flag == true
        video_figure=figure(1);
        vidObj = VideoWriter(g_video_name);
        vidObj.Quality=100;
        vidObj.FrameRate=4; %5;
        open(vidObj);
    end
end

%% compute time for each step
vro_ct=[];
pgo_ct=[];
error=0;


%% begin to run VRO and graph optimization 
b_first_frame = true;
vro_result = []; 
vro_pose_std = [];
last_frame = -1; 
curr_frame = 1;
graph_id = 1; % id in the graph, used to create the nodes, 
              % graph_id is continuous like 1, 2, 3, ... n 
              % while frame_id is not, due to VRO failure, like 1, 3, 7 ...
id_to_frame = []; % mapping graph id to camera frame_id
global g_total_frames g_start_frame g_step_frame
for f=g_start_frame:g_step_frame:g_total_frames %300%1399; %825; %295  % limited data
    
    curr_frame=f; % current frame id
    
    %% Run VRO
    if meaure_ct_flag==true
        vro_t=tic;
    end
    
    %% load img data 
    [img2, frm2, des2, p2, ld_err] = load_camera_frame(curr_frame);
    if ld_err > 0
        fprintf('no data for %d, next frame!\n', curr_frame);
        continue;
    end
    
    %% for the first frame
    if b_first_frame
        b_first_frame = false;
        img1 = img2; frm1 = frm2; des1 = des2; p1 = p2; % next loop
        last_frame = curr_frame;
        id_to_frame(graph_id) = last_frame;
        graph_id = graph_id + 1;
        %% TODO: graph structure should add this node into graph
        continue;
    end
    
    %% show the two images
    if g_display
        display_image(img1, 3, last_frame); % last frame 
        display_image(img2, 1, curr_frame); % curr frame
    end
    
    %% match this two frames 
    [t, pose_std, e] = VRO(last_frame, curr_frame, img1, img2, des1, frm1, p1, des2, frm2, p2); 
    if e == 0 % succeed 
        id_to_frame(graph_id) = curr_frame;
        vro_result = [vro_result; graph_id-1, graph_id, t, e];
        vro_pose_std = [vro_pose_std; graph_id-1, graph_id-1, pose_std' e]; 
        graph_id = graph_id + 1;
        last_frame = curr_frame;
        img1 = img2; frm1 = frm2; des1 = des2; p1 = p2; % next loop
    elseif e > 0 % VRO failed, 
        fprintf('VRO failed at %d, go to the next image!\n', curr_frame);
        continue;
    end
    
    if meaure_ct_flag==true
        vro_ct = [vro_ct; toc(vro_t)];
    end
        
    %% add the new vro result into the graph 
    [graph, initial] = add_edge_to_graph(vro_result, vro_pose_std, graph, initial); 
    
    %% TODO: optimize it, not in the current version,  
    
    %% show it 
    if g_display
        plot_graph_trajectory(initial);
        
        %% Record video
        if record_video_flag == true
            currFrame = getframe(video_figure);
            writeVideo(vidObj,currFrame);
        end
    end
end

%% optimize the graph and show the result 
[graph, result, initial] = optimize_graph(graph, initial); 
if g_display
    plot_graph_trajectory(initial, result); 
    if record_video_flag == true
        close(vidObj);
    end
end
% mean_vro_ct = mean(vro_ct)
% mean_pgo_ct = mean(pgo_ct)
% mean_total_ct = mean_vro_ct+mean_pgo_ct

%% for debug
dump_matrix_2_file('VRO_result.log', vro_result);
dump_matrix_2_file('VRO_pose.log', vro_pose_std);

% %Save result files
% if save_result_file_flag == 1
%     gtsam_isp_file_name='results/vro.isp';
%     gtsam_opt_file_name='results/gtsam.opt';
%     isgframe = 'none';
%     vro_name = 'vro';
%     %save initial pose
%     save_graph_isp(initial, gtsam_isp_file_name, isgframe);
%     
%     %save optimized pose
%     save_graph_isp(result, gtsam_opt_file_name, isgframe);
%     
%     % Write ply files
%     % convert_isp2ply(gtsam_isp_file_name, file_index, dynamic_index, isgframe, vro_name);
%     % convert_isp2ply(gtsam_opt_file_name, file_index, dynamic_index, isgframe, vro_name);
%     
%     % Save location history for plot
%     location_history_file_name = 'results/location_history.mat';
%     save(location_history_file_name,'location_info_history');
% end