function [vro_poses, g2o_poses, isam_poses] = get_optimized_data()
    file_index = 5;     % 5 = whitecane
    dynamic_index = 11;

    [g2o_result_dir_name, isam_result_dir_name, vro_dir_name, dynamic_dir_name] = get_file_names(file_index, dynamic_index);

    switch dynamic_index
        case 15
            vro_size = 3616;
        case 16
            vro_size = 5169;
        case 11
            vro_size = 84;
    end

    vro_file_name = sprintf('%s%s_%d.g2o', vro_dir_name, dynamic_dir_name, vro_size);
    g2o_result_file_name = sprintf('%s%s_%d.opt', g2o_result_dir_name, dynamic_dir_name, vro_size);
    isam_result_file_name = sprintf('%s%s_%d_isam.opt', isam_result_dir_name, dynamic_dir_name, vro_size);
    %isp_file_name = sprintf('%s%s_%d.isp', isam_dir_name, dynamic_dir_name, vro_size);


    [vro_poses vro_edges] = load_graph_g2o(vro_file_name);
    [g2o_poses g2o_edges] = load_graph_g2o(g2o_result_file_name);
    [isam_poses] = load_graph_isam(isam_result_file_name);
end