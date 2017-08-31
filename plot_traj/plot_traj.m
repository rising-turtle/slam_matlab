%
% Aug. 30, 2017, He Zhang, hxzhang1@ualr.edu
% 
% plot the trajectories of the realsesne datasets
%

% DC1 dataset
% TI1 = load('./results/DC1/okvis.log');
% TI2 = load('./results/DC1/vins.log'); 

% DC2 dataset
% TI1 = load('./results/DC2/okvis.log');
% TI2 = load('./results/DC2/vins.log'); 

% DC3 dataset
TI1 = load('./results/DC3/okvis.log');
TI2 = load('./results/DC3/vins.log');

% TO1 = transToFirst(TI1);
TO1 = TI1; 
TO2 = TI2; % transToFirst(TI2); 
okvis_s = 110; 
okvis_e = 500; 

plot_xyz(TO1(okvis_s:end-okvis_e,2), TO1(okvis_s:end-okvis_e, 3), ... 
    TO1(okvis_s:end-okvis_e, 4), 'r'); 
hold on; 
plot_xyz(TO2(:,2), TO2(:, 3), TO2(:, 4), 'g');
grid on; 
legend('okvis', 'vins-HKUST');
title('DC1');




