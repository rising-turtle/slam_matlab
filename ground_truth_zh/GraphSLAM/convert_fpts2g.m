function [g_fpts g_fpts_edges] = convert_fpts2g(pose_index, e_fpts)

% Generate an index of feature points on the global poses
disp('Generate an index of feature points on the global poses.');

g_fpts_edges = [];
g_fpts = [];
global_fpts_index = max(pose_index);

for i=1:size(e_fpts,1)
    unit_cell = e_fpts{i,1};
    for j = 1:size(unit_cell,1)
        if isempty(g_fpts_edges)
            global_fpts_index = global_fpts_index + 1;
            new_index = global_fpts_index;
            g_fpts = [g_fpts; new_index unit_cell(j,2:4)];
        else
            [duplication_index, duplication_flag] = check_duplication(g_fpts_edges(:,2:5), unit_cell(j,:));
            if duplication_flag == 0
                global_fpts_index = global_fpts_index + 1;
                new_index = global_fpts_index;
                g_fpts = [g_fpts; new_index unit_cell(j,2:4)];
            else
                new_index = duplication_index;
            end
        end
        g_fpts_edges = [g_fpts_edges; unit_cell(j,1) new_index unit_cell(j,2:7)];
    end
end
end