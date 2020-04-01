function img=haarfilter(gamma,sz,depth,ncoeff);

global WLVERBOSE
WLVERBOSE = 'No';
q=MakeONFilter('Haar',[]);

img0=gamma-mean(mean(gamma));
%imgamma=reshape(gamma,sz);
stats=Calc2dStatTree('WP',img0,depth,q,'Entropy',[]);
bb=Best2dBasis(stats,depth); 
coef=FPT2_WP(bb,img0,q);

coef2=abs(coef(:));
[csort,cind]=sort(coef2);

csel=coef;
csel(cind(1:end-ncoeff))=0;
%csel=coef2(cind(end-ncoeff+1:end));
%csel=reshape(csel(

img=IPT2_WP(bb,csel,q);