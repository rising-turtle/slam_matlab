function Ld = fhmLinearTest(Rob,Sen,Lmk)

% FHMLINEARTEST  Linearity test of cartesian point given framed homogeneous point
%   LD = FHMLINEARTEST(ROB,SEN,LMK) return a value with the result of the
%   linearity test.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.
%   Copyright 2011 Joan Sola.

global Map

r = Lmk.state.r;

% explode fhm:
fhm = Map.x(r);
q   = fhm(4:7);
m   = fhm(8:10);
rho = fhm(11);

% and fhm variance:
FHM = Map.P(r,r);
RHO = FHM(11,11);

xi  = fhm2euc(fhm);
mw  = Rp(q,m);
rwc = fromFrame(Rob.frame,Sen.frame.t); % current camera center

hw        = xi-rwc;  % fhm point to camera center
sigma_rho = sqrt(RHO);
sigma_d   = sigma_rho/rho^2; % depth sigma
d1        = norm(hw);
d2        = norm(mw);
cos_a     = mw'*hw/d1/d2;

Ld = 4*sigma_d/d1*abs(cos_a);




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

%   SLAMTB is Copyright 2007,2008,2009 
%   by Joan Sola, David Marquez and Jean Marie Codol @ LAAS-CNRS.
%   See on top of this file for its particular copyright.

%   # END GPL LICENSE

