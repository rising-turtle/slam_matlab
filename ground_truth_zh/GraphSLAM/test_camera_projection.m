% Simple Camera projection

fx=250; % focal length [pixel]
fy=250;
u0=176/2;  % image center 
v0=144/2;  % image center

K = [ fx 0 u0; 0 fy v0; 0 0 1];

%p=[1 0 0.8]';
p=[-0.373185370155499,0.185385173716954, 1.04691840944206]';
p=[-428*1000,670*1000, 798*1000]';

ip=K*p;
ip=ip/ip(3);

u = (fx * p(1) / p(3) + u0)
v = (fy * p(2) / p(3) + v0)

plot(u,v,'d');
%axis([0 u0*2 0 v0*2]);



cam = initialize_cam();
features_info=[];
camera_uv = hi_cartesian_test( p, [0;0;0], eye(3), cam, features_info )


%% Inverse re-projection
%u=u0;
%v=v0;

%x = (u - u0) * p(3) / fx
%y = (v - v0) * p(3) / fy

%plot(x,y,'r+');

