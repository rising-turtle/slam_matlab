function [graph,initial] = load3D_SR4000(pose_std_flag, sam_filename, pose_noise_model, successive,N,landmark_noise_model, pose_size, origin)
% load3D reads a TORO-style 3D pose graph
% cannot read noise model from file yet, uses specified model
% if [successive] is tru, constructs initial estimate from odometry

import gtsam.*

if nargin < 4, 
    successive=false; 
end

fid = fopen(sam_filename);
if fid < 0
    error(['load2D: Cannot open file ' sam_filename]);
end

% scan all lines into a cell array
columns=textscan(fid,'%s','delimiter','\n');
fclose(fid);

% pose_std_fid = fopen(pose_std_file_name);
% if fid < 0
%     error(['load2D: Cannot open file ' pose_std_file_name]);
% end
% pose_std_columns=textscan(pose_std_fid,'%s','delimiter','\n');
% fclose(pose_std_fid);

lines=columns{1};
% pose_std_lines=pose_std_columns{1};


% loop over lines and add vertices
graph = NonlinearFactorGraph;
initial = Values;
if nargin < 8
    origin=gtsam.Pose3;
end
initial.insert(0,origin);
n=size(lines,1);
%if nargin<4, N=n;end
N=n;


first_index_offset = 0;
step_threshold = 2;

node_count=0;
edge_count=0;
edges=[];
for i=1:n
    line_i=lines{i};
%     pose_std_line_i=pose_std_lines{i};
    if strcmp('VERTEX3',line_i(1:7))
        v = textscan(line_i,'%s %d %f %f %f %f %f %f',1);
        i1=v{2}-first_index_offset;
        if (~successive && i1<N || successive && i1==0)
            t = gtsam.Point3(v{3}, v{4}, v{5});
            R = gtsam.Rot3.Ypr(v{8}, -v{7}, v{6});
            initial.insert(i1, gtsam.Pose3(R,t));
            node_count=node_count+1;
        end
    elseif strcmp('EDGE3',line_i(1:5))
        if pose_std_flag == 1
            e = textscan(line_i,'%s %d %d %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f',1);
        else
            e = textscan(line_i,'%s %d %d %f %f %f %f %f %f',1);
        end

        if i==1
            first_index_offset = e{2};
        end
        i1=e{2}-first_index_offset;
        i2=e{3}-first_index_offset;
        
        % Filtering by steps
%         if abs(i1-i2) > step_threshold
%             continue;
%         end

%         if i1>=165
%             disp('debug');
%         end
        
        if i1<N && i2<N && i1<pose_size && i2<pose_size
            if ~successive || abs(i2-i1)==1
                t = gtsam.Point3(e{4}, e{5}, e{6});
                R = gtsam.Rot3.Ypr(e{9}, e{8}, e{7});
                dpose = gtsam.Pose3(R,t);
                if pose_std_flag == 1
                    pose_std = [e{10}; e{11}; e{12}; e{13}; e{14}; e{15}];
                    %pose_std_mean = [e{16}; e{17}; e{18}; e{19}; e{20}; e{21}];
                    %pose_std_sigma =[e{22}; e{23}; e{24}; e{25}; e{26}; e{27}];
                    pose_noise_model = noiseModel.Diagonal.Sigmas(pose_std);
                    %pose_noise_model = get_pose_noise_model(i2,i1);
                else
                    pose_noise_model = get_pose_noise_model(i2,i1);
                end
                %if abs(i2-i1) == 1 || check_pose_std(pose_std, pose_std_mean, pose_std_sigma) == 1
                    graph.add(BetweenFactorPose3(i1, i2, dpose, pose_noise_model));
                    edge_count = edge_count + 1;
                    edges=[edges; [i1 i2]];
                %end
                if successive
                    if i2>i1
%                          if i1 == 520
%                              disp('debug here!');
%                          end
                        initial.insert(i2,initial.at(i1).compose(dpose));
                    else
                        initial.insert(i1,initial.at(i2).compose(dpose.inverse));
                    end
                end
            end
        end
%     elseif strcmp('POINT3',line_i(1:6))
%         e = textscan(line_i,'%s %d %d %f %f %f',1);
%         i1=e{2};
%         i2=e{3}+1;
%         if i1<N && i2<N
%             t = gtsam.Point3(e{4}/1000, e{5}/1000, e{6}/1000);  % debug : [mm] -> [m]
%             R = gtsam.Rot3.Ypr(0, 0, 0);
%             dpose = gtsam.Pose3(R,t);
%             keys = KeyVector(initial.keys);
%             if ~successive   
%                 %graph.add(BetweenFactorPoint3(i1, i2, t, landmark_noise_model));
%                 graph.add(BetweenFactorPose3(i1, i2, dpose, pose_noise_model));
%             elseif keys.size <= i2
%                 initial.insert(i2,initial.at(i1).compose(dpose));
%             end
%         end
    end
end

%Analysis Edges
if ~isempty(edges)
    min_node=min(min(edges));
    max_node=max(max(edges));
    edge_matrix=zeros(max_node+1,max_node+1);
    for i=1:size(edges,1)
       edge_matrix(edges(i,1)+1,edges(i,2)+1)=1; 
    end
    figure;imagesc(edge_matrix);
end

node_count
edge_count

end

function valid_flag = check_pose_std(pose_std, pose_std_mean, pose_std_sigma)
valid_flag = 1;

for i=1:6
    if pose_std(i) > (pose_std_mean(i) + 3*pose_std_sigma(i))
        valid_flag = 0;
    end
end

end

function [pose_noise_model] = get_pose_noise_model(i2,i1)

    import gtsam.*

    step_factor = abs(i2-i1);
    
    %translation_covariance = (double(step_factor)^2) * 0.014; %0.014; %[m]
    %orientation_covariance = (double(step_factor)^2) * 0.6*pi/180; %0.6*pi/180; %[degree] -> [radian]
    translation_covariance = 1; %Identity matrix
    orientation_covariance = 1; %Identity matrix
    
    pose_noise_model = noiseModel.Diagonal.Sigmas([translation_covariance; translation_covariance; translation_covariance; orientation_covariance; orientation_covariance; orientation_covariance]);  % [m][radian]

end
