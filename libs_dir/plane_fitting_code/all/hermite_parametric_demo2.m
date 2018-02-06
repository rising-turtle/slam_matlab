%%%% Demo2 to illustrate Hermite Interpolation Code
%%%%
%%%%  In this demo we build on Demo 1 and illustrate the effect of changing
%%%%  the ratio at the gradient.

close all;
clear all;

% Define Hermite Polynomial Values

tx = [1 2];
x = [1 3];  % Polynomial Values at t = 1 and 2

ty = [1 2];
y = [2 1];  % y values for t = 1 and 2
 

tdy = [1 2]; % Derivative Values at t = 1 and 2

dydx = [1 2]; % Derivative values for dx = 1 and 3

%%%%  SET UP a Plot of different colours for the different ratios
%%%%  We wil use 7 ratios  so use seven colours
%%%%  ARRAY of strings accesses in plot()

plotstr(1) = 'r';
plotstr(2) = 'g';
plotstr(3) = 'b';
plotstr(4) = 'k';
plotstr(5) = 'c';
plotstr(6) = 'm';
plotstr(7) = 'y';


% create figure with hold on so we can plot consecutive loops

figure(1);
hold on;
% loop for dydxratio and compute parametric polynomial

loopindex = 1;
for dydxratio = 0.25:0.25:1.75
    
    
    
% Compute a Cubic Hermite Polynomial
[a1,b1,c1,d1,a2,b2,c2,d2] = hermite_parametric_cubic_interpolate(tx,x,ty,y,tdy,dydx,dydxratio);


% Now PLOT THE POLYNOMIAL

t = 1:0.025:2; % Step through the clamped x values at some step

% Compute y Values for given cubic from a,b, c and d
[m n] = size(t);
A = [t.*t.*t; t.*t; t; ones(1,n)]';
xplot = A*[a1 b1 c1 d1]';
yplot = A*[a2 b2 c2 d2]';


% Plot the cubic
plot(xplot,yplot,plotstr(loopindex));

loopindex = loopindex + 1;
end
shg; % Show the current graphic