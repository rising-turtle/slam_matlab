function angle = planes_imp_angle_line_3d ( a1, b1, c1, d1, f, g, h )

%% PLANES_IMP_ANGLE_3D: dihedral angle between implicit planes in 3D.
%
%  Discussion:
%
%    The implicit form of a plane in 3D is:
%
%      A * X + B * Y + C * Z + D = 0
%
%    Partemetric Line Vector (f,g,h)
%
%  
%
  dim_num = 3;

  norm1 = sqrt ( a1 * a1 + b1 * b1 + c1 * c1 );
 if ( norm1 == 0.0 )
    angle = Inf;
    return
 end


norm2 = sqrt ( f * f + g *g + h * h );
if ( norm2 == 0.0 )
    angle = Inf;
    return
  end

cosine = ( a1 * f + b1 * g + c1 * h) / ( norm1 * norm2 );


  angle = pi/2 - arc_cosine ( cosine );

  return
end

