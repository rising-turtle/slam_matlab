function syn_error_z()
%% after synchronize, compute the depth error 
%

est = load('estimate_07.log'); % load('estimate_06.log'); 
gt = load('gt_orien_07.log'); % load('gt_orien_06.log'); 

st_est =  1539612735.666800; %
st_gt =  9.475; %
syn_gt_est = syn_yaw_with_gt(gt, est, st_gt, st_est); 

%% find scale 
st = 30; 
et = 273;

y = syn_gt_est(st:et, 4); 
x = syn_gt_est(st:et, 7); 
y = y - y(1); 
x = x - x(1); 
x = smooth(x, 5);

e = y - x; 
% ir = find(abs(e(:,2)) < 0.02);
% e = e(ir, :);
% e = let_smooth(e);
E = diag(e*e'); 
de = sqrt(sum(E)/size(E,1));
% de = sqrt(dot(e, e)/size(e,1));
disp(['rmse = ' num2str(de)]);

t = 1:size(x,1); 
t = t/30;
% t = t(ir);


%% plot the result 
plot(t, y, 'g-.');
% plot3(y(:,1), y(:,2), y(:,3), 'g-+');
% plot(y(:,1), y(:,3), 'g-+'); 
hold on;
plot(t, x, 'b-.');
% plot3(x(:,1), x(:,2), x(:,3), 'b-*'); 
% plot(x(:,1), x(:,3), 'b-+');
% plot(t, e(:,2), 'g-.');
hold on; 
plot(t, e, 'r-.');

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
                    syn_gt = [syn_gt; query_t-gt(1,1) gt(j,3:5) est(i,5:7)];
               break; 
           end
           j = j + 1;
        end
    end

end

