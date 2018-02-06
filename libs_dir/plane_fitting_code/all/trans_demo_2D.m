% trans_demo_2D.m
close all
clear all

%Simple demo of 2D Translation in dx,dy in MATLAB

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

% create a 2D Translation in dx, dy NEED TO MAKE A HOMOGENEOUS COORDS matrix

trans = [1 0 dx;0 1 dy; 0 0 1];

% Do Translation

% Make PTS HOMOGENEOUS

homogeneous_pts = [pts; ones(1,5)];

%Translate

trans_pts = trans*homogeneous_pts;

% Plot Translated box
% just extract out X and Y points to plot ignore third dimension

hold on
plot(trans_pts(1,1:end),trans_pts(2,1:end),'r*-');

axis([0 10 0 10]);

  