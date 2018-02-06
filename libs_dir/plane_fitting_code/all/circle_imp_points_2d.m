function p = circle_imp_points_2d ( r, center, n )

%% CIRCLE_IMP_POINTS_2D returns N equally spaced points on an implicit circle in 2D.
%
%  Discussion:
%
%    The first point is always ( CENTER(1) + R, CENTER(2) ), and subsequent
%    points proceed counterclockwise around the circle.
%
%    An implicit circle in 2D satisfies the equation:
%
%      ( X - CENTER(1) )**2 + ( Y - CENTER(2) )**2 = R**2
%
%  Licensing:
%
%    This code is distributed under the GNU LGPL license.
%
%  Modified:
%
%    31 January 2005
%
%  Author:
%
%    John Burkardt
%
%  Parameters:
%
%    Input, real R, the radius of the circle.
%
%    Input, real CENTER(2), the center of the circle.
%
%    Input, integer N, the number of points desired.  N must be at least 1.
%
%    Output, real P(2,N), the coordinates of points 
%    on the circle.
%
  dim_num = 2;

  for i = 1 : n
    theta = ( 2.0 * pi * ( i - 1 ) ) / n;
    p(1,i) = center(1) + r * cos ( theta );
    p(2,i) = center(2) + r * sin ( theta );
  end

  return
end
