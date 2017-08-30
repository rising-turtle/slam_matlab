% Compute covariance of vro
%
% Author : Soonhac Hong (sxhong1@ualr.edu)
% Date : 3/10/11
%
% Reference : [cov_pose_shift,q_dpose,T_dpose] = bootstrap_cov_calc(idx1,idx2)
%
function [pose_std] = compute_pose_std(op_pset1,op_pset2,rot_mean, trans_mean)

nData = size(op_pset1,2);
sampleSize = min(40,floor(0.75*nData));
nSamplePossible = factorial(nData)/(factorial(sampleSize)*factorial(nData - sampleSize));
nSample = min(50,nSamplePossible);
pose_std_total=[];
[phi_mean, theta_mean, psi_mean] = rot_to_euler(rot_mean); 
pose_mean = [phi_mean, theta_mean, psi_mean, trans_mean'];

legitSamples = 0;
for i=1:nSample
    idxRand = randsample(1:size(op_pset1,2),sampleSize);
    
    [rot, trans, sta] = find_transform_matrix(op_pset1(:,idxRand), op_pset2(:,idxRand));
    [phi, theta, psi] = rot_to_euler(rot); 
    
    pose_std_total(i,:) = [phi, theta, psi, trans'];
end
%pose_std = std(pose_std_total);
pose_std = sqrt((sum((pose_std_total - repmat(pose_mean, nSample, 1)).^2))/(nSample-1));

end