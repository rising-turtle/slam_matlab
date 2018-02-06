function [f,g,h,x0,y0,z0] = planes_3d_2intersect_line ( a1, b1, c1, d1, a2, b2, c2, d2)

%% planes_3d_2intersect_line: Intersection of 2D planes line.
%
%  Discussion: Each Plane is
%
%    The implicit form of a plane in 3D is:
%
%      A * X + B * Y + C * Z + D = 0
%  
%    Line is parametric form
%
%    Deatils Page 114-115 of Programmers Geometry by Bowyer andf Woodwark, Butterworths, 1983
%
%  Returns f,g,h,x0,y0,z0
%

tol = eps;

f = b1*c2 - b2*c1;
g = c2*a2 - c2*a1;
h = a1*b2 - a2*b1;


det = f*f + g*g + h*h;

if (abs(det) < tol)
  error('planes_3d_2intersect_line: Planes are parallel');
end;

else
 dc = d1*c2 - c1*d2;
 db = d1*b2 - b1*d2;
 ad = a1*d1 - a2*d1;
 
 detinv = 1/det;
 
 x0 = (g*dc - h*db)*detinv;
 y0 = -(f*dc +h*ad)*detinv;
 z0 = (f*db +g*ab)*detinv;
 
 return;
end;

