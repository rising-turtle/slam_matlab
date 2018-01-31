function [ valid_flag ] = check_marker_pattern(marker)
distance_treshold = 0.305*3/4; % three quaters of distance of the left marker and right marker [m]

valid_flag = false;

nMarker = size(marker,1);
if nMarker ==2
    %Compute length between markers and check the length
    distance = abs(norm(marker(1,:)) - norm(marker(2,:)));
    if distance > distance_treshold
        valid_flag = true;
    end
elseif nMarker == 3
    %Check three markers in a straight line
    distance_1 = abs(norm(marker(1,:)) - norm(marker(2,:)));
    distance_2 = abs(norm(marker(1,:)) - norm(marker(3,:)));
    if abs(distance_1 - distance_2) <= 0.10  % first marker locates at the center
        v1 = marker(3,:) - marker(2,:);
        v2 = marker(1,:) - marker(2,:);
        slope1=atan(norm(v1(1:2))/norm(v1));
        slope2=atan(norm(v2(1:2))/norm(v2));
    else
        v1 = marker(3,:) - marker(1,:);
        v2 = marker(2,:) - marker(1,:);
        slope1=atan(norm(v1(1:2))/norm(v1));
        slope2=atan(norm(v2(1:2))/norm(v2));
    end
    if abs(slope1 - slope2) < (20*pi()/180)
        valid_flag = true;
    end
elseif nMarker == 5
    % compute normal vector from three point; the first point is origin
    % point
    v = marker(2:5,:) - repmat(marker(1,:), 4, 1);
    n = cross(v(1,:),v(2,:));
    
    d1 = dot(n,v(3,:));
    d2 = dot(n,v(4,:));
    
    normal_thresh = 0.001;
    
    % Compute distance from mean point
    mean_marker = mean(marker);
    distance_valid = true;
    distance_thresh = 0.2;  % 20 cm
    for i=1:5
        if norm(marker(i,:) - mean_marker) > distance_thresh
            distance_valid = false;
            break;
        end
    end
        
    if d1 < 0
        d1 = d1 * -1.;
    end
    if d2 < 0
        d2 = d2 * -1.;
    end
    
    if d1 <= normal_thresh && d2 <= normal_thresh && distance_valid
        valid_flag = true;
    end
else
    % find three markers in a straight line.
    % 
    valid_flag = false;
end

end

