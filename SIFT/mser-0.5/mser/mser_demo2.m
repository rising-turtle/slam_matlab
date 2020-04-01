% MSER_DEMO2  Demonstrate MSER code

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

I = load('clown') ; I = uint8(I.X) ;
figure(1) ; imagesc(I) ; colormap gray; hold on ;

[M,N] = size(I) ;
i = double(i) ;
j = double(j) ;

[r,ell] = mser(I,5) ;

r=double(r) ;

[i,j]=ind2sub(size(I),r) ;                    
plot(j,i,'r*') ;

ell = ell([2 1 5 4 3],:) ;
plotframe(ell); 

figure(2) ; 

clear MOV ;
K = size(ell,2) ;
for k=1:K
  clf ;
  sel = erfill(I,r(k)) ;
  mask = zeros(M,N) ; mask(sel) =1 ;
  imagesc(cat(3,I,255*uint8(mask),I)) ; colormap gray ; hold on ;
  set(gca,'position',[0 0 1 1]) ; axis off ; axis equal ;
  plot(j(k),i(k),'r*') ;
  plotframe(ell(:,k),'color','r') ;
  MOV(k) = getframe(gca) ;
end
