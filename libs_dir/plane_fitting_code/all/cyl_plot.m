% Simple example to plot points on a parametric cylinder

close all
clear all


% set up cylinder parameters
p0 = [2,0,0]
r = 3

% Plot a full cylinder (360 degrees)
n = 360;

% set up figure need hold on to continually plot points of cylinder
figure(1)
hold on;

% loop through parametric u and v of cylinder

for v = 1:10 % v is steps along cylinders axis
for u = 1:360 %  u draws a circle at each v axis step
theta = ( 2.0 * pi * ( u - 1 ) ) / n;
x = p0(1) + r * cos(theta);
y = p0(2) + r * sin(theta);
z = p0(3) + v;

% plot 3D point
plot3(x,y,z);
end
end

shg; % show current graphic
