% Plot the result of computational time of icp
%
% Author : Soonhac Hong (sxhong1@uarl.edu)
% Date : 1/22/13

function plot_icp_ct(file_name)
ct_data = load(file_name);
ct = ct_data(:,3);

figure;
plot(ct,'b.');
ylabel('Computatoinal Time [sec]')
set(gca,'FontSize',12,'FontWeight','bold');
h_ylabel = get(gca,'YLabel');
set(h_ylabel,'FontSize',12,'FontWeight','bold'); 

[ct_mean, ct_std] = compute_ct_statistics(ct_data);
figure;
errorbar(ct_mean, ct_std,'r');


icp_ct_max = max(ct)
icp_ct_mean = mean(ct)
icp_ct_median = median(ct)
icp_ct_min = min(ct)
end