%%%% Demo to illustrate Lagrangian Interpolation Code
close all;
clear all;

% Define Lagrangian Polynomial Values

x = [1 3 5 7];  % Polynomial Values at x = 1, 3, 5, 7



y = [2 1 3 4];  % y values for x = 1 and 3


% Compute a Cubic Lagrangian Polynomial
[a b c d] = lagrangian_cubic_interpolate(x,y)


% Now PLOT THE POLYNOMIAL

x = 1:0.05:7; % Step through the clamped x values at some step

% Compute y Values for given cubic from a,b, c and d
[m n] = size(x)
A = [x.*x.*x; x.*x; x; ones(1,n)]';
y = A*[a b c d]';

% Plot the cubic
plot(x,y);
shg; % Show the current graphic