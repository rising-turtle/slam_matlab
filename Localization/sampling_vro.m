% Sampling VRO with interval
%
% Author : Soonhac Hong (sxhong1@ualr.edu)
% Date : 12/13/13

function sampling_vro()

% Load data
file_name = '498_frame_abs_intensity_sift_i_r_s_i_t_t_c_i_a_c_c_featureidxfix_fast_fast_dist2_nobpc_20st_gaussian_0.dat';
vro = load(file_name);

% Sample VRO with interval
interval = 15;
new_vro=[];
vro_idx = 1;
success_flag = 1;

while vro_idx <= (max(vro(:,1))-interval)
    idx = find(vro(:,1)==vro_idx & vro(:,2) == (vro_idx+interval));
    if ~isempty(idx)
        new_vro=[new_vro; vro(idx,:)];
        vro_idx = vro_idx+interval;
    else
        success_flag = 0;
        disp('Faile to sample vro results');
        break;
    end     
end

% Write results
if success_flag == 1
    output_file_name = sprintf('result\\object_recognition\\indoor_monitor_1\\498_frame_abs_intensity_sift_i_r_s_i_t_t_c_i_a_c_c_featureidxfix_fast_fast_dist2_nobpc_20st_gaussian_0_monitor1_s%d.dat', interval);
    output_fd = fopen(output_file_name,'w');
    fprintf(output_fd,'%d %d %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f\n', new_vro');
    fclose(output_fd);
end

end