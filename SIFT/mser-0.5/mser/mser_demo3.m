% MSER_DEMO3  Demonstrates MSER on a volumetric image

% AUTORIGHTS
% Copyright (C) 2006 Regents of the University of California
% All rights reserved
% 
% Written by Andrea Vedaldi (UCLA VisionLab).
% 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are met
% 
%     * Redistributions of source code must retain the above copyright
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright
%       notice, this list of conditions and the following disclaimer in the
%       documentation and/or other materials provided with the distribution.
%     * Neither the name of the University of California, Berkeley nor the
%       names of its contributors may be used to endorse or promote products
%       derived from this software without specific prior written permission.
% 
% THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND ANY
% EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
% WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
% DISCLAIMED. IN NO EVENT SHALL THE REGENTS AND CONTRIBUTORS BE LIABLE FOR ANY
% DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
% (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
% LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
% ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
% (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
% SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

% --------------------------------------------------------------------
%                                                          Create data
% --------------------------------------------------------------------

% volumetric coordinate (x,y,z)
x       = linspace(-1,1,50) ;
[x,y,z] = meshgrid(x,x,x) ;

% create funny volumetric image
I   = sin(4*x).*cos(4*y).*sin(z) ;
I   = I-min(I(:)) ;
I   = I/max(I(:)) ;

% quantize the image in 10 levels
lev = 10 ;
I   = lev*I ;
Ir  = round(I) ;

% --------------------------------------------------------------------
%                                                      Compute regions
% --------------------------------------------------------------------
[idx,ell,p] = mser(uint8(Ir),1);

% --------------------------------------------------------------------
%                                                                Plots
% --------------------------------------------------------------------

% The image is quantized; store in LEV its range.
lev = unique(Ir(idx)) ;

figure(100); clf;
K=min(length(lev),4) ;

r=.99 ;

% one level per time
for k=1:K
  tightsubplot(K,k) ;
  [i,j,m] = ind2sub(size(I), idx(Ir(idx)==lev(k)) ) ;
  
  % compute level set of level LEV(k)
  Is = double(Ir<=lev(k)) ;
    
  p1 = patch(isosurface(Is,r), ...
             'FaceColor','blue','EdgeColor','none') ;
  p2 = patch(isocaps(Is,r),...
             'FaceColor','interp','EdgeColor','none') ;  
  isonormals(I,p1)
  hold on ;
  
  view(3); axis vis3d tight
  camlight; lighting phong ;
  
  % find regions that have this level
  sel = find( Ir(idx) == lev(k) ) ;
  
  % plot fitted ellipsoid
  for r=sel'
    E = ell(:,r) ;
    c = E(1:3) ;
    A = zeros(3) ;
    A(1,1) = E(4) ;
    A(1,2) = E(5) ;
    A(2,2) = E(6) ;
    A(1,3) = E(7) ;
    A(2,3) = E(8) ;
    A(3,3) = E(9) ;
    
    A = A + A' - diag(diag(A)) ;

    % correct var. order
    perm = [0 1 0 ; 1 0 0 ; 0 0 1] ;
    A = perm*A*perm ;
    
    [V,D] = eig(A) ;
    A = 2.5*V*sqrt(D) ;
    
    [x,y,z]=sphere ;
    [P,Q]=size(x) ;    
    X=A*[x(:)';y(:)';z(:)'] ;
    x=reshape(X(1,:),P,Q)+c(2) ;
    y=reshape(X(2,:),P,Q)+c(1) ;
    z=reshape(X(3,:),P,Q)+c(3) ;
    surf(x,y,z,'FaceAlpha',.5) ;        
  end
end
