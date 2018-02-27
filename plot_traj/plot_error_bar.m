%%
% Dec. 27, 2018, He Zhang, hxzhang1@ualr.edu
% plot the error bar of the translation err 

function plot_error_bar()

load('vins-mono_err.mat'); 
load('gt.mat');
load('vins-mono_ext_err.mat');
load('okvis_err.mat');
tps = find_dis_tps(T_gt, 2);
x = tps(:,2); 
vins_mono_err_x = []; 
vins_mono_std_x = [];
vins_mono_ext_err_x = [];
vins_mono_ext_std_x = [];
okvis_err_x = [];
okvis_std_x = [];

for i=1:size(tps)
    tp = tps(i,1); 
    vins_mono_err_i = [];
    vins_mono_ext_err_i= [];
    okvis_err_i = [];
    for j=1:10
        E_vins = vins_err{j};
        er = find_err(tp, E_vins);
        if er >= 0 
            vins_mono_err_i = [vins_mono_err_i; er];
        end
        E_vins_ext = vins_ext_err{j}; 
        er = find_err(tp, E_vins_ext);
        if er >= 0
            vins_mono_ext_err_i = [vins_mono_ext_err_i; er];
        end
        E_okvis = okvis_err{j}; 
        er = find_err(tp, E_okvis);
        if er >= 0
            okvis_err_i = [okvis_err_i; er];
        end
    end
    mu = mean(vins_mono_err_i);
    sigma = std(vins_mono_err_i); 
    vins_mono_err_x = [vins_mono_err_x; mu];
    vins_mono_std_x = [vins_mono_std_x; sigma];
    
    mu = mean(vins_mono_ext_err_i);
    sigma = std(vins_mono_ext_err_i); 
    vins_mono_ext_err_x = [vins_mono_ext_err_x; mu];
    vins_mono_ext_std_x = [vins_mono_ext_std_x; sigma];
    
    mu = mean(okvis_err_i); 
    sigma = std(okvis_err_i); 
    okvis_err_x = [okvis_err_x; mu];
    okvis_std_x = [okvis_std_x; sigma];
end

% draw bar
errorbar(x, okvis_err_x, okvis_std_x, 'd', 'MarkerFaceColor', 'blue'); 
hold on; 
errorbar(x + 0.1, vins_mono_err_x, vins_mono_std_x, 's', 'MarkerFaceColor', 'red');
hold on;
errorbar(x + 0.2, vins_mono_ext_err_x, vins_mono_ext_std_x, '*', 'MarkerFaceColor', 'green');
hold on;
grid on;

grid on;
xlabel('Distance traveled [m]');
ylabel('Translation Error [m]');
legend('OKVIS', 'VINS-Mono', 'Proposed');
xlim([0, 28])

end

%% find err value at given timestamp 
function err = find_err(tp, Er)
    err = -1;
    for i=1:size(Er,1)
        if Er(i,1) >= tp
            if Er(i,1) - tp <= 0.2
               err = Er(i,2);
               break;
            else
                if i>1 && tp - Er(i-1,2) <= 0.2
                    err = Er(i-1,2);
                    break;
                end
            end
        end
    end

end

%% find timestamps at given distance 
function [tps] = find_dis_tps(gt, dis)

    tps = [];
    last = 1;
    j = 1;
    m = size(gt,1);
    last_dis = 0;
    while j < m
        t1 = gt(last, 2:4); 
        for j=last:m
           t2 = gt(j,2:4); 
           dt = t2 - t1; 
           cur_dis = sqrt(dt*dt'); 
           if cur_dis >= dis
               tps = [tps; gt(j,1), dis+last_dis];
               last = j;
               last_dis = dis + last_dis;
               break;
           end
        end
        
    end
    
end