function plot_xyz(x, y, z, c)
% 
% plot_trajectory using color C 
%
    plot3(x, y, z, c, 'LineWidth', 2);
    hold on;
    hold off;
    axis equal;
    grid;
    xlabel('X (m)');ylabel('Y (m)');zlabel('Z (m)');
end 
