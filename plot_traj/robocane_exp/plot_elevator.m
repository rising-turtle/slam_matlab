
%
% Nov. 2, 2018, He Zhang, hzhang8@vcu.edu 
% 
% plot the trajectories of result in robocane folder 
%

addpath('../');
addpath('.');

tr1 = load('./robocane/dvio/elevator/candidate2.log'); 
tr2 = load('./robocane/vins-mono/elevator/ds_candidate2.log'); 
tr3 = load('./robocane/vins-mono-rs/elevator/candidate2.log'); 


plot(tr1(:,2), tr1(:,3), 'r-'); 
hold on; 
plot(tr2(:,2), tr2(:,3), 'g-'); 
plot(tr3(:,2), tr3(:,3), 'b-'); 
legend('dvio', 'vins-mono', 'vins-mono-rs'); 



