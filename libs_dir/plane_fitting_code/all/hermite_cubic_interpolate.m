function [a b c d] = hermite_cubic_interpolate(x,y,dx,dy)

% hermite_cubic_interpolate: Function to compute a Cubic Hermit Polynomial
%
% Assume a cubic polynomial of the form
%
%  y = a*x*x*x + b*x*x + c*x + d
%
%  with derivative:
%
%  dy = 3A*x*X + 2*b*x + c
%
% Solution is quite simple: Form a linear system of equations for input
% values of y and a dy sampled at points x (for y) and dx (for dy)
% 
% Form a MATRIX A for all value for x and dx. Form a (column) vector b for
% corresaponding values of y and dy
%
% Use MATLAB \ operator to solve the system
%
% Inputs: x --- values of x where y samples are given
%         y --- values of y at given x values
%         dx --- values of dx where dy samples are given
%         dy --- values of dy at given dx values
%
% All inputs assumed row vectors.
% 
% Outputs: a,b,c,d --- parameters of Hermite Cubic


% Get number of x data points
[m n] = size(x);

% Form matrix A for X values

A = [x.*x.*x; x.*x; x; ones(1,n)]';


% Get number of x data points
[m n] = size(dx);

% Form matrix dA for X values

dA = [3*dx.*dx; 2*dx; ones(1,n); zeros(1,n)]';

% Concatentate A and da  for final A matrix
A = [A ; dA];

% Concatentate y and dy  for b COLUMN vector --- 
%   so columnise y and dy (use ')
b = [y' ; dy'];

% solve linear system of equations

p = A\b;

% output a,b,c,d

a = p(1); 
b = p(2);
c = p(3);
d = p(4);
