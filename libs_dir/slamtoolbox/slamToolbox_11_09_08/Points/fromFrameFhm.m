function [fhm,FHM_f,FHM_fhmf] = fromFrameFhm(F,fhmf)

% FROMFRAMEFHM  Transforms FHM from local frame to global frame.
%   FHM = FROMFRAMEFHM(F,FHMF) transforms the Inverse Depth point IF from the
%   local frame F to the global frame. The frame F can be specified either
%   with a 7-vector F=[T;Q], where T is the translation vector and Q the
%   orientation quaternion, of via a structure containing at least the
%   fields F.t, F.q, F.R and F.Rt (translation, quaternion, rotation matrix
%   and its transpose).
%
%   [FHM,FHM_f,FHM_if] = FROMFRAMEFHM(...) returns the Jacobians wrt F and FHMF.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.
%   Copyright 2011 Joan Sola


Cf.x  = fhmf(1:7,:);
Cf = updateFrame(Cf);
mf  = fhmf(8:10,:);
sf  = fhmf(11,:);

[t,q,R,Rt] = splitFrame(F);

if nargout == 1

    C = composeFrames(F,Cf);
    fhm  = [C.x;mf;sf];

else

    if size(fhmf,2) > 1
        error('Jacobians not available for multiple fhms')
    else

        [C, C_f, C_cf] = composeFrames(F, Cf);

        fhm    = [C.x;mf;sf];

        FHM_f = [...
            C_f
            zeros(3,7)
            zeros(1,7)];

        FHM_fhmf = [...
            C_cf                  zeros(7, 4)
            zeros(3,7) eye(3)     zeros(3,1)
            zeros(1,7) zeros(1,3) 1          ];

    end
end

return

%% jac

syms x y z a b c d X Y Z U V W R real
F   = [x;y;z;a;b;c;d];
fhmf = [X;Y;Z;U;V;W;R];

[fhm,FHM_f,FHM_fhmf] = fromFrameFhm(F,fhmf);

simplify(FHM_f  - jacobian(fhm,F))
simplify(FHM_fhmf - jacobian(fhm,fhmf))






% ========== End of function - Start GPL license ==========


%   # START GPL LICENSE

%---------------------------------------------------------------------
%
%   This file is part of SLAMTB, a SLAM toolbox for Matlab.
%
%   SLAMTB is free software: you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation, either version 3 of the License, or
%   (at your option) any later version.
%
%   SLAMTB is distributed in the hope that it will be useful,
%   but WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%   GNU General Public License for more details.
%
%   You should have received a copy of the GNU General Public License
%   along with SLAMTB.  If not, see <http://www.gnu.org/licenses/>.
%
%---------------------------------------------------------------------

%   SLAMTB is Copyright 2007, 2008, 2009, 2010 
%   by Joan Sola @ LAAS-CNRS.
%   SLAMTB is Copyright 2009 
%   by Joan Sola, David Marquez and Jean Marie Codol @ LAAS-CNRS.
%   See on top of this file for its particular copyright.

%   # END GPL LICENSE

