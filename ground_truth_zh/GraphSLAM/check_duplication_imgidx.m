% Check single data duplication in data set by image index
% Author : Soonhac Hong (sxhong1@ualr.edu)
% Date : 2/5/13

function [duplication_index, duplication_flag] = check_duplication_imgidx(data_set, data, imgidx_distance_threshold)
    duplication_index = 0;
    duplication_flag = 0;
    %distance_threshold = 41;   % [mm]; typical absolute accuracy + 3 * typical repeatibility of SR4000 = 20 + 3 * 7 = 41
    %imgidx_distance_threshold = 2;   % 2 pixel error tolerance
    for i=1:size(data_set,1)
        imgidx_distance = sqrt(sum((data_set(i,end-1:end)-data(end-1:end)).^2));
        
        if imgidx_distance <= imgidx_distance_threshold && imgidx_distance > 0
            duplication_flag = 1;
            duplication_index = data_set(i,1);
            break;
        end
    end
end