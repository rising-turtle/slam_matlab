function dist = points_dist ( p1, p2 )

%% POINTS_DIST finds the distance between two points in N dimensions.
%
%
%    Input, real P1(DIM_NUM), P2(DIM_NUM), the coordinates of two points.
%
%    Output, real DIST, the distance between the points.
%
  
  
  dist = sqrt ( sum ( ( p1 - p2).^2 ) );
  
  % alternative could use built in MATLAB function norm
  % dist = norm(p1 - p2);

  return
end
