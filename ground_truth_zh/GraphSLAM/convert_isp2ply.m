% Conver isp to ply for meshlab 
%
% Author : Soonhac Hong (sxhong1@ualr.edu)
% Date : 4/1/13

function convert_isp2ply(isp_file_name, file_index, dynamic_index, isgframe, vro_name)

[poses] = load_graph_isp(isp_file_name);
isp_finder = strfind(isp_file_name,'isp');
if(isempty(isp_finder))
    ply_file_name=strrep(isp_file_name, 'opt','ply')
    if strcmp(vro_name, 'vro') == 1
        color=[255, 0, 0];  % red
    else
        color=[0, 0, 255];  % blue
    end
    is_opt_file = 1;
else
    ply_file_name=strrep(isp_file_name, 'isp','ply')
    color=[0, 255, 0];  % green
    is_opt_file = 0;
end

fd = fopen(ply_file_name, 'w');
% Write header
element_vertex_n = sprintf('element vertex %d',size(poses,1));
ply_headers={'ply','format ascii 1.0','comment Created with XYZRGB_to_PLY', element_vertex_n, 'property float x', 'property float y','property float z','property uchar red','property uchar green','property uchar blue','end_header'};

for i=1:size(ply_headers,2)
    fprintf(fd,'%s\n',ply_headers{i});
end

% Write data
for j=1:size(poses,1)
     fprintf(fd,'%f %f %f %d %d %d\n',poses(j,1:3), color);
end
fclose(fd)

if(is_opt_file == 1)
    convert_pc2ply(ply_headers, ply_file_name, poses, file_index, dynamic_index, isgframe);
    %convert_pc2ply_map_registration(ply_headers, ply_file_name, poses, file_index, dynamic_index, isgframe);
    %convert_pc2ply_map_registration_v2(ply_headers, ply_file_name, poses, file_index, dynamic_index, isgframe);
end

end


