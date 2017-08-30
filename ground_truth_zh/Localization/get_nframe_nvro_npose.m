% Get nFrame, vro_size, pose_size 
%
% Author : Soonhac Hong (sxhong1@ualr.edu)
% Date : 8/9/13


function [nFrame, vro_size, pose_size, vro_icp_size, pose_vro_icp_size, vro_icp_ch_size, pose_vro_icp_ch_size] = get_nframe_nvro_npose(file_index, dynamic_index)

%% nFrame list
etas_nFrame_list = [979 1488 988 1979 1889]; %[3rd_straight, 3rd_swing, 4th_straigth, 4th_swing, 5th_straight, 5th_swing]
loops_nFrame_list = [0 1359 2498 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2669];
kinect_tum_nFrame_list = [0 98 0 0];
m_nFrame_list = [0 5414 0 729];
sparse_feature_nFrame_list = [232 198 432 365 277 413 0 206 235 0 706 190 275 358 290 578]; 
swing_nFrame_list = [271 322 600 534 530 334 379 379 379 379 379 299 365 248 245 249 220 245 249 302 399 389 489 446 383 486]; 
swing2_nFrame_list = [99 128 221 176 210 110];
motive_nFrame_list =[82 145 231 200 227 260 254 236 196 242 182 184 84 0 199 212 81 95 98 99 209 215 96 80 124 112 207 190 115 109 175 214 206 222 177 158 171 158];
object_recognition_nFrame_list =[998 498 498 498 398 398 398 848 848 798 848 35 37 41 14 198 198 198 198 348];
map_nFrame_list =[0 8770 3961 844 1899 1397 302 197 351];
%map_nFrame_list =[0 8770 1320];

%% vro size list
%etas_vro_size_list = [1940 0 1665 0 9490 0]; % NMMP < 13
etas_vro_size_list = [2629 0 1665 0 9490 0]; % NMMP < 6
%etas_vro_size_list_vro_icp_ch = [1938 0 1665 0 9490 0]; % NMMP < 13
etas_vro_size_list_vro_icp_ch = [2475 0 1665 0 9490 0]; % NMMP < 6
%etas_pose_size_list = [919 0 1665 0 9490 0]; % NMMP < 13
etas_pose_size_list = [964 0 1665 0 9490 0]; % NMMP < 6
%etas_pose_size_list_vro_icp_ch = [919 0 1665 0 9490 0]; % NMMP < 13
etas_pose_size_list_vro_icp_ch = [954 0 1665 0 9490 0];% NMMP < 6

loops_vro_size_list = [0 13098 12476 0 0 0 0 0 0 0 0 0 0 0 0 0 0 26613];
kinect_tum_vro_size_list = [0 98 0 0];
sparse_feature_vro_size_list_vro = [814 689 1452 1716 851 2104 0 483 0 0 4438 0 0 0 0 4939]; %232
sparse_feature_vro_size_list_vro_icp = [926 0 1783 365 1153 2328 0 674 0 0 4122 0 0 0 0 0]; %926 232
sparse_feature_vro_size_list_vro_icp_ch = [874 762 1616 1889 1153 2308 0 575 0 0 4738 0 0 0 0 5187];% 896 232 2040
sparse_feature_pose_size_list_vro = [232 195 432 364 258 408 0 184 0 0 701 0 0 0 0 576];
sparse_feature_pose_size_list_vro_icp = [232 0 432 365 274 413 0 201 0 0 708 0 0 0 0 0];
sparse_feature_pose_size_list_vro_icp_ch = [232 197 432 365 274 410 0 195 0 0 703 0 0 0 0 578]; %410

