%% transform into the coordinate of the synchronized pose
function [pose, pt_f, pt_t] = transform_to_synchronized(pose, gt, index)
    Tw2l = construct(gt(index, 2:8));
    Tl2s = transformB2S();
    Tw2s = Tw2l * Tl2s; 
    time_s = 1.;
    t_p = pose(1,1);
    if t_p > 1e12
        time_s = 1e-9;
    end
    t_p = t_p * time_s;
    t_g = gt(index,1);
%     plot_axis(Tw2l(1:3, 1:3), Tw2s(1:3,4), 1);
%     hold on;
%     plot_axis(Tw2s(1:3, 1:3), Tw2s(1:3,4), 2);
    pt_f = [];
    pt_t = [];
    from = 1;
    for i = 1:size(pose,1)
       Ts2i = construct(pose(i,2:8));
       Tw2i = Tw2s * Ts2i;
       [q, t] = deconstruct(Tw2i);
       pose(i, 2:4) = t(:);
       pose(i, 5:7) = q(2:4);
       pose(i, 8) = q(1);
       
       %% find correspond point sets
       timestamp = pose(i,1)*time_s;
       j = find_correspond( gt(:,1), t_g + timestamp - t_p, from);
       if j > from
            pt_f = [pt_f; pose(i,1:4)];
            pt_t = [pt_t; gt(j, 1:4)];
            from = j;
       else
          % fprintf('find_correspond error? from = %d j = %d\n', from, j);
       end
    end
end


%% construct Tb2s 
function Tb2s = transformB2S()
    t_b2s = [-0.01, -0.015, 0.03]';
    theta = 20*pi/180;
    cs = cos(theta);
    ss = sin(theta); 
    R_b2s = [1  0 0;
             0 cs -ss;
             0 ss cs];
    Tb2s = [R_b2s t_b2s; 
            0 0 0 1];
end


