function save_graph_isp(gtsam_pose, file_name_pose, isgframe)

import gtsam.*

data_name_list = {'ODOMETRY','LANDMARK','EDGE3','VERTEX_SE3'};
keys = KeyVector(gtsam_pose.keys);

isp_fd = fopen(file_name_pose, 'w');
initial_max_index = keys.size-1;
for i=0:initial_max_index
    key = keys.at(i);
    x = gtsam_pose.at(key);
    T = x.matrix();
    if strcmp(isgframe, 'gframe')
        e= R2e(T(1:3,1:3));
        rx = e(1);
        ry = e(2);
        rz = e(3); 
    else
        [ry, rx, rz] = rot_to_euler(T(1:3,1:3));
    end
    fprintf(isp_fd,'%s %d %f %f %f %f %f %f\n', data_name_list{4}, i, x.x, x.y, x.z, rx, ry, rz);
end
fclose(isp_fd);



end