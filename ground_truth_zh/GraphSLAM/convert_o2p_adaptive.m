% Conver the odometery to the global pose
% t_pose [mm]
% o_pose [degree]

function [pose_index, e_t_pose e_o_pose fpts_h] = convert_o2p_adaptive(data_index, dynamic_index, f_index, t_pose, o_pose, feature_points, dense_index, sparse_interval)

% Generate the vertex using VRO
disp('Generate the vertex using VRO.');
previous_index = -1;
if size(f_index,1) > 0
    vro_index = 1;
    if dense_index == 1
        for i=1:size(f_index,1)
            relative_max_index = max(find(f_index(:,1) == f_index(i,1)))
            if f_index(i,1) > previous_index && (i == relative_max_index || check_orientation(o_pose(i,:)) == 1) %abs(f_index(i,1) - f_index(i,2)) == 1
                vro_t_pose(vro_index,:) = t_pose(i,:);
                vro_o_pose(vro_index,:) = o_pose(i,:);
                pose_index(vro_index) = f_index(i,1);
                vro_index = vro_index + 1;
                previous_index = f_index(i,2)-1;    
            end
        end
    else  % Sparse pose
        % Generate the vertex using VRO with the only maximum constraints
        %sparse_interval = 2;
        next_index = min(f_index(:,1));
        max_index = max(f_index(:,1));
        while next_index <= max_index
            temp_index=find(f_index(:,1) == next_index);
            if isempty(temp_index)
                next_index = next_index + 1;
            else
                %max_temp_index = max(temp_index);
                if length(temp_index) > sparse_interval
                    max_temp_index = min(temp_index)+sparse_interval;
                else
                    max_temp_index = max(temp_index);
                end
                vro_t_pose(vro_index,:) = t_pose(max_temp_index,:);
                vro_o_pose(vro_index,:) = o_pose(max_temp_index,:);
                pose_index(vro_index) = f_index(max_temp_index,1);
                vro_index = vro_index + 1;
                next_index = f_index(max_temp_index,2);
            end
        end
    end
else
    vro_t_pose = t_pose;
    vro_o_pose = o_pose;
end




% Generate the vertex from feature points at each pose
disp('Generate the vertex from feature points at each pose.');
if ~isempty(feature_points)
    fpts = cell(size(pose_index,2),1);
    %current_pose_index = 1;
    for i = 1:size(feature_points,1)
        if feature_points(i,3) == 1
            current_pose_index = feature_points(i,1);
        else%pose_index
            current_pose_index = feature_points(i,2);
        end
        cell_index = find(pose_index == current_pose_index);
        if ~isempty(cell_index)
            fpts{cell_index,1} = [fpts{cell_index,1}; current_pose_index feature_points(i,4:6)];
        end
    end
    % Eliminate duplicated points
    fpts = eliminate_duplication(fpts);
end



% Calculate Homogenous Transformation in 3D
disp('Calculate Homogenous Transformation in 3D.');
e_t_pose = zeros(size(vro_t_pose,1), 4);

h_global = get_global_transformation(data_index, dynamic_index);


for i = 1:size(vro_t_pose,1)
    h{i} = [euler_to_rot(vro_o_pose(i,1), vro_o_pose(i,2), vro_o_pose(i,3)) vro_t_pose(i,:)'; 0 0 0 1];
end

disp('Convert poses w.r.t the global frame.');
fpts_h = cell(size(pose_index,2),1);
for k = 2:size(e_t_pose,1)
    for j = k-1 : -1: 1
        if j == k-1
            temp_pose = h{j}*[ 0 0 0 1]';
            if ~isempty(feature_points)
                unit_data = fpts{k,1};
                for f = 1:size(unit_data,1)
                    temp_fpts(:,f) = h{j}*[unit_data(f,2:4) 1]';
                end
                unit_data=[];
            end
            temp_h = h{j};
        else
            temp_pose = h{j}*temp_pose;
            if ~isempty(feature_points)
                unit_data = fpts{k,1};
                for f = 1:size(unit_data,1)
                    temp_fpts(:,f) = h{j}* temp_fpts(:,f);
                end
                unit_data=[];
            end
            temp_h = h{j}*temp_h;
        end
    end
    e_t_pose(k,:) = [h_global * temp_pose]';
    if ~isempty(feature_points)
        unit_data_h=[];
        for f = 1:size(fpts{k,1},1)
            unit_data_h(f,:) = [h_global* temp_fpts(:,f)]';
        end
        %temp_data = fpts{k,1};
        fpts_h{k,1}= [fpts{k,1}(:,1) unit_data_h];
    end
    temp_h = h_global * temp_h;
    [e_o_pose(k,1) e_o_pose(k,2) e_o_pose(k,3)] = rot_to_euler(temp_h(1:3,1:3));
end

e_t_pose(1,:) = [h_global * [0 0 0 1]']';
if ~isempty(feature_points)
    for f = 1:size(fpts{1,1},1)
        fpts_h{1,1}(f,:) = [fpts{1,1}(f,1) [h_global* [fpts{1,1}(f,2:4) 1]']'];
    end
else
    fpts_h={};
end

temp_h = h_global;
[e_o_pose(1,1) e_o_pose(1,2) e_o_pose(1,3)] = rot_to_euler(temp_h(1:3,1:3));

end

function [new_ftps] = eliminate_duplication(fpts)
    new_fpts = cell(size(fpts));
    
    for i = 1:size(fpts,1)
        unit_cell = fpts{i,1};
        new_unit_cell = [];
        for j=1:size(unit_cell,1)
            [duplication_index, duplication_flag] = check_duplication(new_unit_cell, unit_cell(j,:));
            if duplication_flag == 0
                new_unit_cell = [new_unit_cell; unit_cell(j,:)];
            end
        end
        new_ftps{i,1} = new_unit_cell;
    end
end

function [orientation_dominant] = check_orientation(unit_o_pose)
    o_threshold = 3.0 ; %0.24; %[degree]
    idx = find(abs(unit_o_pose) > o_threshold);
    if isempty(idx) 
        orientation_dominant = 0
    else
        orientation_dominant = 1
    end
end
