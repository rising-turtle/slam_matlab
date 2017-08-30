function [p,P_fhm] = fhm2euc(fhm)

% FHM2EUC  Framed homogeneous to cartesian point conversion.
%   FHM2EUC(FHM) returns the cartesian 3D representation of the point coded
%   in Framed Homogeneous (FHM).
%
%   FHM is a 11-vector : FHM = [x0 y0 z0 a0 b0 c0 d0 u v w rho]' where
%       x0, z0, y0, a0, b0, c0, d0: anchor frame: the frame where the homogeneous point is referred to.
%       u, v, w: director vector of the ray through P that starts at P0.
%       rho: inverse of the distance from point P to P0.
%
%   [P,P_fhm] = FHM2EUC(...) returns the Jacobian of the conversion wrt FHM.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.
%   Copyright 2011 Joan Sola.

C.x  = fhm(1:7,:);   % origin
hc  = fhm(8:11,:);   % homogeneous point
C = updateFrame(C);

if size(fhm,2) == 1 % one only point
    
    if nargout == 1
        
        h = fromFrameHmg(C,hc);
        p = hmg2euc(h);
        
    else % jacobians
        
        [h, H_c, H_hc] = fromFrameHmg(C,hc);
        [p, P_h] = hmg2euc(h);

        P_c = P_h*H_c;
        P_hc = P_h*H_hc;
        
        P_fhm = [P_c P_hc];
        
    end
    
else  % A matrix of Fhms
    
    %     p = x0 + v./repmat(r,3,1);
    %
    %     if nargout > 1
    error('??? Multiple landmarks not supported.')
    %     end
    
end



return

%% test jacobians

syms x y z u v w rho real
fhm = [x;y;z;u;v;w;rho];
[p,P_fhm] = fhm2euc(fhm);

P_fhm - jacobian(p,fhm) % it must return a matrix of zeros



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

