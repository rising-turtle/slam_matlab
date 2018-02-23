function [Vn,Wn]= add_control_noise(V,W,Q, addnoise)
%function [Vn,Wn]= add_control_noise(V,W,Q, addnoise)
%
% Add random noise to nominal control values. We assume Q is diagonal.
%

if addnoise == 1
    Vn= V + randn(1)*sqrt(Q(1,1));
    Wn= W + randn(1)*sqrt(Q(2,2));
end
