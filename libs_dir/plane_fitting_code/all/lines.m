% Simple Matlab Demo to illustrate three forms of 2D lines in MATLAB


close all;
clear all;

% Explicit form of Equation y = mx + c

n=20; % 20 points
x = 0:n; % make n x coordinate values

m = 1; c = 2; % set explicit parameters

y = m*x + c;   % compute y coordinates

figure(1) % Plot Figure
plot(x,y,'*')
axis([0 20 0 25]) % set axes to see plot
title('Explicit Line Equation y = mx +c');


% Implicit form ax + by +c = 0

a = cos(45*pi/180); b = cos(45*pi/180); c = -4; % set implicit parameters
y = -(a*x +c)/b; % compute y coordinates


figure(2);
plot(x,y,'*');

title('Implicit Line Equation ax + by +c = 0');


% Parametric form p = v0 + tw


v0 = [2,2];
w = [1,0];
t = 0:n;  % create a vector of t values

x = v0(1) + t*w(1);
y = v0(2) + t*w(2);


figure(3);
plot(x,y,'*');
axis([0 25 0 3]) % set axes to see plot
title('Parametric Line Equation p = v0 + tw');


% To simply draw a line us plot or line function in MATLAB

figure(4)
plot([x(1) x(end)],[y(1) y(end)],'*-'); % just plot end points

axis([0 25 0 3]) % set axes to see plot
title('MATLAB Plot a line between two points');

figure(5)
line([x(1) x(end)],[y(1) y(end)]); % just draw between end points
axis([0 25 0 3]) % set axes to see plot
title('MATLAB Draw a line between two points');



