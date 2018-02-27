
function [q, t] = deconstruct(T)
    [R,t] = decompose(T);
    q = rmat2quat(R);
    q = [q(2) q(3) q(4) q(1)];
end