% 1-D graph SLAM
% Data : 4/12/12
% Author : Soonhac Hong (sxhong1@ualr.edu)

function graph_slam_1d()

% Data
%pose_data = [1 1 -3; 1 2 5; 2 3 3];  % first row : initial pose, second row : [1]= current index, [2] = next index, [3] = movement
%result = [-3; 2; 5];
% pose_data =[1 1 0; 1 2 3; 2 3 4; 1 3 6; 3 4 2];
% 
% [-9.66914000000000,10.9800100000000,6.85198000000000;]
% [-12.9620100000000,25.6074800000000,18.3592900000000;]
% [-0.776060000000000,16.2314800000000,6.47385000000000;]
% [-4.67272000000000,36.1912600000000,18.4479100000000;]
% [0.930870000000000,38.1723100000000,17.0636200000000;]
pose_data =[1 1 0; 1 2 -9.66914000000000; 2 3 -12.9620100000000; 3 4 -0.776060000000000; 4 5 -4.67272000000000; 5 6 0.930870000000000];

motion_noise = 1.0;

pose_num = size(unique(pose_data(:,1:2)),1);

Omega = zeros(pose_num,pose_num);
Xi = zeros(pose_num,1);
Odometry = zeros(pose_num,1);

% Fill the elements of Omega and Xi
Omega(1,1) = 1;
Xi(1) = pose_data(1,3);
Odometry = pose_data(1,3);

for i=2:size(pose_data,1);
    unit_data = pose_data(i,:);
    current_index = unit_data(1);
    next_index = unit_data(2);
    movement = unit_data(3);
    
    % Fill diagonal elements of Omega
    Omega(current_index,current_index) = Omega(current_index,current_index) + 1/motion_noise;
    Omega(next_index,next_index) = Omega(next_index,next_index) + 1/motion_noise;
    
    % Fill Off-diagonal elements of Omega
    Omega(current_index,next_index) = Omega(current_index,next_index) + (-1)/motion_noise;
    Omega(next_index,current_index) = Omega(next_index,current_index) + (-1)/motion_noise;
    
    % Fill Xi
    Xi(current_index) = Xi(current_index) + (-1)*movement/motion_noise;
    Xi(next_index) = Xi(next_index) + movement/motion_noise;
    
    % Update Odometry
    if abs(current_index - next_index) == 1
        Odometry(next_index) = Odometry(next_index-1) + movement;
    end
end

Omega
Xi
mu = Omega^-1 * Xi

plot(Odometry,'bd-');
hold on;
plot(mu,'ro-');
hold off;
legend('Odometry','Optimized');

end