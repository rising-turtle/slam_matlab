function [m c] = line_fit(x,y)

% line_fit --- simple least squares fit of points to aline function
%
% Inputs: x and y data values (Assumed row vectors)
%
% Outputs  m and c parameters of the line equation y = mx + c

% Get number of x values
[n1 n] = size(x);

% Compute sums needed for least squares
sumx = sum(x);
sumy = sum(y);

sumx2 = sum(x.*x);

sumxy = sum(x.*y);

det = n* sumx2 - sumx*sumx;

% Work out and return m and c
m = (n*sumxy - sumx*sumy)/det;

c = (sumy*sumx2 - sumx*sumxy)/det;
