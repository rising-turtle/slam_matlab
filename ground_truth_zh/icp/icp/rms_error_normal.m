% Determine the RMS error between two point equally sized point clouds with
% point correspondance.
% ER = rms_error(p1,p2) where p1 and p2 are 3xn matrices.

function ER = rms_error_normal(p1,p2,p1_normal)
dsq = sum(power((p1 - p2).*p1_normal, 2),1);
ER = sqrt(mean(dsq));
end