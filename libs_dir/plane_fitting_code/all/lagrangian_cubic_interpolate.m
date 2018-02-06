function [a b c d] = lagrangian_cubic_interpolate(x,y)

% lagrangian_cubic_interpolate: Function to compute a Cubic  Polynomial by Lagrangian Interpolation
%
% Assume a cubic polynomial of the form
%
%  y = a*x*x*x + b*x*x + c*x + d
%
%  
%
% Solution is quite simple: Form a linear system of equations for input
% values of y  sampled at points x (for y) 
% 
% Form a MATRIX A for all value for x and dx. Form a (column) vector b for
% corresaponding values of y and dy
%
% Use MATLAB \ operator to solve the system
%
% Inputs: x --- values of x where y samples are given
%         y --- values of y at given x values
%         
%
% All inputs assumed row vectors.
% 
% Outputs: a,b,c,d --- parameters of Hermite Cubic

poly_order = 3

% Get number of x data points
[m n] = size(x);

if (n < poly_order)
    error('Not Enough data for Interpolation');
end

% Form matrix A for X values

A = [x.*x.*x; x.*x; x; ones(1,n)]';




% Create b from y' --- Need a COLUMN vector 

b = y';

% solve linear system of equations

p = A\b;

% output a,b,c,d

a = p(1); 
b = p(2);
c = p(3);
d = p(4);
