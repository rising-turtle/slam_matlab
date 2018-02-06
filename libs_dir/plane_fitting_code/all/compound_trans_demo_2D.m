% compound_trans_demo_2D.m
close all
clear all

%Simple demo of 2D compound transformation in MATLAB
% we will do a shear followed by a rotation followed by a translatiom
% SO WE NEED TO USE HOMOGENEOUS

k = 3; % shear factor

dx = 3; % set translation values
dy = 2;

% create a simple box to draw and manipulate
% row 1 is x coords row 2 is y coords

pts = [1 1 4 4 1;1 4 4 1 1];
[n m] = size(pts);
% Plot box

figure(1)
plot(pts(1,1:end),pts(2,1:end),'b*-');
axis([0 5 0 5])
shg


% create a 2D Shear in X matrix

shear = [1 k;0 1];

% create a 2D rotation matrix

rot = [cos_deg(30) sin_deg(30);-sin_deg(30) cos_deg(30)];

% create a 2D Translation in dx, dy NEED TO MAKE A HOMOGENEOUS COORDS matrix

trans = [1 0 dx;0 1 dy; 0 0 1];

% Do Compound TRANSFORMATION

% Make Homogeneous Shear Matrix

homogeneous_shear = eye(3); % create identity 3x3
% paste in 2D shear matrix in top left
homogeneous_shear(1:2,1:2) = shear;

% Make Homogeneous Rotation Matrix

homogeneous_rot = eye(3); % create identity 3x3
% paste in 2D shear matrix in top left
homogeneous_rot(1:2,1:2) = rot;

% Make PTS HOMOGENEOUS

homogeneous_pts = [pts; ones(1,5)];

% do compound transformation

trans_pts = trans*homogeneous_rot*homogeneous_shear*homogeneous_pts;

% Plot Translated box
% just extract out X and Y points to plot ignore third dimension

hold on
plot(trans_pts(1,1:end),trans_pts(2,1:end),'r*-');

axis([0 20 -10 10]);

% DO a different ORDER

figure(2);

plot(pts(1,1:end),pts(2,1:end),'b*-');
axis([0 5 0 5])
shg
  

trans_pts = homogeneous_shear*homogeneous_rot*trans*homogeneous_pts;

% Plot Translated box
% just extract out X and Y points to plot ignore third dimension

hold on
plot(trans_pts(1,1:end),trans_pts(2,1:end),'r*-');

axis([0 20 -10 10]);