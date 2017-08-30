%
% David Z, Jan 22th, 2015
% pre-check the save dir, if not exist, create it
%

function pre_check_dir(dir_)
global g_feature_dir g_matched_dir g_pose_std_dir
   feature_dir = sprintf('/%s', g_feature_dir); 
   match_dir = sprintf('/%s', g_matched_dir);
   not_exist_then_create(strcat(dir_, feature_dir));
   not_exist_then_create(strcat(dir_, match_dir));
   % not_exist_then_create(strcat(dir_, '/pose_std'));
   not_exist_then_create('./results');
end

function not_exist_then_create(dir_)
    if ~isdir(dir_)
        mkdir(dir_);
    end
end