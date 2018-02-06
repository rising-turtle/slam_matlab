gca
y11 = get(get(gca,'Children'),'YData');
x11 = get(get(gca,'Children'),'XData');
z11 = get(get(gca,'Children'),'ZData');
% [R,T] = plane_fit_to_data(1);
compensated_state = [x11;y11;z11];



figure

plot3(compensated_state(1,:),compensated_state(3,:),-compensated_state(2,:))
axis equal
grid on