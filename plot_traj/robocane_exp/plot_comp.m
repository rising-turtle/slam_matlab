
%
% Nov. 3, 2018, He Zhang, hzhang8@vcu.edu 
% 
% plot the trajectories of result in comp_d6 folder 
%

addpath('../');
addpath('.');

tr1 = load('./comp/vins_d6.log'); 
tr2 = load('./comp/vins_rs_d6.log'); 
tr3 = load('./comp/dvio_tra_d6.log'); 
tr4 = load('./comp/dvio_sam_d6.log'); 


plot_xyz(tr1(:,2), tr1(:,3), tr1(:,4), 'r-');
hold on;
plot_xyz(tr2(:,2), tr2(:,3), tr2(:,4), 'c-');
hold on;
plot_xyz(tr3(:,2), tr3(:,3), tr3(:,4), 'g-'); 
hold on;
plot_xyz(tr4(:,2), tr4(:,3), tr4(:,4), 'b-'); 
hold on;
grid on
plot3(0, 20.0, 0, 'k*');
legend('vins-mono w/o tc', 'vins-mono w tc', 'dvio trasfer-error', 'dvio Sampson-error'); 




