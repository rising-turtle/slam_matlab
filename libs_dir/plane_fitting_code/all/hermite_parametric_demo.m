%%%% Demo to illustrate Hermite Interpolation Code
close all;
clear all;

% Define Hermite Polynomial Values

tx = [1 2];
x = [1 3];  % Polynomial Values at t = 1 and 2

ty = [1 2];
y = [2 1];  % y values for t = 1 and 2


tdy = [1 2]; % Derivative Values at t = 1 and 2

dydx = [1 2]; % Derivative values for dx = 1 and 3


dydxratio = 1;


% Compute a Cubic Hermite Polynomial
[a1,b1,c1,d1,a2,b2,c2,d2] = hermite_parametric_cubic_interpolate(tx,x,ty,y,tdy,dydx,dydxratio)


% Now PLOT THE POLYNOMIAL

t = 1:0.025:2; % Step through the clamped x values at some step

% Compute y Values for given cubic from a,b, c and d
[m n] = size(t);
A = [t.*t.*t; t.*t; t; ones(1,n)]';
x = A*[a1 b1 c1 d1]';
y = A*[a2 b2 c2 d2]';


% Plot the cubic
plot(x,y);
shg; % Show the current graphic