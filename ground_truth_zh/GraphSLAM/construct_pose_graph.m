% Construct a pose graph for Graph SLAM
%
% Author : Soonhac Hong (sxhong1@ualr.edu)
% History : 
% 3/26/14 : Created

function [graph,initial] = construct_pose_graph(vro_result, vro_pose_std, graph, initial)

import gtsam.*

n=size(vro_result,1);
N=n;
pose_size=max(vro_result(:,2));

first_index_offset = 1;
step_threshold = 2;
sigma_level = 1;

node_count=0;
edge_count=0;
for i=1:n
    
    e=vro_result(i,:);
    i1=e(1)-first_index_offset;
    i2=e(2)-first_index_offset;
    
    
    t = gtsam.Point3(e(6), e(7), e(8));
    R = gtsam.Rot3.Ypr(e(5), e(3), e(4));
    
    dpose = gtsam.Pose3(R,t);
    
    pose_std = vro_pose_std(i,3:end)';  %[ry rx rz tx ty tz]
    pose_std =[pose_std(4:6); pose_std(2); pose_std(1); pose_std(3)];
    
    if (abs(i2-i1)==1) || check_reliability_static7(pose_std, sigma_level) == 1
        
        pose_noise_model = noiseModel.Diagonal.Sigmas(pose_std);
        
        graph.add(BetweenFactorPose3(i1, i2, dpose, pose_noise_model));
        edge_count = edge_count + 1;
        
        if abs(i2-i1)==1
            if i2>i1
                
                
                initial.insert(i2,initial.at(i1).compose(dpose));
            else
                initial.insert(i1,initial.at(i2).compose(dpose.inverse));
            end
        end
    end
    
end

end


function [reliability_flag] = check_reliability_static6(pose_std, sigma_level)
reliability_flag = 1;
translation_sigma = 0.007; %14;  %[m]
orientation_sigma_rx = 0.12*pi/180;%0.57*pi/180; %[radian]
orientation_sigma_ry = 0.12*pi/180;%0.11*pi/180; %[radian]
orientation_sigma_rz = 0.12*pi/180;%0.30*pi/180; %[radian]
std_pose_std = [orientation_sigma_ry,orientation_sigma_rx,orientation_sigma_rz,translation_sigma,translation_sigma,translation_sigma];

for i=1:6
    if pose_std(i) > (sigma_level * std_pose_std(i))
        reliability_flag = 0;
        break;
    end
end

end


function [reliability_flag] = check_reliability_static7(pose_std, sigma_level)
reliability_flag = 1;
translation_sigma = 0.056; %14;  %[m]
orientation_sigma_rx = 0.96*pi/180;%0.57*pi/180; %[radian]
orientation_sigma_ry = 0.96*pi/180;%0.11*pi/180; %[radian]
orientation_sigma_rz = 0.96*pi/180;%0.30*pi/180; %[radian]
std_pose_std = [orientation_sigma_ry,orientation_sigma_rx,orientation_sigma_rz,translation_sigma,translation_sigma,translation_sigma];

for i=1:6
    if pose_std(i) > (sigma_level * std_pose_std(i))
        reliability_flag = 0;
        break;
    end
end

end


