% Find pairs between two 3D point sets by using T pattern
%
% Author : Soonhac Hong (sxhong1@ualr.edu)
% Date : 2/18/14
% 
% Input : gt_total : [time_stamp [x y z]*5]

function [ gt_total_pair ] = find_pair_tp( gt_total )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%addpath('..\icp');
%addpath('D:\Soonhac\SW\icp'); % original code
%addpath('C:\Yiming\ground_truth_soonhac\icp'); % added by Yimin Zhao on @06/12/2015$
% figure;
plot_colors={'b.','r.','g.','m.','c.'};
%gt_total_pair=gt_total(1,:);  % copy the first data
for i=1:size(gt_total,1)
    %new_gt = [];
    gt_total_pair(i,1) = gt_total(i,1);
    min_idx_prev=[];
    prev=[];
    cur=[];
    distance=[];
    for j=1:5
        %prev = [prev; gt_total_pair(i-1,2+(j-1)*3:4+(j-1)*3)];
        cur = [cur; gt_total(i,2+(j-1)*3:4+(j-1)*3)];
    end

        % Find T pattern
        cur_idx =[];
        cur_mean = mean(cur);
        for k=1:5
            distance(k) = norm(cur(k,:) - cur_mean);
        end
        [~, sort_idx] = sort(distance);
        cur_idx(1:2,1) = [sort_idx(1);sort_idx(2)];
        temp_cur_1 = cur(sort_idx(1),:);
        temp_cur_2 = cur(sort_idx(2),:);
        v1 = temp_cur_2-temp_cur_1;
        for k=3:5
            %three_markers=[temp_cur_1;temp_cur_2;cur(sort_idx(k),:)];
            v=cur(sort_idx(k),:)- temp_cur_1; 
            theta(k-2) = asin(norm(cross(v,v1))/(norm(v)*norm(v1)));
            %d(k-2)=det(cross(v1,v));
            %[plane error]= fit([three_markers(:,1),three_markers(:,2)],three_markers(:,3),'poly11');
            %fit_error(k-2) = error.sse;
        end
        [~, min_idx] = min(theta);
        temp_cur_3 = cur(sort_idx(min_idx+2),:);
        cur_idx(3,1) = sort_idx(min_idx+2);
        
        if norm(diff([temp_cur_1;temp_cur_3])) > norm(diff([temp_cur_2;temp_cur_3]))
            cur_idx(1:2,1) = sort_idx(1:2);
        else
            cur_idx(1,1) = sort_idx(2);
            cur_idx(2,1) = sort_idx(1);
        end
        
        find_idx=4;
        for n=1:5
            t=find(cur_idx==n);
            if isempty(t)
                cur_idx(find_idx,1) = n;
                find_idx=find_idx+1;
            end
        end
        
%         % find temp_cur_4 and temp_cur_5
%         cur45=cur;
%         cur45(cur_idx,:) = [];
%         v3=cur(cur_idx(1,1),:) - cur(cur_idx(3,1),:);
%         v4=cur45(1,:)-cur(cur_idx(3,1),:);
%         v5=cur45(2,:)-cur(cur_idx(3,1),:);
%         %theta4 = asin(norm(cross(v3,v4))/(norm(v4)*norm(v3)));
%         %theta5 = asin(norm(cross(v3,v5))/(norm(v5)*norm(v3)));
%         if v4(1)*v4(3) < 0 && v5(1)*v5(1) > 0
%             find_idx=4;
%             for n=1:5
%                 t=find(cur_idx==n);
%                 if isempty(t)
%                     cur_idx(find_idx,1) = n;
%                     find_idx=find_idx+1;
%                 end
%             end
%         else
%             find_idx=5;
%             for n=1:5
%                 t=find(cur_idx==n);
%                 if isempty(t)
%                     cur_idx(find_idx,1) = n;
%                     find_idx=find_idx-1;
%                 end
%             end
%         end
        
        % determin temp_cur1 and temp_cur2
        
        % Run ICP
        %[match, TR, TT, ER, t] = icp_match(prev', cur', 20);
        %[match, TR, TT, ER, t] = icp_match(prev', cur', 20,'Minimize','lmaPoint');  % {point} | plane | lmaPoint
        
%         diff_dist=[];
%         for k=1:5
%             pre = gt_total(i-1,2+(k-1)*3:4+(k-1)*3);
%             diff_dist = [diff_dist; norm(pre - cur)];
%         end
%         diff_dist(min_idx_prev)=intmax;
%         [~, min_idx] = min(diff_dist);
%         min_idx_prev = [min_idx_prev; min_idx];

        %gt_total_pair(i,2:end)=new_cur; 
        
    for k=1:5
        gt_total_pair(i,2+(k-1)*3:4+(k-1)*3)=cur(cur_idx(k),:); 
        
        %degbug by showing plot
%         plot3(cur(cur_idx(k),1),cur(cur_idx(k),2),cur(cur_idx(k),3),plot_colors{k});
%         hold on;
    end

    
    %gt_total_pair = [gt_total_pair; new_gt];
end

end

