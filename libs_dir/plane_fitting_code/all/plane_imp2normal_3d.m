function [ pp, normal ] = plane_imp2normal_3d ( a, b, c, d )

%% PLANE_IMP2NORMAL_3D converts an implicit plane to normal form in 3D.
%
%  Discussion:
%
%    The implicit form of a plane in 3D is
%
%      A * X + B * Y + C * Z + D = 0.
%
%    The normal form of a plane in 3D is
%
%      PP, a point on the plane, and
%      N, the unit normal to the plane.
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
%    Input, real A, B, C, D, the implicit plane parameters.
%
%    Output, real PP(3), a point on the plane.
%
%    Output, real NORMAL(3), the unit normal vector to the plane.
%
  norm = sqrt ( a * a + b * b + c * c );

  if ( norm == 0.0 )
    fprintf ( 1, '\n' );
    fprintf ( 1, 'PLANE_IMP2NORMAL_3D - Fatal error!\n' );
    fprintf ( 1, '  The plane (A,B,C) has zero norm.\n' );
    error ( 'PLANE_IMP2NORMAL_3D - Fatal error!' );
  end

  normal(1) = a / norm;
  normal(2) = b / norm;
  normal(3) = c / norm;

  if ( a ~= 0.0 )
    pp(1) = -d / a;
    pp(2) = 0.0;
    pp(3) = 0.0;
  elseif ( b ~= 0.0 )
    pp(1) = 0.0;
    pp(2) = -d / b;
    pp(3) = 0.0;
  elseif ( c ~= 0.0 )
    pp(1) = 0.0;
    pp(2) = 0.0;
    pp(3) = -d / c;
  else
    fprintf ( 1, '\n' );
    fprintf ( 1, 'PLANE_IMP2NORMAL_3D - Fatal error!\n' );
    fprintf ( 1, '  The (A,B,C) vector is null.\n' );
    error ( 'PLANE_IMP2NORMAL_3D - Fatal error!' );
  end

  return
end
