function [T] = construct(v)
    t = v(1:3);
    q = [v(7),  v(4:6)];
    R = quat2rmat(q');
    T = combine(R, t');
end