% Compensate the missing pose
% Author : Soonhac Hong (sxhong1@ualr.edu)
% Date : 4/19/20

function [new_f_index, new_t_pose, new_o_pose, new_fpts_index, new_pose_std] = compensate_vro(f_index, t_pose, o_pose, fpts_index, pose_std, pose_std_flag, cmp_option)

cur_index = f_index(1,1);
new_index = 1;
f_index_length = size(f_index,1);
new_fpts_index = [];
new_pose_std = [];

if strcmp(cmp_option,'Replace')      
    for i = 1:f_index_length
        missing_index = [0 0];
        if f_index(i,1) == cur_index
            new_f_index(new_index,:) = f_index(i,:);
            new_t_pose(new_index,:) = t_pose(i,:);
            new_o_pose(new_index,:) = o_pose(i,:);
            if pose_std_flag == 1
                new_pose_std(new_index,:) = pose_std(i,:);
            end
        elseif f_index(i,1) == cur_index + 1
            cur_index = f_index(i,1);
            new_f_index(new_index,:) = f_index(i,:);
            new_t_pose(new_index,:) = t_pose(i,:);
            new_o_pose(new_index,:) = o_pose(i,:);
            if pose_std_flag == 1
                new_pose_std(new_index,:) = pose_std(i,:);
            end
        else    % missing constraints
            n_missing_index = f_index(i,1) - (cur_index + 1);
            missing_index = missing_index + [n_missing_index n_missing_index];
            %         t_pose_compensation = (t_pose(i,:) + t_pose(i-1,:))/2;
            %         o_pose_compensation = (o_pose(i,:) + o_pose(i-1,:))/2;
            %         for k=1:n_missing_index
            %             new_f_index(new_index,:) = [cur_index+k, cur_index+k+1];
            %             new_t_pose(new_index,:) = t_pose_compensation;
            %             new_o_pose(new_index,:) = o_pose_compensation;
            %             new_index = new_index + 1
            %         end
            cur_index = f_index(i,1) - missing_index(1);
            new_f_index(new_index,:) = f_index(i,:) - missing_index;
            new_t_pose(new_index,:) = t_pose(i,:);
            new_o_pose(new_index,:) = o_pose(i,:);
            if pose_std_flag == 1
                new_pose_std(new_index,:) = pose_std(i,:);
            end
            f_index(i:f_index_length,:) = f_index(i:f_index_length,:) - repmat(missing_index, f_index_length-i+1, 1);          
        end
        new_index = new_index + 1;
    end
    % check successiveness of second pose
    index_diff = diff(new_f_index,1,1);
    for i=1:size(index_diff,1);
        if index_diff(i,2) ~= 1 && index_diff(i,1) == 0
            new_f_index(i+1,2) = new_f_index(i,2) + 1;      
        end
    end
    
    % check consecutive of neighbor pose
    index_diff = diff(new_f_index,1,1);
    % Comment out for loop closure
    for i=2:size(new_f_index,1);
        if abs(new_f_index(i,1)-new_f_index(i,2)) >= 2 && abs(new_f_index(i,1)-new_f_index(i-1,1)) ~= 0
            new_f_index(i,2) = new_f_index(i,1) + 1;      
        end
    end
    
    % Adjuste index of features
    if ~isempty(fpts_index)
        fpts_index_length = size(fpts_index,1);
        new_index = 1;
        cur_index = fpts_index(1,1);
        for i = 1:fpts_index_length
            if fpts_index(i,1) == cur_index
                new_fpts_index(new_index,:) = fpts_index(i,:);
            elseif fpts_index(i,1) == cur_index + 1
                cur_index = fpts_index(i,1);
                new_fpts_index(new_index,:) = fpts_index(i,:);
            else    % missing constraints
                n_missing_index = fpts_index(i,1) - (cur_index + 1);
                missing_index = [n_missing_index n_missing_index];
                cur_index = fpts_index(i,1) - missing_index(1);
                new_fpts_index(new_index,:) = fpts_index(i,:) - missing_index;
                fpts_index(i:fpts_index_length,:) = fpts_index(i:fpts_index_length,:) - repmat(missing_index, fpts_index_length-i+1, 1);
            end
            new_index = new_index + 1;
        end
        % check successiveness of second pose
        index_diff = diff(new_fpts_index,1,1);
        for i=1:size(index_diff,1);
            if index_diff(i,2) > 1 && index_diff(i,1) == 0
                update_index = find(new_fpts_index(:,1) == new_fpts_index(i+1,1) & new_fpts_index(:,2) == new_fpts_index(i+1,2));
                new_fpts_index(update_index,2) = new_fpts_index(i,2) + 1;
            end
        end
    end
