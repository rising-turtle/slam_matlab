% Convert map based its locations
% 
% Author : Soonhac Hong (sxhong1@ualr.edu)
% Date : 5/16/14


function Convert_map_culling()

%input_file_name = 'D:\Soonhac\SW\GraphSLAM\results\isam\3d\revisiting9_10m_Replace_pose_zero_827_vro_gtsam_feature_total_v1.ply';
%output_file_name = 'D:\Soonhac\SW\GraphSLAM\results\isam\3d\revisiting9_10m_Replace_pose_zero_827_vro_gtsam_feature_total_v21.ply';

input_file_name = 'D:\Soonhac\SW\GraphSLAM\results\isam\3d\revisiting9_10m_Replace_pose_zero_827_vro_gtsam_feature_v2.ply';
output_file_name = 'D:\Soonhac\SW\GraphSLAM\results\isam\3d\revisiting9_10m_Replace_pose_zero_827_vro_gtsam_feature_v3.ply';


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
x_threshold_min = -4;
x_threshold_max = 0.5;
y_threshold_min = -3;
y_threshold_max = 7;
z_threshold = -0.67;
new_data=[];
new_data_index = 1;
for i=1:size(lines,1)
    i
    line_i=lines{i};
    if i > 12  % check intensity data
        if mod(i,2) == 0
            v = textscan(line_i,'%f %f %f %d %d %d',1);
            new_data(new_data_index, :)=[v{1},v{2},v{3},double(v{4}),double(v{5}),double(v{6})];
            new_data_index = new_data_index + 1;
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

