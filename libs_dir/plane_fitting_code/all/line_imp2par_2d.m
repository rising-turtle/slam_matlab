function [ f, g, x0, y0 ] = line_imp2par_2d ( a, b, c )

%% LINE_IMP2PAR_2D converts an implicit line to parametric form in 2D.
%
%  Discussion:
%
%    The implicit form of line in 2D is:
%
%      A * X + B * Y + C = 0
%
%    The parametric form of a line in 2D is:
%
%      X = X0 + F * T
%      Y = Y0 + G * T
%
%    We normalize by choosing F*F+G*G=1 and 0 <= F.
%
%  
%  Parameters:
%
%    Input, real A, B, C, the implicit line parameters.
%
%    Output, real F, G, X0, Y0, the parametric parameters of
%    the line.
%
 
 
 
 root = a * a + b * b;
if ( root == 0.0 )
    fprintf ( 1, '\n' );
    fprintf ( 1, 'LINE_IMP2PAR_2D - Fatal error!\n' );
    fprintf ( 1, '  A * A + B * B = 0.\n' );
    error ( 'LINE_IMP2PAR_2D - Fatal error!' );
  end

 x0 = - a * c / root;
 y0 = - b * c / root;
  
  
  root = sqrt(root);
  f =   b / root;
  g = - a / root;

  if ( f < 0.0 )
    f = -f;
    g = -g;
  end

  return
end
