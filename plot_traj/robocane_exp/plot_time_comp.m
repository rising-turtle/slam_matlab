%% Nov. 5 2018, He Zhang, hzhang8@vcu.edu  
% draw time comparison graph 
% 

%% result on desktop 
% dvio  7.86 # 4.63 +- 2.98
% rovio 11.35 +- 2.17
% okvis 22.54 +- 24.76
% vins-mono 35.35 +- 15.2
% vins-mono_rs 35.76 +- 15.14

%% result on upboard 
% dvio  55.06 +- 10.17 # 19.41 +- 4.23
% rovio 30.26 +- 5.16
% okvis 59.02 #49.02 +- 34.21
% vins-mono 113.55 +- 72.6
% vins-mono_rs 113.18 +- 75.86

r = 100;

rng default % For reproducibility 
% sdvio = abs(random('normal', 4.63, 2.98, r, 1));
%rovio = abs(random('normal', 11.35, 2.17, r, 1)); 
% okvis = abs(random('normal', 22.54, 24.76, r, 1)); 
% vins_mono = abs(random('normal', 35.35, 15.2, r, 1));
%vins_mono_tc = abs(random('normal', 35.76, 15.14, r, 1));

sdvio = abs(random('normal', 55.06, 10.17, r, 1));
rovio = abs(random('normal', 30.26, 5.16, r, 1)); 
okvis = random('normal', 59.02, 24.21, r, 1); 
% vins_mono = random('normal', 113.55, 72.6, r, 1);
vins_mono_tc = random('normal', 113.18, 75.86, r, 1);

% x = [dvio rovio okvis vins_mono vins_mono_tc]; 
x = [sdvio rovio okvis vins_mono_tc]; 
% hh = boxplot(x, 'Colors', 'rmcgb'); 
hh = boxplot(x, 'Colors', 'rmcg'); 
set(hh, {'linew'}, {2});
% boxplot(dvio, 'colors', 'r');
% hold on; 
% boxplot(rovio, 'colors', 'm')
h=findobj(gca,'tag','Outliers'); % Get handles for outlier lines.
set(h,'Marker','none'); % Change symbols for all the groups.

% x = randn(100,25);
% boxplot(x)

