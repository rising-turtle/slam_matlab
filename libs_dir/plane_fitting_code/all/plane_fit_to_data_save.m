function [R,T] = plane_fit_to_data_save(idx,varargin)
global myCONFIG step_in_source
% idx = step_in_source(1,idx_);
%%% tets ransac plane fitting
% clear all
% close all
% clc
PLANE_FIT_FILE = [myCONFIG.PATH.SOURCE_FOLDER,...
    'plane_fitting_result\plane_fit',num2str(idx),'.mat'];
if exist(PLANE_FIT_FILE,'file')
    load(PLANE_FIT_FILE,'R','T')
else




[x_sr,y_sr,z_sr,im] = read_xyz_sr4000_test(myCONFIG.PATH.SOURCE_FOLDER,idx);
% [scan_file_name, err]=sprintf('%s/d1_%04d.dat',myCONFIG.PATH.DATA_FOLDER,idx);
% [x_sr,y_sr,z_sr,im] = read_sr4000_data_dr_ye(scan_file_name); %%% read XYZ data in SR4000 coordinate



x = -x_sr; y = -y_sr; z = z_sr; %%% transform it into camera coordinate



BoxLimX=[80 144 ];
BoxLimY=[50 120 ];
x1= x(BoxLimX(1):BoxLimX(2),BoxLimY(1):BoxLimY(2));
y1= y(BoxLimX(1):BoxLimX(2),BoxLimY(1):BoxLimY(2));
z1= z(BoxLimX(1):BoxLimX(2),BoxLimY(1):BoxLimY(2));
im1= im(BoxLimX(1):BoxLimX(2),BoxLimY(1):BoxLimY(2));
if nargin>1
    figure
    % subplot(211)
    scatter3(x(:),y(:),z(:),[],double(im(:)));colormap gray
    hold on
    set(gcf, 'Renderer', 'openGL')
    axis equal
    xlabel('x');ylabel('y');zlabel('z');
