function [ TO ] = transToFirst( TI )
% Transform to the first frame as basic coordinate system 
% Aug. 30 2017, He Zhang, hxzhang1@ualr.edu
%  INPUT: array [timestamp, x, y, z, qw, qx, qy, qz]
%  OUTPUT: array [timestamp, x, y, z, qw, qx, qy, qz]
%  

TO = zeros(size(TI,1), 8); 
T1 = construct(TI(1,2:end));
for i=1:size(TI,1)
    Ti = construct(TI(i, 2:end)); 
    Ti_new = T1\Ti;
    [q, t] = deconstruct(Ti_new); 
    TO(i,:) = [TI(i,1), t', q'];
end

end

function [q, t] = deconstruct(T)
    [R,t] = decompose(T);
    q = rmat2quat(R);
end

function [T] = construct(v)
    t = v(1:3);
    q = v(4:7);
    R = quat2rmat(q');
    T = combine(R, t');
end

function [T] = combine(R, t)
    T = [R t; 0 0 0 1];
end

function [R, t] = decompose(T)
    R = T(1:3, 1:3); 
    t = T(1:3, 4);
end