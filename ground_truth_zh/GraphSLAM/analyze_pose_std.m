% Analyze standard deviation of motion estimation by VRO, VRO_ICP.
%
% Author : Soonhac Hong (sxhong1@ualr.edu)
% Date : 3/1/13

function [median_pose_std, std_pose_std, unique_step, step1_pose_std_total, step1_pose_std] = analyze_pose_std(f_index, pose_std, verbosity)
step = abs(f_index(:,1)-f_index(:,2));
unique_step = unique(step);

plot_colors={'gd','k*','md','rs','bv','r+','m*','g^','b<','r>','mp','gh'};
title_list = {'ry','rx','rz','x','y','z'};
median_pose_std = zeros(size(unique_step,1),6);
std_pose_std = zeros(size(unique_step,1),6);
% Show all standard deviation
for k=1:6
%     if verbosity == 1
%         figure;
%     end
    for i=1:size(unique_step,1)
        step_idx = find(step == unique_step(i));
%         if verbosity == 1
%             if k < 4
%                 plot(pose_std(step_idx,k).*180./pi,plot_colors{i});
%             else
%                 plot(pose_std(step_idx,k),plot_colors{i});
%             end
%             hold on;
%         end
        median_pose_std(i,k) = median(pose_std(step_idx,k));
        std_pose_std(i,k) = std(pose_std(step_idx,k));
    end
    if verbosity == 1
        %hold off;
        %title(title_list{k});
        %legend('s1','s2','s3','s4','s5');
        figure;
        %plot(median_pose_std(:,k),'o-');
        if k < 4
            errorbar(median_pose_std(:,k).*180./pi,std_pose_std(:,k).*180./pi,'bo-');
            ylabel('[degree]');
        else
            errorbar(median_pose_std(:,k),std_pose_std(:,k),'bo-');
            ylabel('[m]');
        end
        title(title_list{k});
    end
end

%Save step1 pose std
step1_pose_std_total=[];
step1_pose_std=[];
step1_pose_std_temp=[];
for i=1:size(step,1)
    if step(i) == 1
        step1_pose_std_total(i,:) = pose_std(i,:);
        step1_pose_std_temp = pose_std(i,:);
        step1_pose_std = [step1_pose_std; pose_std(i,:)];
    else
        if ~isempty(step1_pose_std_temp)
            step1_pose_std_total(i,:) = step1_pose_std_temp;
        else
            step1_pose_std_total(i,:) = pose_std(i,:);
        end
    end
end

% % plot step1
% figure(3);
% plot(step1_pose_std_debug(:,1:3));
% legend('x','y','z');
% grid;
% figure(4);
% plot(step1_pose_std_debug(:,4:6).*(180/pi));
% legend('rx','ry','rz');
% grid;

end