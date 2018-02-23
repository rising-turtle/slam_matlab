function augment(z,R)
%function augment(z,R)
%
% INPUTS:
%   z, R - range-bearing measurements and covariances, each of a new feature
%
% GLOBAL INPUTS:
%   XA, PA
%   PhiPAB
%   JXA
%
% GLOBAL OUTPUTS:
%   XA, PA
%   PhiPAB
%
%
% Haiqiang Zhang 2008-5-11

% add new features to state
for i=1:size(z,2)
    add_one_z(z(:,i),R);
end

%
%
%
function add_one_z(z,R)

global XA PA PhiPAB PAB

len= length(XA);
r= z(1); b= z(2);
s= sin(XA(3)+b); 
c= cos(XA(3)+b);

% augment XA
XA= [XA;
        XA(1) + r*c;
        XA(2) + r*s];

% jacobians
Gv= [1 0 -r*s;
        0 1  r*c];
Gz= [c -r*s;
        s  r*c];
     
% augment PA
rng= len+1:len+2;
PA(rng,rng)= Gv*PA(1:3,1:3)*Gv' + Gz*R*Gz'; % feature cov
PA(rng,1:3)= Gv*PA(1:3,1:3); % vehicle to feature xcorr
PA(1:3,rng)= PA(rng,1:3)';
if len>3
    rnm= 4:len;
    PA(rng,rnm)= Gv*PA(1:3,rnm); % map to feature xcorr
    PA(rnm,rng)= PA(rng,rnm)';
end

%augment PhiPAB
if size(PAB,1) ~= 1
    if size(PhiPAB,1) ~= 1
        PhiPAB = [PhiPAB; Gv*PhiPAB(1:3,:)];
    else
        PAB=[PAB; Gv*PAB(1:3,:)];
    end
end
