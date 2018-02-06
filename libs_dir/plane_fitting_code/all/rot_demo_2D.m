% rot_demo_2D.m

%Simple demo of 2D rotation in MATLAB

% create a simple box to draw and manipulate
% row 1 is x coords row 2 is y coords

pts = [1 1 4 4 1;1 4 4 1 1];

% Plot box

figure(1)
plot(pts(1,1:end),pts(2,1:end),'b*-');
axis([0 5 0 5])
shg

% create a 2D rotation matrix

rot = [cos_deg(30) sin_deg(30);-sin_deg(30) cos_deg(30)]

% Do Rotation
rot_pts = rot*pts

% Plot Rotated box

hold on
plot(rot_pts(1,1:end),rot_pts(2,1:end),'r*-');

axis([-8 8 -8 8]);



  