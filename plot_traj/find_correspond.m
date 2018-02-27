%% find corresponding point 
function j = find_correspond(x, timestamp, from)
    j = from;
    for i = from:size(x,1)
        if x(i) > timestamp && x(i) - timestamp < 0.03
            j = i;
            break;
        end
    end
end