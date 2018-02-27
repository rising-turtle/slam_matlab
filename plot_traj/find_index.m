%% compute first index of gt, given the already matched timestamp from test_gt
function index = find_index(t, first_timestamp_pose)
    index = -1;
    %% the following two are matched 
    vt = 1498879054.726535936;
    gt = 12.125; 
    if first_timestamp_pose > 1e12
        first_timestamp_pose = first_timestamp_pose * 1e-9;
    end
    dt = vt - first_timestamp_pose;
    for i=1:size(t,1)
        if t(i) + dt >= gt
            index = i;
            break;
        end
    end
end
