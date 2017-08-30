% Generate feature index through all data 
%
% Author : Soonhac Hong (sxhong1@ualr.edu)
% Date : 3/1/13

function [feature_points] = generate_feature_index(feature_points)

feature_index_list=[];
camera_index_list=[];
feature_index = 1;
for i=1:size(feature_points,1)
    if feature_points(i,1) == 1 && feature_points(i,2) == 2 && feature_points(i,3) == 1  
        feature_index_list(i,1) = feature_index;
        feature_index = feature_index + 1;
        camera_index_list(i,1) = feature_points(i,3);
    elseif feature_points(i,1) == 1 && feature_points(i,2) == 2 && feature_points(i,3) == 2
        feature_index_list(i,1) = feature_index_list(i-feature_index+1,1);
        camera_index_list(i,1) = feature_points(i,3);
    else
        [unit_feature_index, unit_camera_index]= find_similar_feature_index(feature_points(1:i,:), feature_index_list, camera_index_list);    
%         if i==411
%             disp('debug');
%         end
        feature_index_list(i,1) = unit_feature_index;
        if unit_feature_index > feature_index
            feature_index = unit_feature_index;
        end
        camera_index_list(i,1) = unit_camera_index;
    end
end

feature_points = [feature_points, feature_index_list, camera_index_list];

end


function [feature_index, camera_index] = find_similar_feature_index(feature_points, feature_index_list, camera_index_list)

if feature_points(end,3) == 1
    camera_index = feature_points(end,1);
else
    camera_index = feature_points(end,2);
end

same_camera_index_list = find(camera_index_list == camera_index);
% Find similarity by pixel index if feature points observed by same camera
if ~isempty(same_camera_index_list)
    same_camera_index = find(feature_points(same_camera_index_list,7) == feature_points(end,7) &  feature_points(same_camera_index_list,8) == feature_points(end,8));
    if ~isempty(same_camera_index)
        feature_index = feature_index_list(same_camera_index(1),1);
    else
        feature_index = max(feature_index_list) + 1; 
    end
else
    feature_index = max(feature_index_list) + 1; 
end
    
end