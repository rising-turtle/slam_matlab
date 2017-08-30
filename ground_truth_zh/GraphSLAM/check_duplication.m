% Check single data duplication in data set
% Author : Soonhac Hong (sxhong1@ualr.edu)
% Date : 3/21/12

function [duplication_index, duplication_flag] = check_duplication(data_set, data)
    duplication_index = 0;
    duplication_flag = 0;
    distance_threshold = 41;   % [mm]; typical absolute accuracy + 3 * typical repeatibility of SR4000 = 20 + 3 * 7 = 41
    for i=1:size(data_set,1)
        distance = sqrt(sum((data_set(i,2:4)-data(2:4)).^2));
        if distance <= distance_threshold
            duplication_flag = 1;
            duplication_index = data_set(i,1);
            break;
        end
    end
end