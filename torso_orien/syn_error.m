function syn_error()
%% after synchronize, compute the error of orientation 
%

est = load('estimate_05.log'); % load('estimate_06.log'); 
gt = load('gt_orien_05.log'); % load('gt_orien_06.log'); 

st_est = 1539117466.769190; % 1539117578.692901; 
st_gt = 48.825; %	50.75; 

syn_gt_est = syn_yaw_with_gt(gt, est, st_gt, st_est); 

%% find scale 
x = syn_gt_est(100:600,3);
y = syn_gt_est(100:600,2); 
x = smooth(x, 9);
%% fit the linear model 
% y = a*x+b; 
c = polyfit(x, y, 1); 
% Display evaluated equation y = m*x + b
disp(['Equation is y = ' num2str(c(1)) '*x + ' num2str(c(2))]);

yy = c(1)*x + c(2);
e = y - yy; 
de = sqrt(dot(e, e)/size(e,1));
disp(['rmse = ' num2str(de)]);

index = find(yy < 30);
yy = yy(index);
y = y(index);
x = x(index);


%% plot the result 
plot(y, 'g-.');
hold on;
% plot(x, 'r--');

hold on; 
plot(yy, 'b-.');

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
                    syn_gt = [syn_gt; query_t-gt(1,1) gt(j,2) est(i,2)];
               end
               break; 
           end
           j = j + 1;
        end
    end

end
