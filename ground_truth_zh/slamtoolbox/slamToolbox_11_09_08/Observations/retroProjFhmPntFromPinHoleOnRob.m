function [fhm, FHM_rf, FHM_sf, FHM_sk, FHM_sc, FHM_u, FHM_rho] = ...
    retroProjFhmPntFromPinHoleOnRob(Rf, Sf, Sk, Sc, u, n)

% RETROPROJFHMPNTFROMPINHOLEONROB Retro-project fhm from pinhole on robot.
%
%   FHM = RETROPROJFHMPNTFROMPINHOLEONROB(RF, SF, SK, SC, U, N) gives the
%   retroprojected FHM (Framed Homogeneous Point) in World Frame from an
%   observed pixel U. RF and SF are Robot and Sensor Frames, SK and SD are
%   camera calibration and distortion correction parameters. U is the pixel
%   coordinate and N is the non-observable inverse depth. 
%
%   FHM is a 11-vector:
%     FHM = [X Y Z A B C D U V W IDepth]'
%
%   [FHM, FHM_rf, FHM_sf, FHM_k, FHM_c, FHM_u, FHM_n] = ... returns the
%   Jacobians wrt RF.x, SF.x, SK, SC, U and N.
%
%   See also RETROPROJAHMPNTFROMPINHOLEONROB, INVPINHOLEFHM, FROMFRAMEFHM.

%   Copyright 2011 Joan Sola.


% Frame World -> Robot  :  Rf
% Frame Robot -> Sensor :  Sf

if(isempty(Sc))
    % FHM in Sensor Frame
    [fhms, FHMS_u, FHMS_rho, FHMS_sk] = invPinHoleFhm(u,n,Sk) ;
else
    % FHM in Sensor Frame
    [fhms, FHMS_u, FHMS_rho, FHMS_sk, FHMS_sc] = invPinHoleFhm(u,n,Sk,Sc) ;
end

[fhmr, FHMR_sf, FHMR_fhms] = fromFrameFhm(Sf,fhms);
[fhm , FHM_rf , FHM_fhmr]  = fromFrameFhm(Rf,fhmr);

FHM_fhms = FHM_fhmr*FHMR_fhms;
FHM_sk   = FHM_fhms*FHMS_sk ;
FHM_sf   = FHM_fhmr*FHMR_sf;

if(isempty(Sc))
    FHM_sc = [] ;
else
    FHM_sc = FHM_fhms*FHMS_sc ;
end 

FHM_u = FHM_fhms*FHMS_u ;
FHM_rho = FHM_fhms*FHMS_rho ;

end





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