elseif strcmp(cmp_option,'Linear')
    missing_index = 0;
    for i = 1:f_index_length
        if f_index(i,1) == cur_index
            new_f_index(new_index,:) = f_index(i,:);
            new_t_pose(new_index,:) = t_pose(i,:);
            new_o_pose(new_index,:) = o_pose(i,:);
            if pose_std_flag == 1
                new_pose_std(new_index,:) = pose_std(i,:);
            end
        elseif f_index(i,1) == cur_index + 1
            cur_index = f_index(i,1);
            new_f_index(new_index,:) = f_index(i,:);
            new_t_pose(new_index,:) = t_pose(i,:);
            new_o_pose(new_index,:) = o_pose(i,:);
            if pose_std_flag == 1
                new_pose_std(new_index,:) = pose_std(i,:);
            end
        else    % missing constraints
            n_missing_index = f_index(i,1) - (cur_index + 1);
            missing_index = missing_index + n_missing_index;
            t_pose_compensation = (t_pose(i,:) + t_pose(i-1,:))/2;
            o_pose_compensation = (o_pose(i,:) + o_pose(i-1,:))/2;
            if pose_std_flag == 1
                pose_std_compensation = (pose_std(i,:) + pose_std(i-1,:))/2;
            end
            for k=1:n_missing_index
                new_f_index(new_index,:) = [cur_index+k, cur_index+k+1];
                new_t_pose(new_index,:) = t_pose_compensation;
                new_o_pose(new_index,:) = o_pose_compensation;
                if pose_std_flag == 1
                    new_pose_std(new_index,:) = pose_std_compensation; 
                end
                new_index = new_index + 1;
            end
            cur_index = f_index(i,1);
            new_f_index(new_index,:) = f_index(i,:);
            new_t_pose(new_index,:) = t_pose(i,:);
            new_o_pose(new_index,:) = o_pose(i,:);
            if pose_std_flag == 1
                new_pose_std(new_index,:) = pose_std(i,:);
            end
        end
        new_index = new_index + 1;
    end
    % check successiveness of second pose
    tmp_new_f_index = new_f_index;
    tmp_new_t_pose = new_t_pose;
    tmp_new_o_pose = new_o_pose;
    tmp_new_pose_std = new_pose_std;
    new_f_index = [];
    new_t_pose = [];
    new_o_pose = [];
    new_pose_std = [];
    
    index_diff = diff(tmp_new_f_index,1,1);
    new_index = 1;
    for i=1:size(index_diff,1);
        new_f_index(new_index,:) = tmp_new_f_index(i,:);
        new_t_pose(new_index,:) = tmp_new_t_pose(i,:);
        new_o_pose(new_index,:) = tmp_new_o_pose(i,:);
        if pose_std_flag == 1
            new_pose_std(new_index,:) = tmp_new_pose_std(i,:);
        end
        new_index = new_index + 1;
        if index_diff(i,2) ~= 1 && index_diff(i,1) == 0
        %if (index_diff(i,2) - index_diff(i,1)) >= 1
            t_pose_compensation = (tmp_new_t_pose(i,:) + tmp_new_t_pose(i-1,:))/2;
            o_pose_compensation = (tmp_new_o_pose(i,:) + tmp_new_o_pose(i-1,:))/2;
            if pose_std_flag == 1
                pose_std_compensation = (tmp_new_pose_std(i,:) + tmp_new_pose_std(i-1,:))/2;
            end
            for k=1:index_diff(i,2)-1
                new_f_index(new_index,:) = [tmp_new_f_index(i,1), tmp_new_f_index(i,2)+k];
                new_t_pose(new_index,:) = t_pose_compensation;
                new_o_pose(new_index,:) = o_pose_compensation;
                if pose_std_flag == 1
                    new_pose_std(new_index,:) = pose_std_compensation;
                end
                new_index = new_index + 1;
            end
        end
    end
    new_f_index(new_index,:) = tmp_new_f_index(i+1,:);
    new_t_pose(new_index,:) = tmp_new_t_pose(i+1,:);
    new_o_pose(new_index,:) = tmp_new_o_pose(i+1,:);
    if pose_std_flag == 1
        new_pose_std(new_index,:) = tmp_new_pose_std(i+1,:);
    end
    
    % check consecutive of neighbor pose
    tmp_new_f_index = new_f_index;
    tmp_new_t_pose = new_t_pose;
    tmp_new_o_pose = new_o_pose;
    if pose_std_flag == 1
        tmp_new_pose_std = new_pose_std;
    end
    new_f_index = tmp_new_f_index(1,:);
    new_t_pose = tmp_new_t_pose(1,:);
    new_o_pose = tmp_new_o_pose(1,:);
    if pose_std_flag == 1
        new_pose_std = tmp_new_pose_std(1,:);
    end
    new_index = 2;
    for i=2:size(tmp_new_f_index,1);
        if abs(tmp_new_f_index(i,1) - tmp_new_f_index(i,2)) >= 2 && abs(tmp_new_f_index(i,1) - tmp_new_f_index(i-1,1)) ~= 0
            %new_f_index(i,2) = new_f_index(i,1) + 1;
            t_pose_compensation = (tmp_new_t_pose(i,:) + tmp_new_t_pose(i-1,:))/2;
            o_pose_compensation = (tmp_new_o_pose(i,:) + tmp_new_o_pose(i-1,:))/2;
            if pose_std_flag == 1
                pose_std_compensation = (tmp_new_pose_std(i,:) + tmp_new_pose_std(i-1,:))/2;
            end
            interval = abs(tmp_new_f_index(i,1)-tmp_new_f_index(i,2)) - 1;
            for k=1:interval
                new_f_index(new_index,:) = [tmp_new_f_index(i,1), tmp_new_f_index(i,1)+k];
                new_t_pose(new_index,:) = t_pose_compensation;
                new_o_pose(new_index,:) = o_pose_compensation;
                if pose_std_flag == 1
                    new_pose_std(new_index,:) = pose_std_compensation;
                end
                new_index = new_index + 1;
            end
        end
        new_f_index(new_index,:) = tmp_new_f_index(i,:);
        new_t_pose(new_index,:) = tmp_new_t_pose(i,:);
        new_o_pose(new_index,:) = tmp_new_o_pose(i,:);
        if pose_std_flag == 1
            new_pose_std(new_index,:) = tmp_new_pose_std(i,:);
        end
        new_index = new_index + 1;
    end
