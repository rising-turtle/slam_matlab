% Generate the location infomation for Text-To-Speech and plots
%
% Author : Soonhac Hong (sxhong1@ualr.edu)
% History :
% 8/27/14 : Created
%
function [location_info, location_file_index] = generate_location_info(gtsam_pose_result, plot_xyz_result, location_file_index)

import gtsam.*


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

%% Generate the location information
% %ex1
% location_info_list={'Room 222 is your left;',...
%     'Room 230 is your right;',...
%     'Room 245 is your left;',...
%     'Room 300 is your right;'};
% short_location_info_list={'Rm 222',...
%     'Rm 230',...
%     'Rm 245',...
%     'Rm 300'};
% location_info_xy=[0, 1; -0.1, 5; -0.5, 10; -7, 5];  % unit : [m]

% etas 523 exp2
location_info_list={'Room 523 is your right;',...
    'Room 526 is your left;',...
    'Room 528 is your left;',...
    'Room 527 is your right;',...
    'Room 529 is your right;'};
short_location_info_list={'Rm 523',...
    'Rm 526',...
    'Rm 528',...
    'Rm 527',...
    'Rm 529'};

location_info_xy=[0, 2; -0.1, 5; 0.1, 8.5; 3.5, 8; 9, 7.7];  % unit : [m]

% location_info_list={'Room 507 is your left;',...
%     'Room 505 is your right;',...
%     'Room 504 is your right;',...
%     'Room 503 is your right;',...
%     'Room 501 is your right;'};
% short_location_info_list={'Rm 507',...
%     'Rm 505',...
%     'Rm 504',...
%     'Rm 503',...
%     'Rm 501'};
% location_info_xy=[0, 11; 0, 12.5; 0, 16.5; 0, 18; -1, 19.5];  % unit : [m]

location_threshold = 0.4;  % [m]
location_info_file_name = sprintf('C:\\SC-DATA-TRANSFER\\location_info_%d.txt', location_file_index);

location_info=[];
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