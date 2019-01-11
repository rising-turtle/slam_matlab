
%
% Jan. 10, 2019, He Zhang, hzhang8@vcu.edu 
% 
% plot the trajectories of result from localization 

tr = load('loc_path3.log'); 
tr = tr(2:end, end-1:end); 
tr(:,1) = smooth(tr(:,1), 7);
tr(:,2) = smooth(tr(:,2), 7);

plot(tr(:,1), tr(:,2));
hold on; 
plot(tr(1,1), tr(1,2),'ko');
plot(tr(end,1), tr(end,2), 'r*'); 

