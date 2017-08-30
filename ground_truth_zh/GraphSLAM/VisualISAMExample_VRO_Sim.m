%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GTSAM Copyright 2010, Georgia Tech Research Corporation,
% Atlanta, Georgia 30332-0415
% All Rights Reserved
% Authors: Frank Dellaert, et al. (see THANKS for the full author list)
%
% See LICENSE for the license information
%
% @brief A simple visual SLAM example for structure from motion
% @author Duy-Nguyen Ta
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

import gtsam.*

% Data Options
options.triangle = false;
options.nrCameras = 20;
options.showImages = false;

% iSAM Options
options.hardConstraint = false;
options.pointPriors = false;
options.batchInitialization = true;
options.reorderInterval = 10;
options.alwaysRelinearize = false;

% Display Options
options.saveDotFile = false;
options.printStats = false;
options.drawInterval = 1; %5;
options.cameraInterval = 1;
options.drawTruePoses = false;
options.saveFigures = false;
options.saveDotFiles = false;

%% Generate data
[data,truth] = VisualISAMGenerateData_SIM(options);

%% Initialize iSAM with the first pose and points
[noiseModels,isam,result,nextPose] = VisualISAMInitialize_SIM(data,truth,options);
%cla;
%VisualISAMPlot(truth, data, isam, result, options)

%% Main loop for iSAM: stepping through all poses
for frame_i=3:10 %options.nrCameras
    [isam,result,nextPose] = VisualISAMStep_VRO(data,noiseModels,isam,result,truth,nextPose);
    %if mod(frame_i,options.drawInterval)==0
    %    VisualISAMPlot(truth, data, isam, result, options)
    %end
end

%% Display result
%figure;
M = 1;
while result.exists(symbol('x',M))
    pose=result.at(symbol('x',M));
    t = pose.translation().vector();
    plot3(t(1),t(2),t(3),'rd');
    hold on;
    M = M + 1;
end
%hold off;
