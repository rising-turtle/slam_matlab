function p = planes_3d_3_intersect ( a1, b1, c1, d1, a2, b2, c2, d2, a3, b3, c3, d3 )

%% planes_3d_3_intersct: Intersectio of 3D planes.
%
%  Discussion: Each Plane is
%
%    The implicit form of a plane in 3D is:
%
%      A * X + B * Y + C * Z + D = 0
%
%    Deatils Page 112-113 of Programmers Geometry by Bowyer andf Woodwark, Butterworths, 1983
%
%  Returns p  x = p(1), y = p(2), z = p(3)
%

tol = eps;

bc = b2*c3 - b3*c2;
ac = a2*c3 - a3*c2;
ab = a2*b3 - a3*b2;


det - a1*bc - b1*ac + c1*ab

if (abs(det) < tol)
  error('planes_3d_3_intersct: At least to planes are parallel');
end;

else
 dc = d2*c3 - d3*c2;
 db = d2*b3 - d3*b2;
 ad = a2*d3 - a3*d2;
 
 detinv = 1/det;
 
 p(1) = (b1*dc - d1*bc - c1*db)*detinv;
 p(2) = (d1*ac - a1*dc - c1*ad)*detinv;
 p(3) = (b1*ad + a1*db - d1*ab)*detinv;
 
 return;
end;