swing_vro_size_list_vro = [1525 1230 432 363 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
swing_vro_size_list_vro_icp = [1943 1815 1783 365  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]; %232
swing_vro_size_list_vro_icp_ch = [1790 1437 1650 365  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]; %1494
swing_pose_size_list = [269 321 432 365  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
swing_pose_size_list_vro_icp = [269 321 432 365  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
swing_pose_size_list_vro_icp_ch = [269 321 432 365  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];

swing2_vro_size_list_vro = [171 0 0 0];
swing2_vro_size_list_vro_icp = [236 0 0 0]; %232
swing2_vro_size_list_vro_icp_ch = [206 0 0 0]; %1494
swing2_pose_size_list = [99 0 0 0];

loops2_nFrame_list = [830 582 830 832 649 930 479 580 699 458 368 239];
%loops2_nFrame_list = [830 0 832 832 649 932 479 580 699 458 398 239]; %2498 578
loops2_vro_size_list = [9508 7344 8915 7341 9157 5278 2777 9485 6435 4465 3035 673]; %4145 5754 with static5
%loops2_vro_size_list = [10792 9468 11700 7341 9157 5278 2777 9485 6435 4465 3035 673]; %4145 5754
loops2_vro_size_list_vro_icp = [830 0 11293 7427 649 932 479 580 699 458 398 1118]; %4145 5754
loops2_vro_size_list_vro_icp_ch = [10511 8762 11416 7427 10814 6473 3273 10685 7102 4612 3188 783]; % % NMMP < 6
%loops2_vro_size_list_vro_icp_ch = [9506 7329 10525 7427 9123 5275 2757 9481 6417 4463 3032 783]; % NMMP < 13
loops2_pose_size_list = [830 582 830 832 649 928 477 580 699 455 365 227];
loops2_pose_size_list_vro_icp = [830 582 830 832 649 932 479 580 699 458 398 238];
%loops2_pose_size_list_vro_icp_ch = [830 582 830 832 649 928 477 580 698 455 364 234]; % NMMP < 13
loops2_pose_size_list_vro_icp_ch = [830 582 830 832 649 929 479 580 698 458 366 234]; % NMMP < 6

motive_vro_size_list_vro = [1525 1230 432 363 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
motive_vro_size_list_vro_icp = [1943 1815 1783 365  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]; %232
motive_vro_size_list_vro_icp_ch = [1790 1437 1650 365  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]; %1494
motive_pose_size_list = [269 321 432 365  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
motive_pose_size_list_vro_icp = [269 321 432 365  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
motive_pose_size_list_vro_icp_ch = [269 321 432 365  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];

object_recognition_vro_size_list_vro = [1525 1230 432 9706 0 0 0 0 0 0 16089 0 0 0 0 0 0 0 0 0];
object_recognition_vro_size_list_vro_icp = [1943 1815 1783 365  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]; %232
object_recognition_vro_size_list_vro_icp_ch = [1790 1437 1650 365  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]; %1494
object_recognition_pose_size_list = [269 321 432 365  0 0 0 0 0 0 848 0 0 0 0 0 0 0 0 0];
object_recognition_pose_size_list_vro_icp = [269 321 432 365  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
object_recognition_pose_size_list_vro_icp_ch = [269 321 432 365  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];


map_vro_size_list_vro = [0 0 0 0 0 0 0 0 0];
map_vro_size_list_vro_icp = [0 0 0 0 0 0 0 0 0]; %232
map_vro_size_list_vro_icp_ch = [0 0 0 0 0 0 0 0 0]; %1494
map_pose_size_list = [0 0 0 0 0 0 0 0 0];
map_pose_size_list_vro_icp = [0 0 0 0 0 0 0 0 0];
map_pose_size_list_vro_icp_ch = [0 0 0 0 0 0 0 0 0];

switch file_index
    case 5       
        nFrame = m_nFrame_list(dynamic_index - 14);
        vro_size = 6992; %5382; %46; %5365; %5169;
    case 6
        nFrame = etas_nFrame_list(dynamic_index); %289; 5414; %46; %5468; %296; %46; %86; %580; %3920;
        vro_size = etas_vro_size_list(dynamic_index); %etas_vro_size_list(dynamic_index); %1951; 1942; %5382; %46; %5365; %5169;
        pose_size = etas_pose_size_list(dynamic_index);
        vro_icp_size = 0;
        pose_vro_icp_size = 0;
        vro_icp_ch_size = etas_vro_size_list_vro_icp_ch(dynamic_index);
        pose_vro_icp_ch_size =etas_pose_size_list_vro_icp_ch(dynamic_index);
    case 7
        nFrame = loops_nFrame_list(dynamic_index);
        vro_size = loops_vro_size_list(dynamic_index); 
    case 8
        nFrame = kinect_tum_nFrame_list(dynamic_index);
        vro_size = kinect_tum_vro_size_list(dynamic_index); 
    case 9
        nFrame = loops2_nFrame_list(dynamic_index);
        vro_size = loops2_vro_size_list(dynamic_index); 
        pose_size = loops2_pose_size_list(dynamic_index);
        vro_icp_size = loops2_vro_size_list_vro_icp(dynamic_index);
        pose_vro_icp_size = loops2_pose_size_list_vro_icp(dynamic_index);
        vro_icp_ch_size = loops2_vro_size_list_vro_icp_ch(dynamic_index);
        pose_vro_icp_ch_size = loops2_pose_size_list_vro_icp_ch(dynamic_index);
    case 11
        nFrame = sparse_feature_nFrame_list(dynamic_index);
        vro_size = sparse_feature_vro_size_list_vro(dynamic_index); 
        pose_size = sparse_feature_pose_size_list_vro(dynamic_index);
        vro_icp_size = sparse_feature_vro_size_list_vro_icp(dynamic_index);
        pose_vro_icp_size = sparse_feature_pose_size_list_vro_icp(dynamic_index);
        vro_icp_ch_size = sparse_feature_vro_size_list_vro_icp_ch(dynamic_index);
        pose_vro_icp_ch_size = sparse_feature_pose_size_list_vro_icp_ch(dynamic_index);
    case 12
        nFrame = swing_nFrame_list(dynamic_index);
        vro_size = swing_vro_size_list_vro(dynamic_index); 
        pose_size = swing_pose_size_list(dynamic_index);
        vro_icp_size = swing_vro_size_list_vro_icp(dynamic_index);
        pose_vro_icp_size = swing_pose_size_list_vro_icp(dynamic_index);
        vro_icp_ch_size = swing_vro_size_list_vro_icp_ch(dynamic_index);
        pose_vro_icp_ch_size = swing_pose_size_list_vro_icp_ch(dynamic_index);
    case 13
        nFrame = swing2_nFrame_list(dynamic_index);
        vro_size = swing2_vro_size_list_vro(dynamic_index); 
        pose_size = swing2_pose_size_list(dynamic_index);
    case 14
        nFrame = motive_nFrame_list(dynamic_index);
        vro_size = motive_vro_size_list_vro(dynamic_index); 
        pose_size = motive_pose_size_list(dynamic_index);
        vro_icp_size = motive_vro_size_list_vro_icp(dynamic_index);
        pose_vro_icp_size = motive_pose_size_list_vro_icp(dynamic_index);
        vro_icp_ch_size = motive_vro_size_list_vro_icp_ch(dynamic_index);
        pose_vro_icp_ch_size = motive_pose_size_list_vro_icp_ch(dynamic_index);
    case 15
        nFrame = object_recognition_nFrame_list(dynamic_index);
        vro_size = object_recognition_vro_size_list_vro(dynamic_index); 
        pose_size = object_recognition_pose_size_list(dynamic_index);
        vro_icp_size = object_recognition_vro_size_list_vro_icp(dynamic_index);
        pose_vro_icp_size = object_recognition_pose_size_list_vro_icp(dynamic_index);
        vro_icp_ch_size = object_recognition_vro_size_list_vro_icp_ch(dynamic_index);
        pose_vro_icp_ch_size = object_recognition_pose_size_list_vro_icp_ch(dynamic_index);
    case 16
        nFrame = map_nFrame_list(dynamic_index);
        vro_size = map_vro_size_list_vro(dynamic_index); 
        pose_size = map_pose_size_list(dynamic_index);
        vro_icp_size = map_vro_size_list_vro_icp(dynamic_index);
        pose_vro_icp_size = map_pose_size_list_vro_icp(dynamic_index);
        vro_icp_ch_size = map_vro_size_list_vro_icp_ch(dynamic_index);
        pose_vro_icp_ch_size = map_pose_size_list_vro_icp_ch(dynamic_index);
end


end

