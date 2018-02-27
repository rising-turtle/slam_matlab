function plot_axis(gRp, C, axisLength)

    if ~isempty(axisLength)
        % draw the camera axes
        xAxis = C+gRp(:,1)*axisLength;
        L = [C xAxis]';
        line(L(:,1),L(:,2),L(:,3),'Color','r','LineWidth',4);

        yAxis = C+gRp(:,2)*axisLength;
        L = [C yAxis]';
        line(L(:,1),L(:,2),L(:,3),'Color','g','LineWidth',4);

        zAxis = C+gRp(:,3)*axisLength;
        L = [C zAxis]';
        line(L(:,1),L(:,2),L(:,3),'Color','b','LineWidth',4);
    end
end
