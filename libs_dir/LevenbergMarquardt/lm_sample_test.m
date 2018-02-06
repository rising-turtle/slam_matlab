function [ ] = lm_sample_test( )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%
% Author : Soonhac Hong (sxhong1@ualr.edu)
% Date : 10/15/12

x_true = [20.0 10.0 1.0 50.0];  % true value of variable x
xdata = 1:1:100;
xinit = [5.0 2.0 0.2 10.0];
noise_sigma = 0.2;

y_fun = @(x,xdata)x(1)*exp(-xdata./x(2))+x(3)*xdata.*exp(-xdata./x(4));

ydata = y_fun(x_true,xdata) + noise_sigma * randn(size(xdata));  % noised ydata
y_true = y_fun(x_true,xdata);

options = optimset('Algorithm', 'levenberg-marquardt');
x = lsqcurvefit(y_fun, xinit, xdata, ydata, [], [], options)

y_estimation = y_fun(x, xdata);
plot(xdata,ydata,'b*',xdata,y_true,'r-', xdata, y_estimation,'g-');
legend('E','T');

%error = abs(x - x_true);
y_rms_error = rms_error(ydata, y_estimation)
end

