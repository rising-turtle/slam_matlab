function [ct_mean, ct_median, ct_std] = compute_ct_statistics(ct_data)
% Compute computational cost at each step
ct = ct_data(:,3);
step = abs(ct_data(:,1) - ct_data(:,2));
step_size_max = max(unique(step));
for i=1:step_size_max
    idx = find(step == i);
    ct_mean(i) = mean(ct(idx));
    ct_median(i) = median(ct(idx));
    ct_std(i) = std(ct(idx));
end

end