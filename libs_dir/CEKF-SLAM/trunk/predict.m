function predict (Vn,Wn,QE, dt)
%function predict (Vn,Wn,QE, dt)
%
% INPUTS:
%   Vn,Wn - control inputs: forward speed and angular speed
%   QE - covariance matrix for forward speed and angular speed
%   dt - timestep
%
% GLOBAL INPUTS:
%   XA PA
%   JXA
%   
% GLOBAL OUTPUTS:
%   XA PA - predicted state and covariance of part A
%   JXA - the predict auxiliary Jaccobi matrix for multi predicts between
%           two updates
%
%   Zhang Haiqiang 2007-11-20
%   Zhang Haiqiang 2008-5-11
%

global XA PA JXA XB

s = sin(XA(3));
c = cos(XA(3));
sp = sin(XA(3)+Wn*dt);
cp = cos(XA(3) + Wn*dt);
vt = Vn*dt;
wt = Wn*dt;

%if abs(Wn) < 1e-3
if isinf(1.0/Wn)
    xv_p = [ XA(1) + vt*c;
                 XA(2) + vt*s;
                 pi_to_pi( XA(3) ) ];
                 
    Gu = [ dt*c     0;
              dt*s     0;
              0         0 ]; 
else
    xv_p = [ XA(1) + Vn/Wn*( sp -s );
                 XA(2) + Vn/Wn*( c -cp );
                 pi_to_pi( XA(3) + wt ) ];
             
    Gu = [ (sp - s )/Wn  (vt*cp - (xv_p(1) - XA(1)))/Wn;
               (c -cp )/Wn  (vt*sp - (xv_p(2) - XA(2)))/Wn;
               0                    dt ];
end

Gv = [ 1    0    XA(2) - xv_p(2);
          0    1    xv_p(1) - XA(1);
          0    0    1];
      
% predict PA
PA(1:3,1:3)= Gv*PA(1:3,1:3)*Gv' + Gu*QE*Gu';
if size(PA,1) > 3
    PA(1:3,4:end)= Gv*PA(1:3,4:end);
    PA(4:end,1:3)= PA(1:3,4:end)';
end    

% predict XA
XA(1:3) = xv_p;

% calculate JXA(the predict auxiliary  coefficient for PAB)
if length(XB)~=1
    current_JXA = eye(size(PA,1));
    current_JXA(1:3,1:3) = Gv;
    if size(JXA,1) == 1
        JXA = current_JXA;
    else
        JXA = current_JXA*JXA;
    end
end

