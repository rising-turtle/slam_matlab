function update(z,R,idf,batch)
% function update(z,R,idf,batch)
%
% Inputs:
%   z, R - range-bearing measurements and covariances
%   idf - feature index for each z
%   batch -  whether to process measurements together or sequentially
%
% GLOBAL INPUTS:
%   XA PA JXA OmegaPB PsiXB PhiPAB
%
% GLOBAL OUTPUTS:
%   XA, PA - updated state and covariance of part A
%   JXA - will be reset to zeros(1) once used   
%   OmegaPB PsiXB PhiPAB
%

if batch == 1
    batch_update(z,R,idf);
else
    single_update(z,R,idf);
end

%
%
%
function batch_update(z,R,idf)

global XA PA JXA OmegaPB PsiXB PhiPAB XB

lenz= size(z,2);
lenXA= length(XA);
H= zeros(2*lenz, lenXA);
v= zeros(2*lenz, 1);
RR= zeros(2*lenz);

for i=1:lenz
    ii= 2*i + (-1:0);
    [zp,H(ii,:)]= observe_model(XA, idf(i));
    
    v(ii)= [z(1,i)-zp(1);
               pi_to_pi(z(2,i)-zp(2))];
    RR(ii,ii)= R;
end
        
% 
PHt = PA*H';
S = H*PHt+RR;
Si = inv(S);
Si= make_symmetric(Si);
%PSD_check= chol(Si);
W= PHt*Si;

Kappa = H'*Si*H;
Zeta = W*H;

% update part A
XA = XA + W*v;
PA = PA - make_symmetric(W*S*W');
%PSD_check= chol(PA);

% calculate OmegaPB PsiXB PhiPAB
if length(XB)~=1
    if size(OmegaPB,1) == 1        
        OmegaPB = JXA'*Kappa*JXA;
        PsiXB = JXA'*H'*Si*v;
        PhiPAB = (eye(size(XA,1)) - Zeta)*JXA;    
    else
        OmegaPB = OmegaPB + PhiPAB'*JXA'*Kappa*JXA*PhiPAB;
        PsiXB = PsiXB + PhiPAB'*JXA'*H'*Si*v;
        PhiPAB = ((eye(size(XA,1)) - Zeta)*JXA)*PhiPAB;        
    end   
    JXA = zeros(1); % 
end

%
%
%
function single_update(z,R,idf)

global XA PA JXA OmegaPB PsiXB PhiPAB XB

lenz= size(z,2);
for i=1:lenz
    [zp,H]= observe_model(XA, idf(i));
    
    v= [z(1,i)-zp(1);
        pi_to_pi(z(2,i)-zp(2))];
    
    % update part A
    % this code is copied from KF_tricksimple_update()
    Ns = 3 + 2*idf(i) - 1;
    Ne = Ns+1;
    Hv = H(:,1:3);
    Hi = H(:,Ns:Ne);

    PHt= PA(:,1:3)*Hv' + PA(:,Ns:Ne)*Hi';
    S = Hv*PHt(1:3,:) + Hi*PHt(Ns:Ne,:) + R;
    Si= inv(S);
    Si= make_symmetric(Si);
    %PSD_check= chol(Si);
    W= PHt*Si;
    
    Kappa = H'*Si*H;
    Zeta = W*H;

    XA= XA + W*v; 
    PA= PA - make_symmetric(W*PHt');
    %PSD_check= chol(PA);
    %%%
    
    % calculateOmegaPB PsiXB PhiPAB
    if length(XB) ~= 1
        if size(OmegaPB,1) == 1        
            OmegaPB = JXA'*Kappa*JXA;
            PsiXB = JXA'*H'*Si*v;
            PhiPAB = (eye(size(XA,1)) - Zeta)*JXA;
        else
            OmegaPB = OmegaPB + PhiPAB'*JXA'*Kappa*JXA*PhiPAB;
            PsiXB = PsiXB + PhiPAB'*JXA'*H'*Si*v;
            PhiPAB = ((eye(size(XA,1)) - Zeta)*JXA)*PhiPAB;        
        end
        JXA = eye(size(JXA));
    end
end
JXA = zeros(1); % 

function P= make_symmetric(P)
P= (P+P')*0.5;
      
