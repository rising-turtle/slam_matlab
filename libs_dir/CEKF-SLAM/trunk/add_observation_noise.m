function z= add_observation_noise(z,R, addnoise)
%function z= add_observation_noise(z,R, addnoise)
%
% Add random measurement noise. We assume R is diagonal.
%

if addnoise == 1
    len= size(z,2);
    if len > 0
        z(1,:)= z(1,:) + randn(1,len)*sqrt(R(1,1));
        z(2,:)= z(2,:) + randn(1,len)*sqrt(R(2,2));
        
        %the noise observations should also within (-pi/2 pi/2)
        x=find(z(2,:)>-pi/2);       
        zx=z(:,x);
        x=find(zx(2,:) < pi/2);
        z=zx(:,x);
    end
end
