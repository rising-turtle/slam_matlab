function plot_gt_etas()
%     inch2mm = 304.8;        % 1 cube = 12 inch = 304.8 mm
%     gt_x = [0 0 13*inch2mm 13*inch2mm 0];
%     gt_y = [-1*inch2mm 6*inch2mm 6*inch2mm -1*inch2mm -1*inch2mm];
%     %gt_x = [0 0 2135 2135 0];
%     %gt_y = [0 1220 1220 0 0];
%     gt_z = [0 0 0 0 0];
%     gt_x = gt_x / 1000; % [mm] -> [m]
%     gt_y = gt_y / 1000; % [mm] -> [m]
%     gt_z = gt_z / 1000; % [mm] -> [m]
    
    inch2m = 0.0254;        % 1 inch = 0.0254 m
    gt_x = [0 0 150 910 965 965 910 50 0 0];
    gt_y = [0 24 172.5 172.5 122.5 -122.5 -162.5 -162.5 -24 0];
    
    gt_x = [gt_x 0 0 60 60+138 60+138+40 60+138+40 60+138 60 0 0];
    gt_y = [gt_y 0 24 38.5+40 38.5+40 38.5 -38.5 -38.5-40 -38.5-40 -24 0];
    
    gt_x = gt_x * inch2m;
    gt_y = gt_y * inch2m;
    gt_z = zeros(length(gt_x),1);    
    plot3(gt_x,gt_y,gt_z,'g-','LineWidth',2);
    
    
end