end

% Reduce the constraints
% tmp_new_f_index = new_f_index;
% tmp_new_t_pose = new_t_pose;
% tmp_new_o_pose = new_o_pose;
% new_f_index = tmp_new_f_index(1,:);
% new_t_pose = tmp_new_t_pose(1,:);
% new_o_pose = tmp_new_o_pose(1,:);
% new_index = 2;
% 
% min_edge = 1;
% unit_edge_cnt = 1;
% 
% for i=2:size(tmp_new_f_index,1)
%     if tmp_new_f_index(i,1) ~= tmp_new_f_index(i-1,1)
%         new_f_index(new_index,:) = tmp_new_f_index(i,:);
%         new_t_pose(new_index,:) = tmp_new_t_pose(i,:);
%         new_o_pose(new_index,:) = tmp_new_o_pose(i,:);
%         new_index = new_index + 1;
%         unit_edge_cnt = 1;
%     elseif unit_edge_cnt < min_edge
%         new_f_index(new_index,:) = tmp_new_f_index(i,:);
%         new_t_pose(new_index,:) = tmp_new_t_pose(i,:);
%         new_o_pose(new_index,:) = tmp_new_o_pose(i,:);
%         new_index = new_index + 1;
%         unit_edge_cnt = unit_edge_cnt + 1;
%     end
% end

end