function [W,iwp]= compute_rotationspeed(wp, iwp, minD, W, maxW, dt)
%function [W,iwp]= compute_rotationspeed(wp, iwp, minD, W, maxW, dt)
%
% INPUTS:
%   xtrue - true position
%   wp - waypoints
%   iwp - index to current waypoint
%   minD - minimum distance to current waypoint before switching to next
%   W - current rotaion speed
%   maxW - max rotaion speed (rad/s)
%   dt - timestep
%
% GLOBAL INPUTS:
%   vtrue
%
% OUTPUTS:
%   W - new current rotaion speed
%   iwp - new current waypoint
%

global vtrue
% determine if current waypoint reached
cwp= wp(:,iwp);
d2= (cwp(1)-vtrue(1))^2 + (cwp(2)-vtrue(2))^2;
if d2 < minD^2
    iwp= iwp+1; % switch to next
    if iwp > size(wp,2) % reached final waypoint, flag and return
        iwp=0;
        return;
    end    
    cwp= wp(:,iwp); % next waypoint
end

% compute change in heading to point toward the current waypoint
deltaHeading= pi_to_pi(atan2(cwp(2)-vtrue(2), cwp(1)-vtrue(1)) - vtrue(3));

%
if abs(deltaHeading) < maxW*dt
    W = 0;
else
    W = sign(deltaHeading)*maxW;
end
