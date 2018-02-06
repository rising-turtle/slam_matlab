% shear_demo_2D.m
close all
clear all

%Simple demo of 2D Shear in X in MATLAB

k = 3; % shear factor

% create a simple box to draw and manipulate
% row 1 is x coords row 2 is y coords

pts = [1 1 4 4 1;1 4 4 1 1];

% Plot box

figure(1)
plot(pts(1,1:end),pts(2,1:end),'b*-');
axis([0 5 0 5])
shg

% create a 2D Shear in X matrix

shear = [1 k;0 1]

% Do Shear
shear_pts = shear*pts;

% Plot Sheared box

hold on
plot(shear_pts(1,1:end),shear_pts(2,1:end),'r*-');

axis([0 20 0 5]);

  