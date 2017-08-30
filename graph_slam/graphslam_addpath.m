% Add the path for graph slam
%
% Author : Soonhac Hong (sxhong1@ualr.edu)
% Date : 10/16/12

function graphslam_addpath

% addpath('D:\Soonhac\SW\gtsam-toolbox-2.3.0-win64\toolbox');
% addpath('D:\soonhac\SW\kdtree');
% addpath('D:\soonhac\SW\LevenbergMarquardt');
% addpath('D:\soonhac\SW\Localization');
% addpath('D:\soonhac\SW\SIFT\sift-0.9.19-bin\sift');
% addpath('D:\soonhac\SW\slamtoolbox\slamToolbox_11_09_08\FrameTransforms\Rotations');
% addpath('D:\Soonhac\SW\plane_fitting_code');

% addpath('F:\co-worker\soonhac\gtsam-toolbox-2.3.0-win64\toolbox');
% addpath('F:\co-worker\soonhac\SW\kdtree');
% addpath('F:\co-worker\soonhac\LevenbergMarquardt');
% addpath('F:\co-worker\soonhac\Localization');
% addpath('F:\co-worker\soonhac\SIFT\sift-0.9.19-bin\sift');
% addpath('F:\co-worker\soonhac\slamtoolbox\slamToolbox_11_09_08\FrameTransforms\Rotations');
% addpath('F:\co-worker\soonhac\plane_fitting_code');

global g_ws_dir;
addpath(strcat(g_ws_dir, '/gtsam-toolbox-2.3.0-win64/toolbox'));
addpath(strcat(g_ws_dir, '/kdtree'));
addpath(strcat(g_ws_dir, '/LevenbergMarquardt'));
addpath(strcat(g_ws_dir, '/SIFT/sift-0.9.19-bin/sift'));
addpath(strcat(g_ws_dir, '/slamtoolbox/slamToolbox_11_09_08/FrameTransforms/Rotations'));
addpath(strcat(g_ws_dir, '/plane_fitting_code'));

%% modified modules
addpath(strcat(g_ws_dir, '/Localization')); %% 
addpath(strcat(g_ws_dir, '/GraphSLAM'));    %%
end
