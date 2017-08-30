% Eliminate the points by confidence map
function [updated_match] = confidence_filter(match, pset1_index, pset2_index, c1, c2)
% confidence_threshold = 3;
confidence_threshold_percentage = 0.4;
confidence_threshold_1 = floor((max(max(c1)) - min(min(c1))) * confidence_threshold_percentage);
confidence_threshold_2 = floor((max(max(c2)) - min(min(c2))) * confidence_threshold_percentage);

i = 1;
for m=1:size(match,2)
    if c1(pset1_index(1,m), pset1_index(2,m)) > confidence_threshold_1  && c2(pset2_index(1,m), pset2_index(2,m)) > confidence_threshold_2
        updated_match(:,i) = match(:,m);
        i = i + 1;
    end
end

end