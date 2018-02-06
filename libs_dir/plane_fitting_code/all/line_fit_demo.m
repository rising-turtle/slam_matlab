% Simple example to call line_fit leaset squares funtion
close all
clear all

% set up a line
m = 2;
c = 10;

x = 1:20;

% compute y values for y = mx +c
y = m*x+c;


% call line_fit and return the answers (should be same a m and c above)
[mfit cfit] = line_fit(x,y)
