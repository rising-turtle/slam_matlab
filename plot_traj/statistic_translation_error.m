%% 
% Dec. 27, 2018, He Zhang, hxzhang1@ualr.edu
% compute the translation error compared to path length 

function [ output_args ] = statistic_translation_error(fdir)

if nargin == 0
    fdir = './results/GT/vins-mono_GT'; 
    fdir = './results/GT/vins-mono_ext_GT'; 
    fdir = './results/GT/okvis_GT'; 
end

addpath('../ground_truth_zh');
f_gt = strcat('./results/GT', '/ground_truth_g.log');
T_gt = load(f_gt);

% vins_err = {};
% vins_ext_err = {};
okvis_err = {};
j = 1;

for i = 1:10 %6:15
    fname = strcat('/run_', int2str(i));
    % fname = strcat(fname, '.csv');
    fname = strcat(fname, '.log');
    fname = strcat(fdir, fname);
    
    T = load(fname); 
    T = transform_to_first(T);
    [T, Te] = align_transform(T, T_gt);
    % vins_err{j} = Te;
    % vins_ext_err{j} = Te; 
    okvis_err{j} = Te; 
    j= j+1;
end

% save('vins-mono_err.mat', 'vins_err');
% save('gt.mat', 'T_gt');
% save('vins-mono_ext_err.mat', 'vins_ext_err');
save('okvis_err.mat', 'okvis_err');

end

    

