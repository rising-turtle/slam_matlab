function [m, a] = find_angle_bw_2_vecs(v1, v2)
% Magnitude of vector is its norm
m(1) = norm(v1);
m(2) = norm(v2); 

% Min. angles from vector 1 to axes
a(1 : 3) = acosd(v1 / m(1));
% Min. angles from vector 2 to axes
a(4 : 6) = acosd(v2 / m(2)); 

% Dot product dot(v1, v2) equals sum(v1 .* v2)
a(7) = acosd(dot(v1, v2) / m(1) / m(2)); 