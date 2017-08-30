function [fhm, FHM_u, FHM_s, FHM_k, FHM_c] = invPinHoleFhm(u,s,k,c)

% INVPINHOLEFHM Retro-project framed homogeneous point FHM.
%   FHM = INVPINHOLEFHM(U,S) gives the retroprojected framed homogeneous
%   point (FHM) of a pixel U at depth S (S is actually the inverse
%   depth), from a canonical pin-hole camera, that is, with calibration
%   parameters
%     u0 = 0 v0 = 0 au = 1 av = 1
%   It uses reference frames {RDF,RD} (right-down-front for the 3D world
%   points and right-down for the pixel), according to this scheme:
%
%         / z (forward)
%        /
%       +------- x                 +------- u
%       |                          |
%       |      3D : P=[x;y;z]      |     image : U=[u;v]
%       | y                        | v
%
%   FHM = INVPINHOLEFHM(U,S,K) allows the introduction of the camera's
%   calibration parameters:
%     K = [u0 v0 au av]'
%
%   FHM = INVPINHOLEFHM(U,S,K,C) allows the introduction of the camera's radial
%   distortion correction parameters:
%     C = [c2 c4 c6 ...]'
%   so that the new pixel is corrected following the distortion equation:
%     U = U_D * (1 + K2*R^2 + K4*R^4 + ...)
%   with R^2 = sum(U_D.^2), being U_D the distorted pixel in the image
%   plane for a camera with unit focal length.
%
%   If U is a pixels matrix, INVPINHOLEFHM(U,...) returns a FHMS matrix FHM,
%   with these matrices defined as
%     U = [U1 ... Un];   Ui = [ui;vi]
%     FHM = [FHM1 ... FHMn];   FHMi = [Xi;Yi;Zi;ai;bi;ci;di;ui;vi;wi;ri]
%   where:
%       ai, bi, ci and di are the quaternion entries of FHM i;
%       ui, vi and vi are the coordinates of the FHM director ray; and
%       ri is the inverse of the distance (wrongly named "inverse depth")
%
%   [FHM,FHM_u,FHM_s,FHM_k,FHM_c] returns the Jacobians of FHM wrt U, S, K and C. It
%   only works for single pixels U=[u;v], and for distortion correction
%   vectors C of up to 3 parameters C=[c2;c4;c6]. See UNDISTORT for
%   information on longer distortion vectors.
%
%   See also RETRO, UNDISTORT, DEPIXELLISE, PINHOLE.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

if nargout == 1 % only point

    switch nargin
        case 2
            ahm = invPinHoleFhm(u,s);
        case 3
            ahm = invPinHoleFhm(u,s,k);
        case 4
            ahm = invPinHoleFhm(u,s,k,c);
    end
    fhm  = [ahm(1:3);1;0;0;0;ahm(4:end)];

else % Jacobians

    if size(u,2) > 1
        error('Jacobians not available for multiple pixels')
    else

        switch nargin
            case 2
                [ahm, AHM_u, AHM_s, AHM_k, AHM_c] = invPinHoleAhm(u,s);

            case 3
                [ahm, AHM_u, AHM_s, AHM_k, AHM_c] = invPinHoleAhm(u,s,k);

            case 4
                [ahm, AHM_u, AHM_s, AHM_k, AHM_c] = invPinHoleAhm(u,s,k,c);
        end
        fhm  = [ahm(1:3);1;0;0;0;ahm(4:end)];
        FHM_u = [AHM_u(1:3,:);zeros(4,2);AHM_u(4:end,:)]; 
        FHM_s = [AHM_s(1:3,:);zeros(4,1);AHM_s(4:end,:)]; 
        FHM_k = [AHM_k(1:3,:);zeros(4,4);AHM_k(4:end,:)]; 
        FHM_c = [AHM_c(1:3,:);zeros(4,length(c));AHM_c(4:end,:)]; 
        
    end

end

return

%% jacobians
syms u v s u0 v0 au av c2 c4 c6 real
U=[u;v];
k=[u0;v0;au;av];
c=[c2;c4;c6];

% [fhm,FHM_u,FHM_s] = invPinHoleFhm(U,s);
[fhm,FHM_u,FHM_s,FHM_k] = invPinHoleFhm(U,s,k);
% [fhm,FHM_u,FHM_s,FHM_k,FHM_c] = invPinHoleFhm(U,s,k,c);

simplify(FHM_u - jacobian(fhm,U))
simplify(FHM_s - jacobian(fhm,s))
simplify(FHM_k - jacobian(fhm,k))
% simplify(FHM_c - jacobian(fhm,c))




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

