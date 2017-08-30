% 1D Example of Pose Graph Optimization
% Data : 4/12/12
% Author : Soonhac Hong (sxhong1@ualr.edu)
function pose_optimization_example_1d()

% 1D case
pose_data=[1 1 0; 1 2 9 ; 2 3 5; 3 4 8; 1 3 11; 1 4 19; 2 4 12]; % [first pose, second pose, constraint]
xinit = [0 9 14 22]';
motion_noise = 0.3;

pose_num = size(unique(pose_data(:,1:2)),1);  % first position is not optimized.

Omega = zeros(pose_num,pose_num);
Xi = zeros(pose_num,1);
Odometry=zeros(pose_num,1);
%Odometry = zeros(pose_num,1);

% Fill the elements of Omega and Xi
% Initial point
Omega(1,1) = 1;
Xi(1) = pose_data(1,3);
Odometry(1) = pose_data(1,3);  

for i=2:size(pose_data,1)
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

%Omega
%Xi
%mu = Omega^-1 * Xi

% Using LM
%myfun = @(x,xdata)Rot(x(1:3))*xdata+repmat(x(4:6),1,length(xdata));
myfun = @(x,xdata)xdata*x(1:size(xdata,1));
xdata = Omega;
ydata = Xi;
options = optimset('Algorithm', 'levenberg-marquardt');
%x = lsqcurvefit(myfun, zeros(6,1), p, q, [], [], options);
x = lsqcurvefit(myfun, xinit, xdata, ydata, [], [], options);


plot(Odometry,'bd-');
hold on;
plot(x,'ro-');
hold off;
legend('Odometry','Optimized');

end