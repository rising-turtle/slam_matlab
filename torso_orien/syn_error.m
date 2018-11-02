function syn_error()
%% after synchronize, compute the error of orientation 
%

est = load('estimate_05.log'); % load('estimate_06.log'); 
gt = load('gt_orien_05.log'); % load('gt_orien_06.log'); 

st_est = 1539117466.769190; % 1539117578.592901;
st_gt = 48.825; %	50.75; 

syn_gt_est = syn_yaw_with_gt(gt, est, st_gt, st_est); 

%% find scale 
x = syn_gt_est(130:310,3);
y = syn_gt_est(130:310,2); 
x = smooth(x, 9);
%% fit the linear model 
% y = a*x+b; 
c = polyfit(x, y, 1); 
% Display evaluated equation y = m*x + b
disp(['Equation is y = ' num2str(c(1)) '*x + ' num2str(c(2))]);

yy = c(1)*x + c(2);
e = y - yy; 
ir = find(abs(e(:)) < 5);
x = x(ir);
e = e(ir); 
y = y(ir); 
yy = yy(ir); 

x = smooth(x, 5); 
y = smooth(y, 5); 
yy = c(1)*x + c(2); 
yy = smooth(yy, 7);
yy = smooth(yy, 7);
e = y - yy; 
fprintf('max_e = %f std_e = %f', max(e), std(e));
de = sqrt(dot(e, e)/size(e,1));
disp(['rmse = ' num2str(de)]);

% index = find(yy < 40);
% yy = yy(index);
% y = y(index);
% x = x(index);

t = 1:size(x,1); 
t = t/30;

%% 

% e = e(ir, :);
% e = let_smooth(e);

%% plot the result 
plot(t, y, 'g-.');
hold on;
% plot(x, 'r--');

hold on; 
plot(t, yy, 'b-.');

e = y - yy; 
plot(t, e, 'r-');

end


function [syn_gt] = syn_yaw_with_gt(gt, est, st_gt, st_est)
    syn_gt = [];
    j = 2; 
    for i=1:size(est,1)
        query_t = est(i,1) - st_est + st_gt; 
        if query_t < 0
            continue; 
        end
        
        while j < size(gt,1)
           if gt(j-1,1) <= query_t && gt(j,1) >= query_t
               if gt(j,2) <= 30 && gt(j,2) >= -30
                    syn_gt = [syn_gt; query_t-gt(1,1) gt(j,2) est(i,3)];
               end
               break; 
           end
           j = j + 1;
        end
    end

end

