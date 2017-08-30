% Convert the color of a trajectory in the polygon file format (*.ply) for Meshlab
%
% Input parameters :
%     input_file_name : Input file name in the polygon file format
%     output_file_name : Output file name in the polygon file format
%     threshold : Cut-off threshold of intensity values
% Usage :Convert_trajectory_color('pm_trajectory.ply', 'pm_trajectory_new_color.ply', [0,0,255])
% 
% Author : Soonhac Hong (sxhong1@ualr.edu)
% Date : 5/16/14


function Convert_trajectory_threshold(input_file_name, output_file_name, threshold)

%% Load an input file
fid = fopen(input_file_name);
if fid < 0
    error(['Cannot open file ' input_file_name]);
end

% scan all lines into a cell array
columns=textscan(fid,'%s','delimiter','\n');
lines=columns{1};
fclose(fid);

%% Convert the color of a trajectory
new_data=[];
for i=1:size(lines,1)
    i
    line_i=lines{i};
    if i > 12  % check intensity data
        v = textscan(line_i,'%f %f %f %d %d %d',1);
        if v{4} > threshold
            new_data=[new_data; [v{1},v{2},v{3},double(v{4}),double(v{5}),double(v{6})]];
            %fprintf(fd,'%f %f %f %d %d %d\n',v{1},v{2},v{3}, target_color);
        end
    end
end

%% Write data
ply_headers={'ply','format ascii 1.0','comment Created with XYZRGB_to_PLY', 'element_vertex_dummy', 'property float x', 'property float y','property float z','property uchar red','property uchar green','property uchar blue','end_header'};
nply_data = size(new_data,1)
element_vertex_n = sprintf('element vertex %d',nply_data);
ply_headers{4} = element_vertex_n;

fd = fopen(output_file_name, 'w');
for i=1:size(ply_headers,2)
    fprintf(fd,'%s\n',ply_headers{i});
end

for i=1:nply_data
    fprintf(fd,'%f %f %f %d %d %d\n',new_data(i,:));
end

fclose(fd);

end

