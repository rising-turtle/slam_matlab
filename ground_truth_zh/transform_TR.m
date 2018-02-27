%% 
% transform coodinate system 
% pay attention to quaternion sequence

function [pose] = transform_TR(pose, R, t)
    T_w2l = combine(R, t);

for i = 1:size(pose, 1)
    t_l2i = pose(i, 1:3);
    q = pose(i, 4:7);
    R_l2i = quat2rmat(q');
    T_l2i = combine(R_l2i, t_l2i');
    T_w2i = T_w2l * T_l2i;
    [R_w2i, t_w2i] = decompose(T_w2i);
    pose(i, 1:3) = t_w2i';
    q = rmat2quat(R_w2i);
    pose(i, 4:7) = [q(2:4); q(1)]';
end

end