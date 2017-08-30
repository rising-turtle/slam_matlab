% 
% transform point cloud given [R t]
% Author : David Zhang (hxzhang1@ualr.edu)
% Date : 10/23/15


function [pc] = transform_pc(pc, R, t)

[m, n] = size(pc); 
loop_n = n/3;
translation = repmat(t, 1, m);

for i=1:loop_n
    pc_T = pc(:,(i-1)*3+1:i*3)';
    pc_T =  R*pc_T + translation;
    pc(:, (i-1)*3+1:i*3) = pc_T'; 
end

end