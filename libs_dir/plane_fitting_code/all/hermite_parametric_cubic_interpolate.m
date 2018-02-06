function [a1 b1 c1 d1 a2 b2 c2 d2] = hermite_parametric_cubic_interpolate(tx,x,ty,y,tdy,dydx,dydxratio)

% hermite_cubic_interpolate: Function to compute a Parametric Cubic Hermit Polynomial
%
% Assume a cubic polynomial of the form
%
%  x(t) = a1*t*t*t + b1*t*t + c1*t + d1
%  y(t) = a2*t*t*t + b2*t*t + c2*t + d2
%
%  with derivative:
%
%  dx/dt = 3a1*t*t + 2*b1*t + c1
%  dy/dt = 3a2*t*t + 2*b2*t + c2
%
% Solution is quite simple: Form a linear system of equations for input
% values of x(t), y(t) and a dx/dt, dydt sampled at points tx (for x, ty
% and tdy (for dx/dt and dy/dt). In put dyydx is dy/dx = (dy/dt)/(dx/dt)
% 
% Form a MATRIX A for all value for x and dx. Form a (column) vector b for
% corresaponding values of y and dy
%
% Use MATLAB \ operator to solve the system
%
% Inputs: tx --- values of t at given x samples
%         x --- values of x where tx samples are given
%         ty --- values of t at given y samples
%         y --- values of y at given ty values
%         tdy --- values of t where dydx samples are given
%         dydx --- values of dydx at given tdy values
%         dydxratio --- ratio values for dy/dx = (ratio)(dy/dt)/(dx/dt)
%
% All inputs assumed row vectors.
% 
% Outputs: a1,b1,c1,d1, a2,b2,c2,d2 --- parameters of Hermite Cubic



[a1 b1 c1 d1] = hermite_cubic_interpolate(tx,x,tdy,dydxratio*dydx);


[a2 b2 c2 d2] = hermite_cubic_interpolate(ty,y,tdy,dydxratio*dydx);

