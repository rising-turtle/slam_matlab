% Show camera pose with coordinates
% 
% Author : Soonhac Hong (sxhong1@ualr.edu)
% Date : 2/11/13

function show_camera_pose(poses, is_new_figure, isVRO, isROS_SBA, isCoordinateOn, symbol_color )
% poses : n x 6D (n : number of poses)
if is_new_figure
    figure; 
end

if strcmp(isROS_SBA, 'ros_sba')
    new_poses=[];
    for i=1:size(poses,1)
        T=[e2R([poses(i,4),poses(i,5),poses(i,6)]) [poses(i,1),poses(i,2),poses(i,3)]'; 0 0 0 1];
        sba_T= inv(T);
        new_poses(i,:)=[sba_T(1:3,4)' R2e(sba_T(1:3,1:3))'];
    end
    poses = new_poses;
end

plot3(poses(:,1), poses(:,2), poses(:,3),symbol_color, 'LineWidth', 2);

if strcmp(isCoordinateOn, 'on')
    hold on;
    
    %draw coordinates at each pose
    scale_unit = 0.05 * max(max(poses(:,1:3))); %[m]
    o_unit = [0 0 0 1]';
    x_unit = [scale_unit 0 0 1]';
    y_unit = [0 scale_unit 0 1]';
    z_unit = [0 0 scale_unit 1]';
    axis_unit = [o_unit, x_unit, o_unit, y_unit, o_unit, z_unit];
    for i=1:size(poses,1)
        if strcmp(isVRO, 'vro')
            T = p2T(poses(i,:));
        else
            rot = e2R(poses(i,4:6));
            T = [rot poses(i,1:3)'; 0 0 0 1];
        end
        hat_axis_unit = T*axis_unit;
        plot3(hat_axis_unit(1,1:2), hat_axis_unit(2,1:2), hat_axis_unit(3,1:2),'r-','LineWidth',2);  %x axis
        plot3(hat_axis_unit(1,3:4), hat_axis_unit(2,3:4), hat_axis_unit(3,3:4),'g-','LineWidth',2);  %y axis
        plot3(hat_axis_unit(1,5:6), hat_axis_unit(2,5:6), hat_axis_unit(3,5:6),'b-','LineWidth',2);  %z axis
    end
    hold off;
end

axis equal;
grid;
xlabel('X');
ylabel('Y');
zlabel('Z');
end

function T = p2T(x)

Rx = @(a)[1     0       0;
          0     cos(a)  -sin(a);
          0     sin(a)  cos(a)];
      
Ry = @(b)[cos(b)    0   sin(b);
          0         1   0;
          -sin(b)   0   cos(b)];
      
Rz = @(c)[cos(c)    -sin(c) 0;
          sin(c)    cos(c)  0;
          0         0       1];

Rot = @(x)Rz(x(3))*Rx(x(1))*Ry(x(2));  % SR4000 project; see euler_to_rot.m
T = [Rot(x(4:6)) [x(1), x(2), x(3)]'; 0 0 0 1];

end