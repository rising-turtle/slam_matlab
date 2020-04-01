function gen_shapes
% GEN_SHAPES  Generate synthetic shapes dataset
%  Data will be saved to 'data/shapes.mat'.

% N  = number of patches per type
% h  = size of a patch in pixels

N = 1000 ;
h = 24 ;

% these functions generates the basic shapes
genf = { @genbox, @gentri, @gencirc, @genstar } ;

% x will store the patterns and y their labels
x = [] ;
y = [] ;

% loop over shapes kind
for k=1:length(genf)
  
  % generate the shape and the virtual samples
  D = virtualsamples(genf{k},N,h) ;
  
  % generate a preview
  figure(k) ; clf ; imarraysc((D+1)/2,'clim',[-1 1]) ;
  colormap gray ; drawnow ;

  % store patterns
  x = [x reshape(D,h*h,N)] ;
  y = [y k*ones(1,size(D,3))] ; 
end

save('data/shapes','x','y') ;

% --------------------------------------------------------------------
function D=virtualsamples(shapef,N,h)
% --------------------------------------------------------------------

% generate basic shape
mask = feval(shapef,h) ;

% parameters
sigma(1) = .5  ;   % std dev translation x
sigma(2) = .5  ;   % std dev translation y
sigma(3) = .2  ;   % std dev skewiness
sigma(4) = .1  ;   % std dev scale
sigma(5) = .1  ;   % std dev rotation
sigma(6) = .08 ;   % std dev brightness
sigma(7) = .1  ;   % std dev offset
sigma(8) = .05 ;   % std dev noise

% brightness bias (min abs bright)
bright = .5 ;

% generate a bunch of random affine tf
tx = sigma(1) * randn(1,N) ;
ty = sigma(2) * randn(1,N) ;
sk = sigma(3) * randn(1,N) ;
sc = sigma(4) * randn(1,N) + 1 ;
rt = sigma(5) * randn(1,N) ;

% generate a bunch of illuminations
b  = sigma(6) * randn(1,N) ; b  = sign(b)*bright + b ;
o  = sigma(7) * randn(1,N) ;

% coordinate system
ur=linspace(-h/2,h/2,h) ;
vr=linspace(-h/2,h/2,h) ;
[u,v]=meshgrid(ur,vr) ;

% warp patches
D = zeros(h,h,N) ;
for n=1:N
  c = cos(rt(n)) ;
  s = sin(rt(n)) ;
  
  % rotation, skew, scale translation
  R = [c     -s    ; s    c     ] ;
  Q = [1     sk(n) ; 0    1     ] ;
  S = [sc(n) 0     ; 0    sc(n) ] ;
  T = [tx(n) ; ty(n) ] ;
  
  % compose
  A = R*S*Q ;
    
  % warp mesh
  [wu,wv]=waffine(A,T,u,v);
  
  % warp image
  I = imwbackward(ur,vr,mask,wu,wv) ;

  % pad with zeros instead of NaNs
  I(isnan(I))=0 ;
  
  % add brightness, offsett and noise
  I = b(n)*I + o(n) + sigma(8)*randn(h) ;
  
  % save back
  D(:,:,n) = I ;
  
  %figure(100) ; clf ; imagesc(I) ; drawnow ; colormap gray ;  
end


% --------------------------------------------------------------------
function mask=genbox(h)
% --------------------------------------------------------------------
mask = zeros(h) ;
mask(6:18,6:18) =1 ;

% --------------------------------------------------------------------
function mask=gencirc(h)
% --------------------------------------------------------------------
mask = zeros(h) ;
ur=linspace(-h/2,h/2,h) ;
vr=linspace(-h/2,h/2,h) ;
[u,v]=meshgrid(ur,vr) ;
mask = (1+erf((h/3)^2 - u.*u-v.*v))*.5 ;

% --------------------------------------------------------------------
function mask=gentri(h) 
% --------------------------------------------------------------------

ur=linspace(-h/2,h/2,h) ;
vr=linspace(-h/2,h/2,h) ;
[u,v]=meshgrid(ur,vr) ;
mask = (1+erf((h/3)^2 - u.*u-v.*v)) ;

n1 = [-sqrt(3),-1] ;
l1 = +sqrt(3)/4 ;
n2 = [+sqrt(3),-1] ;
l2 = +sqrt(3)/4 ;
n3 = [0,+1] ;
l3 = +sqrt(3)/4  ;

dv = -sqrt(3)/4 + 2/sqrt(3)/4 ;
sc = 1.5/h;
u = sc * u  ;
v = sc * v + dv ;

mask = ones(h) ;
mask = mask & (n1(1)*u+n1(2)*v+l1 >= 0) ;
mask = mask & (n2(1)*u+n2(2)*v+l2 >= 0) ;
mask = mask & (n3(1)*u+n3(2)*v+l3 >= 0) ;
mask = double(mask) ;

% --------------------------------------------------------------------
function mask=genstar(h) 
% --------------------------------------------------------------------

mask = gentri(h) ;
mask = mask | flipud(gentri(h)) ;
mask = double(mask) ;
