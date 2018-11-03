
%
% Nov. 3, 2018, He Zhang, hzhang8@vcu.edu 
% 
% plot the trajectories of result in robocane folder 
%

addpath('../');
addpath('.');

tr1 = load('./robocane/dvio/strat/ds_strat3.log'); 
tr2 = load('./robocane/vins-mono/strat/ds_strat3.log'); 
tr3 = load('./robocane/vins-mono-rs/strat/strat3.log'); 
tr4 = load('./robocane/rovio/strat/ds_strat3.log'); 


plot_xyz(tr1(:,2), tr1(:,3), tr1(:,4), 'r-');
hold on;
plot_xyz(tr4(:,2), tr4(:,3), tr4(:,4), 'm-');
hold on;
plot_xyz(tr2(:,2), tr2(:,3), tr2(:,4), 'g-'); 
hold on;
plot_xyz(tr3(:,2), tr3(:,3), tr3(:,4), 'b-'); 
hold on;
plot3(0, 16.5, 0, 'k*');
legend('dvio', 'rovio', 'vins-mono', 'vins-mono-rs'); 



