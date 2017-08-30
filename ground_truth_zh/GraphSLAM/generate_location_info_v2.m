% Generate the location infomation for Text-To-Speech and plots
%
% Author : Soonhac Hong (sxhong1@ualr.edu)
% History :
% 8/27/14 : Created
%
function [location_info, location_file_index] = generate_location_info_v2(gtsam_pose_result, plot_xyz_result, location_file_index)

import gtsam.*

location_info=[];

% Extract the optimized pose from gtsam data structure if the optimized pose is not available

if isempty(plot_xyz_result)
    keys = KeyVector(gtsam_pose_result.keys);
    
    % isp_fd = fopen(file_name_pose, 'w');
    initial_max_index = keys.size-1;
    for i=0:initial_max_index
        key = keys.at(i);
        x = gtsam_pose_result.at(key);
        T = x.matrix();
        [ry, rx, rz] = rot_to_euler(T(1:3,1:3));
        plot_xyz_result(i+1,:)=[x.x x.y x.z];
    end
end

if size(plot_xyz_result,1) < 50  % Avoid adjacency of first n steps with respect to the starting point
    return;
end
%% Generate the location information
location_info_list={'You return to the starting point;'};
short_location_info_list={'Start'};

location_info_xy=[0, 0];  % unit : [m]
location_threshold = 0.4;  % [m]
location_info_file_name = sprintf('C:\\SC-DATA-TRANSFER\\location_info_%d.txt', location_file_index);

current_position = [plot_xyz_result(end,1),plot_xyz_result(end,2),plot_xyz_result(end,3)]; % [x, y, z]

for i=location_file_index:size(location_info_xy,1)
    distance = norm(current_position(1, 1:2) - location_info_xy(i,:));
    if distance < location_threshold
        location_info = short_location_info_list{i};
        % Write the location information to the location_info.txt
        fd = fopen(location_info_file_name, 'w');
        fprintf(fd,'%s',location_info_list{i});
        fclose(fd);
        location_file_index = location_file_index + 1;
        break;
    end
end

end