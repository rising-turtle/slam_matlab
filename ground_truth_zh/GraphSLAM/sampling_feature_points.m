% Conver the results of VRO to the vertex and edges for isam 
%
% Author : Soonhac Hong (sxhong1@ualr.edu)
% Date : 3/14/13

function new_feature_points = sampling_feature_points(feature_points, min_pixel_distance)
camera_index_list=unique(feature_points(:,1));
temp_feature_points=[];

%min_pixel_distance = 2;

for i=1:size(camera_index_list,1)
    camera_index = camera_index_list(i);
    data_index_list = find((feature_points(:,1) == camera_index & feature_points(:,3) == 1) | (feature_points(:,2) == camera_index & feature_points(:,3) == 2));
    unit_data = feature_points(data_index_list,:);
    sampled_unit_data = sampling_unit_data(unit_data, min_pixel_distance);
    temp_feature_points(data_index_list,:) = sampled_unit_data;
end

sampled_index = find(temp_feature_points(:,end) == 1);
new_feature_points = temp_feature_points(sampled_index,1:end-1);

% Delete near feature points which distance is less than 0.8m
for i=1:size(new_feature_points,1)
    distance = sqrt(sum(new_feature_points(:,4:6).^2,2));
end
near_feature_idx = find(distance < 800);  % 800 [mm]
new_feature_points(near_feature_idx,:)=[];

end

function sampled_unit_data_final = sampling_unit_data(unit_data, min_pixel_distance)
    
    sampled_unit_data = [];
    %sampled_data_index_list = [];
    
    center_data_index = find_nearest_center(unit_data(:,7:8));
    %sampled_data_index_list = [sampled_data_index_list; center_data_index];
    sampled_unit_data = [center_data_index, unit_data(center_data_index,7:8)];
    
    for i=1:size(unit_data,1)
        [duplication_index, duplication_flag] = check_duplication_imgidx(sampled_unit_data, unit_data(i,7:8), min_pixel_distance);
        if duplication_flag == 0  % check duplicated points
            sampled_unit_data = [sampled_unit_data; [i, unit_data(i,7:8)]];
        end
    end
    
    sampled_unit_data_final = unit_data;
    sampled_unit_data_final(sampled_unit_data(:,1), 9) = 1;
    
end

function data_index = find_nearest_center(unit_pixel_data)
image_center_x = 176/2;
image_center_y = 144/2;

distance = sqrt(sum((unit_pixel_data- repmat([image_center_x, image_center_y], size(unit_pixel_data,1), 1)).^2, 2));
[~, data_index] = min(distance);

end