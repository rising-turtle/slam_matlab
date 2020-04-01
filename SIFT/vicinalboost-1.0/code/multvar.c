/** file:        multvar.mex.c
 ** description: MEX
 ** author:      Andrea Vedaldi
 **/

#include"mex.h"

#include<stdio.h>
#include<stdlib.h>
#include<math.h>
#include<string.h>
#include<assert.h>

typedef unsigned int idx_t ;


/* 
    [GSG, SG] = MULTVAR(S,GAMMA) computes

    gSg = GAMMA' S GAMMA
    Sg  =        S GAMMA

    This is a `vectorized' version, operating on N values of SIGMA and
    K values of GAMMA.

    The input argument S is a (1+PL) x (N) matrix. Each column encodes
    in compact form the i-th variance matrix S_i and there are N of
    them (i=1 ... N).  Each column S_i has the following format:
    
    - S_i(1)               = sigma_i
    - S_i(2:L+1)           = A_1i
    - ...
    - S_i(1+(P-1)*L+(0:L)) = A_Pi

    such that the variance matrix S_i is obtained as

    S_i = sigma_i^2 I   +  sum_p  A_pi A_pi^T

    where I denotes the identity.

    The input argument GAMMA is a L x K matrix Each column is a vector
    GAMMA_j and there are K of them (k=1 ... K).

    The output argument GSG has K rows and N columns, each entry being
    equal to

    GSG_ki = GAMMA_k' S GAMMA_k

    The output argument SG is defined only for the case K=1 and has L
    rows and N columns, the i-th column being equal to
    
    SG_:i = S_i GAMMA_1

    GSG = MULTVAR(S,GAMMA,GAMMAP) computes

    gpSg = GAMMAP' S GAMMA   
*/

void
mexFunction(int nout, mxArray *out[], 
            int nin, const mxArray *in[])
{

  enum {IN_SIGMA,IN_GAMMA,IN_GAMMAP} ;
  enum {OUT_GSG,OUT_SG} ;
  int L,N,K,P,T,i,k,l,p ;

  mxArray* sg_array = 0 ;

  double const* sigma_pt ;
  double const* gamma_pt ;
  double const* gammap_pt = 0 ;
  double * sg_pt = 0 ;
  double * gsg_pt ;

  int have_gammap = 0 ;
  
  /** -----------------------------------------------------------------
   **                                               Check the arguments
   ** -------------------------------------------------------------- */
  if (nin < 2) {
    mexErrMsgTxt("Two arguments required.");
  } else if (nin > 3) {
    mexErrMsgTxt("At most three arguments.") ;
  } else if (nout > 2) {
    mexErrMsgTxt("Too many output arguments.");
  }
  
  if(mxGetClassID(in[IN_SIGMA] ) != mxDOUBLE_CLASS ||
     mxGetClassID(in[IN_GAMMA] ) != mxDOUBLE_CLASS) {
    mexErrMsgTxt("SIGMA and GAMMA must be DOUBLE") ;
  }
  
  L = mxGetM(in[IN_GAMMA]) ; 
  K = mxGetN(in[IN_GAMMA]) ; 
  T = mxGetM(in[IN_SIGMA]) ; 
  N = mxGetN(in[IN_SIGMA]) ; 

  /* set P so that T = LP+1 */
  P = (T-1)/L ;

  /* mexPrintf("N %d P %d T %d L %d\n",N,P,T,L) ; */

  if( T != L*P + 1) {
    mexErrMsgTxt("The row dimension of SIGMA and GAMMA are not compatible") ;
  }

  /* check for consistency */
  if( nout > 1 ) {
    if( K > 1 ) {
      mexErrMsgTxt("With SG output GAMMA can have only one column") ;
    }
  }
 
  sigma_pt = mxGetPr(in[IN_SIGMA]) ;
  gamma_pt = mxGetPr(in[IN_GAMMA]) ;

  if( nin > 2 ) {
    if( mxGetM(in[IN_GAMMAP]) != L ||
        mxGetN(in[IN_GAMMAP]) != K ) {
      mexErrMsgTxt("GAMMA and GAMMAP must have the same dimensions") ;
    }
    gammap_pt = mxGetPr(in[IN_GAMMAP]) ;
    have_gammap = 1 ;
  } else {
    gammap_pt = gamma_pt ;
  }

  out[OUT_GSG] = mxCreateDoubleMatrix(K,N,mxREAL) ;
  gsg_pt       = mxGetPr(out[OUT_GSG]) ; 

  if( nout > 1 ) {
    sg_array     = mxCreateDoubleMatrix(L,N,mxREAL) ;
    sg_pt        = mxGetPr(sg_array) ;
  } 
    
  /* for each vector GAMMA_k */
  for(k = 0 ; k < K ; ++k) {
    
    /* for each variance matrix S_i */
    for( i = 0 ; i < N ; ++ i ) {
      
      /* for each matrix A_pi */
      for( p = 0 ; p < P ; ++p ) {
        
        /* do A_pi' gamma_k */
        double acc = 0.0 ;
        double accp = 0.0 ;
        for( l = 0 ; l < L ; ++l ) {
          acc += sigma_pt[p*L+l+1] * gamma_pt[l] ;
        }
   
        /* do SG_:i +=  A_pi (A_pi' gamma_k) */
        if( sg_pt ) {
          for( l = 0 ; l < L ; ++l ) {
            sg_pt [l] += sigma_pt[p*L+l+1] * acc ;
          }
        }
        
        /* optionally do gammap_k' A_pi */
        if( have_gammap ) {
          for( l = 0 ; l < L ; ++l ) {
            accp += sigma_pt[p*L+l+1] * gammap_pt[l] ;
          }
        } else {
          accp = acc ;
        }

        /* do SGS_ki +=  (gamma'_k A_pi)(A_pi' gamma_k) */
        *gsg_pt += acc*accp ;
      }
    
      /* do SG_:i += sigma_i^2 gamma_k 
         GSG_ki += sigma_i^2 dot(gammap_k,gamma_k) */
      for( l = 0 ; l < L ; ++ l ) {
        double tmp = sigma_pt[0]*sigma_pt[0]*gamma_pt[l] ;
        if( sg_pt ) sg_pt[l] += tmp ;
        *gsg_pt += gammap_pt[l] * tmp ;
      }

      /* next variance matrix */
      sigma_pt += 1+L*P ;
      gsg_pt   += K ;
      if( sg_pt ) sg_pt += L ;  
    }

    /* next vector gamma */
    sigma_pt  -= N * (1+L*P) ; 
    gsg_pt    += 1 - (K*N) ;
    gamma_pt  += K ;
    gammap_pt += K ;
  }
  
  if( nout > 1 ) {
    out[OUT_SG] = sg_array ;
  } else {
    mxDestroyArray( sg_array ) ;
  }
}
