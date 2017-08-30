% Load input and output files of ROS SBA (http://www.ros.org/wiki/sba/Tutorials/IntroductionToSBA)
%
% Author : Soonhac Hong (sxhong1@ualr.edu)
% Date : 2/28/13
% Note : Camera pose, T, in input files and output files of ROS-SBA is inverse
% transformaton from camera N to camera N+1. In other words,
% camera0=inv(T)*camera1. So to speak, camera1 = T * camera0

function [camera_pose, camera_parameters, landmark_position, landmark_projection] = load_rossba(file_name)


addpath('D:\soonhac\Project\PNBD\SW\ASEE\slamtoolbox\slamToolbox_11_09_08\FrameTransforms\Rotations');
addpath('D:\soonhac\Project\PNBD\SW\ASEE\slamtoolbox\slamToolbox_11_09_08\DataManagement');

fid = fopen(file_name);
if fid < 0
    error(['load2D: Cannot open file ' file_name]);
end

% scan all lines into a cell array
columns=textscan(fid,'%s','delimiter','\n');
fclose(fid);
lines=columns{1};

N=size(lines,1);

camera_pose_idx = 1;
landmark_index=1;
landmark_projection=[];
trans = [0 0 0]; 
rot = e2R([pi(), 0, 0]);  % rotate 180 around x-axis from bundler frame to SBA frame; 
bundler_T = [rot trans'; 0 0 0 1];
for i=1:N
    line_i=lines{i};
    %line_data = textscan(line_i,'%s','delimiter',' ');
    
    if i>=2 
        %line_data = str2num(line_data{1});
        line_data = textscan(line_i,'%f %f %f',1);
    end
    
    if i==2
        camera_index_total = line_data{1};
        landmark_index_total = line_data{2};
    elseif i>2
        if camera_pose_idx <= camera_index_total   % camera pose
            unit_idx = mod((i - 3),5);
            if unit_idx == 0
                camera_parameters(camera_pose_idx,:)=[line_data{1}, line_data{2}, line_data{3}];
            elseif unit_idx >=1 && unit_idx <=3  % rotation matrix
                unit_rot(unit_idx,:)=[line_data{1}, line_data{2}, line_data{3}];
            elseif unit_idx == 4 %translation
                unit_trans = [line_data{1}, line_data{2}, line_data{3}];
                T=[unit_rot unit_trans'; 0 0 0 1];
                %T= bundler_T * inv(T);   % Convert transform from ROS-SBA convention to VRO convention !!!!!
                T = inv(bundler_T * T);    % Convert transform from ROS-SBA convention to VRO convention !!!!!
                unit_rot=T(1:3,1:3);
                unit_trans=T(1:3,4);
                [e] = R2e(unit_rot);
                camera_pose(camera_pose_idx,:) = [unit_trans', e(1), e(2), e(3) ];
                camera_pose_idx = camera_pose_idx + 1;
                unit_rot=[];
%             elseif unit_idx == 0 && i>=5
            end
        else  % landmark pose
%             unit_idx = mod((i-(3+camera_index_total*5)), 3);
%             if unit_idx == 0
%                 landmark_pose(landmark_idx,:) = [line_data{1}, line_data{2}, line_data{3}];
%                 landmark_idx = landmark_idx + 1;
%             end
            index_modulus = mod(i-(camera_index_total*5 + 2), 3);
            switch index_modulus
                case 1  % position
                    v = textscan(line_i,'%f %f %f',1);
                    landmark_position(landmark_index,:) = [v{1},v{2},v{3}];
                case 2  % color
                    v = textscan(line_i,'%d %d %d',1);
                    landmark_color(landmark_index,:) = [v{1},v{2},v{3}];
                case 0  % projected positions
                    v = textscan(line_i,'%f','delimiter',' ');
                    v = v{1};
                    for k=1:v(1)
                        landmark_projection = [landmark_projection; v(2+(k-1)*4),v(3+(k-1)*4),v(4+(k-1)*4), v(5+(k-1)*4)];
                    end
                    landmark_index = landmark_index + 1;
            end
        end
            
    end
end

% if nargin < 4, 
%     successive=false; 
% end
% 
% fid = fopen(file_name);
% if fid < 0
%     error(['load2D: Cannot open file ' file_name]);
% end
% 
% % scan all lines into a cell array
% columns=textscan(fid,'%s','delimiter','\n');
% fclose(fid);
% lines = columns{1};
% 
% camera_index = 1;
% landmark_index = 1;
% landmark_projection=[];
% transform = {};
% landmark_position=[];
% landmark_color=[];
% for i=1:size(lines,1)
%     line_i=lines{i};
%     if i == 2
%         v = textscan(line_i,'%d %d',1);
%         nCamera=v{1};
%         nLandmarks=v{2};
%     elseif i > 2 && i <= (nCamera*5 + 2)   % camera pose
%         v = textscan(line_i,'%f %f %f',1);
%         index_modulus = mod(i-2,5);
%         switch index_modulus 
%             case 1
%                 camera_parameters(camera_index,:)=[v{1},v{2},v{3}];
%             case {2,3,4}
%                 rotation_matrix(index_modulus-1,:) = [v{1},v{2},v{3}];
%             case 0 
%                 transform{camera_index} = [rotation_matrix, [v{1},v{2},v{3}]'; 0 0 0 1];
%                 camera_index = camera_index + 1;
%         end
%     elseif i >2  %landmark position
%         index_modulus = mod(i-(nCamera*5 + 2), 3);
%         switch index_modulus
%             case 1  % position
%                 v = textscan(line_i,'%f %f %f',1);
%                 landmark_position(landmark_index,:) = [v{1},v{2},v{3}];
%             case 2  % color
%                 v = textscan(line_i,'%d %d %d',1);
%                 landmark_color(landmark_index,:) = [v{1},v{2},v{3}];
%             case 0  % projected positions
%                 v = textscan(line_i,'%f','delimiter',' ');
%                 v = v{1};
%                 for k=1:v(1)
%                     landmark_projection = [landmark_projection; v(2+(k-1)*4),v(3+(k-1)*4),v(4+(k-1)*4), v(5+(k-1)*4)];
%                 end
%                 landmark_index = landmark_index + 1;
%         end
%     end
% end
% 
% %% Convert data to the VRO convention
% camera_poses = [];  % x, y, z, rx, ry, rz
% for i=1:size(transform,2)
%     unit_transform = transform{i};
%     camera_poses(i,:) = [unit_transform(1:3,4)' R2e(unit_transform(1:3,1:3))'];
% end

end

