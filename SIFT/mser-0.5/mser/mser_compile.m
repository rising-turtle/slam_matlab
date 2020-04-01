function mser_compile(type)
% MSER_COMPILE  Compile MEX files

opts = { '-O', '-I.' } ;

mex('mser.mex.c','-output', 'mser',opts{:}) ;
mex('erfill.mex.c','-output', 'erfill',opts{:}) ;
