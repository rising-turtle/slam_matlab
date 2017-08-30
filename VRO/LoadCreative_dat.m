%
% David Z, Jan 22th, 2015 
% Load Creative Data 
%

function [img, x, y, z, c, time, err] = LoadCreative_dat(data_name, j)

[prefix, confidence_read] = get_sr4k_dataset_prefix(data_name);

img = []; x = []; y = []; z = []; c = [];
err = 0;
%% time elapse
t_pre = tic;

%% load data file 
[file_name, err] = sprintf('%s%d.dat', prefix, j);

if ~exist(file_name, 'file')
    fprintf('LoadCreative_dat.m: file not exist: %s\n', file_name);
    err = 1;
    return ;
end

a = load(file_name);    % elapsed time := 0.2 sec
if isempty(a)
    fprintf('LoadCreative_dat.m: file is empty!\n');
    err  = 1;
    return;
end

row = size(a, 1);
img = a(1:row/4, :);
x = a((row/4+1):row/2, :);  
y= a(row/2+1:3*row/4, :);   
z = a(3*row/4+1:row, :);
c = zeros(size(x));

time = toc(t_pre);
end