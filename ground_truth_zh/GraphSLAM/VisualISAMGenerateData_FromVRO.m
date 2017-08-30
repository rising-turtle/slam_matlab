function [data,truth] = VisualISAMGenerateData_FromVRO(options)
% VisualISAMGenerateData creates data for viusalSLAM::iSAM examples
% Authors: Duy Nguyen Ta and Frank Dellaert

%% Generate simulated data
import gtsam.*
% if options.triangle % Create a triangle target, just 3 points on a plane
%     nrPoints = 3;
%     r = 10;
%     for j=1:nrPoints
%         theta = (j-1)*2*pi/nrPoints;
%         truth.points{j} = Point3([r*cos(theta), r*sin(theta), 0]');
%     end
% else % 3D landmarks as vertices of a cube
%     nrPoints = 8;
%     truth.points = {Point3([10 10 10]'),...
%         Point3([-10 10 10]'),...
%         Point3([-10 -10 10]'),...
%         Point3([10 -10 10]'),...
%         Point3([10 10 -10]'),...
%         Point3([-10 10 -10]'),...
%         Point3([-10 -10 -10]'),...
%         Point3([10 -10 -10]')};
% end


%% Load Landmark pose from VRO

% Load landmark pose
%filename = 'D:\soonhac\Project\PNBD\SW\ASEE\GraphSLAM\data\3d\whitecane\3th_straight_Replace_pose_feature_1260.sam';
filename = 'D:\soonhac\Project\PNBD\SW\ASEE\GraphSLAM\data\3d\whitecane\exp8__Replace_pose_feature_76_18_vro_cov.sam';
fid = fopen(filename);
if fid < 0
    error(['load2D: Cannot open file ' filename]);
end

% scan all lines into a cell array
columns=textscan(fid,'%s','delimiter','\n');
fclose(fid);
lines=columns{1};

N=size(lines,1);

i2_list=[];
landmarks =[];
last_pose_index = 18;
for i=1:N
    line_i=lines{i};
    if strcmp('POINT3',line_i(1:6))
        e = textscan(line_i,'%s %f %f %f %f %f %f %f',1);
        landmarks = [landmarks; e{1,2:8}];
        i1=e{2}+1;
        i2=e{3}-last_pose_index+1;  
        
        if i1<N && i2<N && isempty(find(i2_list==i2))
            %truth.points{i2} = gtsam.Point3(e{4}/1000, e{5}/1000, e{6}/1000);  % [mm] -> [m] 
            truth.points{i2} = gtsam.Point3(e{4},e{5}, e{6});  % [mm] -> [m] 
            %truth.points_camera_idx{i2} = i1;
            i2_list=[i2_list; i2];
            %t = gtsam.Point3(e{4}/1000, e{5}/1000, e{6}/1000);  % [mm] -> [m] 
            %data.Z{i1}{i2} = truth.cameras{i1}.projectSafe(t);
            %data.J{i1}{i2} = i2;
            %R = gtsam.Rot3.Ypr(0, 0, 0);
            %dpose = gtsam.Pose3(R,t);
            %keys = KeyVector(initial.keys);
            %if ~successive   
                %graph.add(BetweenFactorPoint3(i1, i2, t, landmark_noise_model));
            %    graph.add(BetweenFactorPose3(i1, i2, dpose, pose_noise_model));
            %elseif keys.size <= i2
            %    initial.insert(i2,initial.at(i1).compose(dpose));
            %end
        end
    end
end
landmarks = double(landmarks);

% % Load landmark edges
% [f_index, t_pose, o_pose, feature_points] = load_vro(11,1,979, 1);  % t_pose[mm], o_pose[degree], feature_points [mm]
% [f_index, t_pose, o_pose, feature_points(:,1:2)] = compensate_vro(f_index, t_pose, o_pose, feature_points(:,1:2), 'Replace');
% 
% fpts_size=size(feature_points,1);
% fpts_index = 1;
% for i=1:fpts_size
%     %line_i=lines{i};
%     %if strcmp('POINT3',line_i(1:6))
%     %    e = textscan(line_i,'%s %d %d %f %f %f',1);
%         i1=feature_points(i,1);
%         i2=feature_points(i,2);
%         if i1<N && i2<N && abs(i1-i2) == 1&& feature_points(i,3)==1
%             t = gtsam.Point3(feature_points(i,4)/1000, feature_points(i,5)/1000, feature_points(i,6)/1000);  % [mm] -> [m] 
%             data.Z{i1}{fpts_index} = truth.cameras{i1}.projectSafe(t);
%             data.J{i1}{fpts_index} = fpts_index;
%             fpts_index = fpts_index+1;
%             %R = gtsam.Rot3.Ypr(0, 0, 0);
%             %dpose = gtsam.Pose3(R,t);
%             %keys = KeyVector(initial.keys);
%             %if ~successive   
%                 %graph.add(BetweenFactorPoint3(i1, i2, t, landmark_noise_model));
%             %    graph.add(BetweenFactorPose3(i1, i2, dpose, pose_noise_model));
%             %elseif keys.size <= i2
%             %    initial.insert(i2,initial.at(i1).compose(dpose));
%             %end
%         else
%             fpts_index = 1;
%         end
%     %end
% end

%% Load camera pose from VRO
%filename = 'D:\soonhac\Project\PNBD\SW\ASEE\GraphSLAM\data\3d\whitecane\3th_straight_Replace_pose_feature_1260.isp'; % this file included orientation of each camera
filename = 'D:\soonhac\Project\PNBD\SW\ASEE\GraphSLAM\data\3d\whitecane\exp8__Replace_pose_feature_76_18_vro.isp';
fid = fopen(filename);
if fid < 0
    error(['load2D: Cannot open file ' filename]);
end

% scan all lines into a cell array
columns=textscan(fid,'%s','delimiter','\n');
fclose(fid);
lines=columns{1};

N=size(lines,1);

%truth.K = Cal3_S2(250,250,0,176/2,144/2); % (fx, fy, scale, uo, vo) [pixels]  fx = 10 mm / 40 um [pixel size]
truth.K = Cal3_S2(250,250,0, 88, 72);
data.K = truth.K;
sr4k_parameter = initialize_cam();
pose_step = 1;
camera_index = 1;
for i=1:N
    line_i=lines{i};
    %line_i_next=lines{i+1};
    if strcmp('VERTEX_SE3',line_i(1:10))
        v = textscan(line_i,'%s %d %f %f %f %f %f %f',1);
        i1=v{2}+1;
        if (i1<N && mod(i1,pose_step) == 0) || i1 == 1
            t = gtsam.Point3(v{3}, v{4}, v{5});
            %t = gtsam.Point3(v{3}, -v{5}, v{4});
            rot = euler_to_rot(v{7}*180/pi, v{6}*180/pi, v{8}*180/pi);  % ry, rx, rz [degree]
            R = gtsam.Rot3(rot);
            %R = gtsam.Rot3.Ypr(v{8}, -v{7}, v{6});
            %initial.insert(i1, gtsam.Pose3(R,t));
            %truth.cameras{i} = SimpleCamera.Lookat(t, target_t, Point3([0,0,1]'), truth.K);
            truth.cameras{camera_index} = SimpleCamera(gtsam.Pose3(R,t), truth.K);
            % Create measurements
            %unit_landmark_idx = 1;
            %while 1
                %if truth.points_camera_idx{landmark_idx} == i1
                landmarks_idx = find(landmarks(:,1)==(i1-1));
                for j=1:length(landmarks_idx)  
                    % All landmarks seen in every frame
                    %unit_landmark = gtsam.Point3(landmarks(landmarks_idx(j),3)/1000.0, -landmarks(landmarks_idx(j),5)/1000.0, landmarks(landmarks_idx(j),4)/1000.0);
                    %data.Z{i1}{j} = truth.cameras{i1}.project(unit_landmark);
                    
                    %Apply sr4k_reprojection
%                     unit_landmark_global=[landmarks(landmarks_idx(j),3)/1000.0, -landmarks(landmarks_idx(j),5)/1000.0, landmarks(landmarks_idx(j),4)/1000.0, 1]';
%                     h=[rot [t.x t.y t.z]'; 0 0 0 1];
%                     unit_landmark_local = inv(h)*unit_landmark_global;
%                     camera_uv = hi_cartesian_test( [unit_landmark_local(1), unit_landmark_local(2), unit_landmark_local(3)]', [0;0;0], eye(3), sr4k_parameter, []);
%                     data.Z{camera_index}{j}=gtsam.Point2(camera_uv(1),camera_uv(2));
%                     data.J{camera_index}{j} = j;
                    % Assign data from VRO
                    data.Z{camera_index}{j}=gtsam.Point2(landmarks(landmarks_idx(j),6), landmarks(landmarks_idx(j),7));
                    data.J{camera_index}{j} = landmarks(landmarks_idx(j),2)-last_pose_index+1;   % global index of landmarks
                    %unit_landmark_idx = unit_landmark_idx + 1;
                %else
                %    break;
                end
                %landmark_idx=landmark_idx+1;
            %end
            camera_index = camera_index + 1;
        end
    end
end


%% Create camera cameras on a circle around the triangle
% import gtsam.*
% height = 10; r = 40;
% truth.K = Cal3_S2(10,10,0,176/2,144/2); % (fx, fy, scale, uo, vo)
% data.K = truth.K;
% for i=1:options.nrCameras
%     theta = (i-1)*2*pi/options.nrCameras;
%     t = Point3([r*cos(theta), r*sin(theta), height]');
%     truth.cameras{i} = SimpleCamera.Lookat(t, Point3, Point3([0,0,1]'), truth.K);
%     % Create measurements
%     for j=1:nrPoints
%         % All landmarks seen in every frame
%         data.Z{i}{j} = truth.cameras{i}.project(truth.points{j});
%         data.J{i}{j} = j;
%     end    
% end

%% show images if asked
if options.showImages
    gui = gcf;
    for i=1:N
        figure(2+i);clf;hold on
        set(2+i,'NumberTitle','off','Name',sprintf('Camera %d',i));
        for j=1:size(data.Z{i},2)
            zij = data.Z{i}{j}; %truth.cameras{i}.project(truth.points{j});
            plot(zij.x,zij.y,'*');
            axis([1 640 1 480]);
        end
    end
    figure(gui);
end

%% Calculate odometry between cameras
%odometry = truth.cameras{1}.pose.between(truth.cameras{2}.pose);
for i=1:size(truth.cameras,2)-1
    odometry = truth.cameras{i}.pose.between(truth.cameras{i+1}.pose);
    data.odometry{i}=odometry;
end