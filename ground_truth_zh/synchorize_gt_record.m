% 
% synchorize the timestamp between motion capture and camera record
% 
% Author : David Zhang (hxzhang1@ualr.edu)
% Date : 10/28/15

function [gt, gt_total] = synchorize_gt_record(gt_fname, record_log)
clc 
if nargin == 0
    %% Load motion capture data
    % gt_fname = '.\motion_capture_data\test_10_16_2015\Take 2015-10-16 04.49.46 PM.csv';
    % record_log = '.\motion_capture_data\test_10_16_2015\timestamp_04.49.46.log';
    gt_fname = './motion_capture_data/test_10_16_2015/Take 2015-10-16 04.25.55 PM.csv';
    record_log = './motion_capture_data/test_10_16_2015/timestamp_04.25.55.log';
end

%% load gt data 
fid = fopen(gt_fname); 
if fid < 0
    error(['Cannot open file ' data_file_name]);
end
[line_data, gt, gt_total] = scan_data(fid); 

gt_time_seq = gt(:,1);
% gt_time_base = repmat(gt_time_seq(1), size(gt_time_seq,1), 1);
% gt_time_shift = gt_time_seq - gt_time_base; 

%% load camera record data 
% fid = fopen(record_log); 
camera_record_data = load(record_log);
cr_time_seq = camera_record_data(:, 2); 
cr_time_base = repmat(cr_time_seq(1), size(cr_time_seq,1), 1);
cr_time_seq = cr_time_seq - cr_time_base;

%% find the synchronize start point 
global g_index 
g_index = 1; 
potential_syn_points = find(cr_time_seq > gt_time_seq(1)); 
for i=1:size(potential_syn_points)
    cr_index = potential_syn_points(i);
    gt_index = find_syn_index(cr_time_seq(cr_index), gt_time_seq); 
    if gt_index ~= -1
        break;
    end
end

%% delete the non-synchronize part 
M = size(gt,1); 
gt = gt(gt_index:M, :); 
gt_total = gt_total(gt_index:M, :); 

fprintf('synchorize_gt_record.m: gt_index %d, cr_index %d\n', gt_index, cr_index);

end

function index = find_syn_index(cr_elapse_time, gt_time_seq)
    global g_index 
    
    %% gt has 120 hz, 1/120 ~ 0.0083 
    gt_time_span_upper = 0.009;
    while g_index < size(gt_time_seq,1)
        cur_t = gt_time_seq(g_index); 
        if abs(cur_t - cr_elapse_time) < gt_time_span_upper
            index =  g_index;
            break; 
        end
        if cur_t > cr_elapse_time
            index = -1;
            break;
        end
        g_index = g_index+1;
    end

end




