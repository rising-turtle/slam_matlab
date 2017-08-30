function [es_syn, gt_syn] = syn_time_with_gt(es, gt)
%
% this function assumes that the time span of ground truth is larger than  
% that of estimated trajectory, which is guaranteed by stop recording
% camera before turn off motion capture system 
%
    gt_syn = zeros(size(gt));
    es_syn = zeros(size(es));
    
    es_t = es(:,1);
    es_t_elapse = es_t(:) - es_t(1); 
    gt_syn(1,:) = gt(1,:); 
    es_syn(1,:) = es(1,:);
    
    %% manually time offset, it seems that the two time sequence do not occur at the same start point 
    % compensate using the position information, figure out which point
    % matches best
    timestamp_offset = 0.4224; % for dataset_3 
    
    %% find synchronized index in gt, syn_gt_index given the estimated time index
    gt_start_time = gt(1,1); 
    gt_index = 1; 
    syn_gt_index = 2;
    %% gt has 120 hz, 1/120 ~ 0.0083 
    gt_time_span_upper = 0.009; 
    for i=2:size(es_t_elapse,1)
        time_passed = es_t_elapse(i) - timestamp_offset;
        if time_passed <= 0
            continue;
        end
        while gt_index < size(gt,1)
            cur_gt = gt(gt_index,1) - gt_start_time;
            if abs(time_passed - cur_gt) < gt_time_span_upper %% found it 
                gt_syn(syn_gt_index, :) = gt(gt_index, :);
                es_syn(syn_gt_index, :) = es(i, :);
                syn_gt_index = syn_gt_index + 1; 
                gt_index = gt_index + 1;
                break;
            elseif cur_gt > time_passed %% failed to find it 
                break;
            end
            gt_index = gt_index + 1; 
        end
    end
    gt_syn(syn_gt_index:end, :) = [];
    es_syn(syn_gt_index:end, :) = [];
end