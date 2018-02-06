function [ p1, p2, p3 ] = plane_normal2exp_3d ( pp, normal )

%% PLANE_NORMAL2EXP_3D converts a normal plane to explicit form in 3D.
%
%  Discussion:
%
%    The normal form of a plane in 3D is
%
%      PP, a point on the plane, and
%      N, the unit normal to the plane.
%
%    The explicit form of a plane in 3D is
%
%      the plane through P1, P2 and P3.
%
%  Licensing:
%
%    This code is distributed under the GNU LGPL license.
%
%  Modified:
%
%    26 February 2005
%
%  Author:
%
%    John Burkardt
%
%  Parameters:
%
%    Input, real PP(3), a point on the plane.
%
%    Input, real NORMAL(3), a normal vector N to the plane.  The
%    vector must not have zero length, but it is not necessary for N
%    to have unit length.
%
%    Output, real P1(3), P2(3), P3(3), three points on the plane.
%
  dim_num = 3;

  [ pq, pr ] = plane_normal_basis_3d ( pp, normal );

  p1(1:dim_num) = pp(1:dim_num);
  p2(1:dim_num) = pp(1:dim_num) + pq(1:dim_num);
  p3(1:dim_num) = pp(1:dim_num) + pr(1:dim_num);

  return
end
