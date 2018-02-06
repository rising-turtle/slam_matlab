function evaluate_result
% de_y = get_y_error();
% fe = get_final_error();
[de_y,fe,fe_norm,fe_perecent,ye_percent,path] = get_error()
end
function [de_y,fe,fe_norm,fe_perecent,ye_percent,path] = get_error()
legend('off')
grid off
axis off
h = gcf;

axesObjs = get(h, 'Children');
dataObjs = get(axesObjs(1), 'Children'); 
objTypes = get(dataObjs(1), 'Type');
xdata1 = get(dataObjs(1), 'XData');
ydata1 = get(dataObjs(1), 'YData');
zdata1 = get(dataObjs(1), 'ZData');
path1 = 0;
for i =1:length(xdata1)-1
path1 = path1 + norm([xdata1(i+1);ydata1(i+1);zdata1(i+1)]-[xdata1(i);ydata1(i);zdata1(i)] );
end


xdata2 = get(dataObjs(2), 'XData');
ydata2 = get(dataObjs(2), 'YData');
zdata2 = get(dataObjs(2), 'ZData');
path2 = 0;
for i =1:length(xdata2)-1
path2 = path2 + norm([xdata2(i+1);ydata2(i+1);zdata2(i+1)]-[xdata2(i);ydata2(i);zdata2(i)] );
end

% figure;plot(abs(ydata1),'r');hold on;plot(abs(ydata2),'b')



de_y(1) = mean(abs(ydata1));
de_y(2) = mean(abs(ydata2));
fe(1,:) = [xdata1(end);ydata1(end);zdata1(end)]';
fe(2,:) = [xdata2(end);ydata2(end);zdata2(end)]';
fe_norm(1) = norm([xdata1(end);ydata1(end);zdata1(end)]);
fe_norm(2) = norm([xdata2(end);ydata2(end);zdata2(end)]);
fe_perecent(1) = fe_norm(1)/min(path1,path2)*100;
fe_perecent(2) = fe_norm(2)/min(path1,path2)*100;
ye_percent(1) = de_y(1)/path1*100;
ye_percent(2) = de_y(1)/path2*100;
path(1)=path1;
path(2)=path2;




end

% function fe = get_final_error()
% h = gcf;
% axesObjs = get(h, 'Children');
% dataObjs = get(axesObjs, 'Children'); 
% objTypes = get(dataObjs, 'Type');
% xdata = get(dataObjs, 'XData');
% ydata = get(dataObjs, 'YData');
% zdata = get(dataObjs, 'ZData');
% end
