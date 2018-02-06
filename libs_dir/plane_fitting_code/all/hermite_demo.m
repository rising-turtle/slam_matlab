%%%% Demo to illustrate Hermite Interpolation Code
close all;
clear all;

% Define Hermite Polynomial Values

x = [1 3];  % Polynomial Values at x = 1 and 3
dx = [1 3]; % Derivative Values at x = 1 and 3


y = [2 1];  % y values for x = 1 and 3

dy = [1 2] % Derivative values for dx = 1 and 3

% Compute a CUbic Hermite Polynomial
[a b c d] = hermite_cubic_interpolate(x,y,dx,dy);


% Now PLOT THE POLYNOMIAL

x = 1:0.05:3 % Step through the clamped x values at some step

% Compute y Values for given cubic from a,b, c and d
[m n] = size(x)
A = [x.*x.*x; x.*x; x; ones(1,n)]';
y = A*[a b c d]';

% Plot the cubic
plot(x,y);
shg; % Show the current graphic