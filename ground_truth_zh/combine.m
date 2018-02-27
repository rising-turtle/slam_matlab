function [T] = combine(R, t)
    T = [R t; 0 0 0 1];
end