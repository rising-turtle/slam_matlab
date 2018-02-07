function xv = vehicle_model(xv, V, W, dt)
%
% INPUTS:
%   xv - robot pose
%   V - forward speed
%   W - angular speed
%   dt - change in time
%
% OUTPUTS:
%   xv - new robot pose
%

if abs(W) <  1e-3
    xv = [ xv(1) + V*dt*cos(xv(3));
              xv(2) + V*dt*sin(xv(3));
              pi_to_pi( xv(3) ) ];
else
    xv = [ xv(1) + V/W*( sin(xv(3)+W*dt) - sin(xv(3)) );
              xv(2) + V/W*( cos(xv(3)) - cos(xv(3)+W*dt) );
              pi_to_pi( xv(3) + W*dt ) ];
end