end
%% obtaining the coordinate axis of the plane
%%%         y |  / z
%             | /
%             |/       This is the coordinate of the SR4000
%    x <------|
%  the y axis of the plane is the niormal of the plane
%  the z axis is obtained by fittinig a line to 15 points whose
%  projection lies in the middle line of the image plane ()
%  the x axis is the cross product of y and z
XYZ = [x1(:)';y1(:)';z1(:)'];
t= 0.02;
feedback = 1;
[B, P, inliers] = ransacfitplane(XYZ, t, feedback);

p_orig = [x1(floor(size(x1,1)/2)+1,floor(size(x1,2)/2)+1);...
    y1(floor(size(x1,1)/2)+1,floor(size(x1,2)/2)+1);...
    z1(floor(size(x1,1)/2)+1,floor(size(x1,2)/2)+1)];
[m_, a_] = find_angle_bw_2_vecs(B(1:3), -p_orig); %%% finding the angle between the normal
%%% vector and the vector connecting the middle of the plane to origin. if
%%% this angle is bigger than 90 degrees we need to multiply the nromal by
%%% -1
display_angles(m_, a_);


if a_(7)<90 %%%% if B makes smaller angle with -y
    B(1:4) = - B(1:4);
end

z_axis =B(1:3);
B(4) = B(4);


%% plot planar patch
patchXmin = 10*x1(1,1);
patchXmax = 10*x1(end,end);
x_patch=patchXmin:(patchXmax - patchXmin)/100:patchXmax;
[X_patch,Y_patch] = meshgrid(x_patch);
% a=2; b=-3; c=10; d=-1;
Z_patch=(B(4)- B(1) * X_patch - B(2) * Y_patch)/B(3);
if nargin>1
    surf(X_patch,Y_patch,Z_patch)
    shading flat
end

%
% [x, y] = meshgrid(-2:1:2, -1:.25:1);
% z = x + y;
% meshc(x, y, z);


z_axis = z_axis/norm(z_axis);


%% finding the axis with line fitting
% %%% points for line extraction
% x_line = -x1(1:end,size(x1,2))';
% y_line = z1(1:end,size(y1,2))';
% z_line = y1(1:end,size(z1,2))';
% L = fitline3d([x_line;y_line;z_line]);
%
%
% y_axis =L(:,2)-L(:,1);
p_ray = [x1(floor(size(x1,1)/2)+1-20,floor(size(x1,2)/2)+1);...
    y1(floor(size(x1,1)/2)+1-20,floor(size(x1,2)/2)+1);...
    z1(floor(size(x1,1)/2)+1-20,floor(size(x1,2)/2)+1)];

% p_ray = p_ray./norm(p_ray);
[ intersect1, p_intersect1 ] = plane_imp_line_par_int_3d ( B(1), B(2), B(3), B(4), 0, 0, 0, ...
    p_ray(1), p_ray(2), p_ray(3) );

%% finding the axis by finding the intersection of a ray and the plane
% p_orig = [x1(floor(size(x1,1)/2)+1,floor(size(x1,2)/2)+1);...
%       y1(floor(size(x1,1)/2)+1,floor(size(x1,2)/2)+1);...
%       z1(floor(size(x1,1)/2)+1,floor(size(x1,2)/2)+1)];


if nargin>1
    h4 = mArrow3([0;0;0],p_ray,'color',[0.5 0.5 0.5]);
    h4 = mArrow3([0;0;0],p_orig,'color',[0.5 0.5 0.5]);
end




[ intersect2, p_intersect2 ] = plane_imp_line_par_int_3d ( B(1), B(2), B(3), B(4), 0, 0, 0, ...
    p_orig(1), p_orig(2), p_orig(3) );


y_axis =p_intersect1'-p_intersect2';

% z_axis = z_axis;
y_axis = y_axis./norm(y_axis);
x_axis = cross(y_axis,z_axis);
x_axis = -x_axis./norm(x_axis);


if nargin>1
    h1 = mArrow3(p_orig,p_orig+x_axis/2,'color',[1 0 0]); %% red
    h2 = mArrow3(p_orig,p_orig+y_axis/2,'color',[0 1 0]); %% green
    h3 = mArrow3(p_orig,p_orig+z_axis/2,'color',[0 0 1]); %% blue
    xlabel('x');ylabel('y');zlabel('z');
end
x_orig = [1 0 0 ]';
y_orig = [0 1 0 ]';
z_orig = [0 0 1 ]';

x_axis_cam = x_axis;
y_axis_cam = z_axis;
z_axis_cam = y_axis;






R= [x_axis_cam'*x_orig y_axis_cam'*x_orig z_axis_cam'*x_orig;...]
    x_axis_cam'*y_orig y_axis_cam'*y_orig z_axis_cam'*y_orig;...
    x_axis_cam'*z_orig y_axis_cam'*z_orig z_axis_cam'*z_orig]
% % % % % % % % % % % % % % % % disp(['x_axis_cam*y_axis_cam = ',num2str(x_axis_cam'*y_axis_cam)])
% % % % % % % % % % % % % % % % disp(['y_axis_cam*z_axis_cam = ',num2str(y_axis_cam'*z_axis_cam)])
% % % % % % % % % % % % % % % % disp(['z_axis_cam*x_axis_cam = ',num2str(z_axis_cam'*x_axis_cam)])
% % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % disp(['det(R) = ', num2str(det(R))]);
T = [0;0;0];%%p_intersect2';
H = [R',-R'*T;0 0 0 1];
%  H = [R,T;0 0 0 1];

XYZ_ORIGIN = H*[x(:)';y(:)';z(:)';ones(1,length(y(:)))];
if nargin>1
    figure
    % subplot(212)
    scatter3(XYZ_ORIGIN(1,:),XYZ_ORIGIN(2,:),XYZ_ORIGIN(3,:),[],double(im(:)));colormap gray
    xlabel('x');ylabel('y');zlabel('z');
    
    hold on
    set(gcf, 'Renderer', 'openGL')
    axis equal
end
save(PLANE_FIT_FILE,'R','T');
end