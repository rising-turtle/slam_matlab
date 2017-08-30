function compute_trajectory_error(org_poses, opt_poses)

%Compute trajectory percentage error
% org_poses(end,:)
% opt_poses(end,:)
org_poses_first_last_distance = sqrt(sum(abs(org_poses(1,:)-org_poses(end,:)).^2))
opt_poses_first_last_distance = sqrt(sum(abs(opt_poses(1,:)-opt_poses(end,:)).^2))

%Compute trajectory length
org_poses_trajectory_length = 0;
opt_poses_trajectory_length = 0;
for i=1:size(org_poses,1)-1
    org_poses_trajectory_length = org_poses_trajectory_length +  sqrt(sum(abs(org_poses(i,:)-org_poses(i+1,:)).^2));
end
for i=1:size(org_poses,1)-1
    opt_poses_trajectory_length = opt_poses_trajectory_length +  sqrt(sum(abs(opt_poses(i,:)-opt_poses(i+1,:)).^2));
end
org_poses_trajectory_length 
opt_poses_trajectory_length

%Compute percentage error
org_poses_trajectory_error = org_poses_first_last_distance * 100 / org_poses_trajectory_length
opt_poses_trajectory_error = opt_poses_first_last_distance * 100 / opt_poses_trajectory_length

% %Compute height error
% org_poses_delta = abs(org_poses - repmat(org_poses(1,:), size(org_poses,1),1));
% opt_poses_delta = abs(opt_poses - repmat(opt_poses(1,:), size(opt_poses,1),1));
% 
% mean_org_poses_delta_height = mean(org_poses_delta(:,3))
% mean_opt_poses_delta_height = mean(opt_poses_delta(:,3))
% 
% % Show height error
% figure;
% plot(org_poses_delta(:,3),'b-');
% hold on;
% plot(opt_poses_delta(:,3),'r-');
% legend('vro','gtsam');
% grid;
% ylabel('height error [m]');
% xlabel('Step');
% hold off;

end