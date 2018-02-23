function yesno = switch_active_local_area(boundary)
%function yesno = switch_active_local_area()
%
% should change the active local area or not
%
% GLOBAL INPUTS:
%   XA -
%   g_current_ala_center -
%   g_current_ala_center_cov -
%
% OUTPUTS:
% yesno - 
%

global XA g_current_ala_center

delta = abs(XA(1:2,:) - g_current_ala_center);
d = sqrt( delta'*delta );

if d > boundary
    yesno = 1;
else 
    yesno = 0;
end