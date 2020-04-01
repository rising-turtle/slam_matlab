#include"mex.h"
#include"math.h"

#define N 100
double erf_table [2*N+1] ;
int initialized = 0 ;

/** @brief Driver.
 **
 ** @param nount number of output arguments.
 ** @param out output arguments.
 ** @param nin number of input arguments.
 ** @param in input arguments.
 **/
void 
mexFunction(int nout, mxArray *out[], 
            int nin, const mxArray *in[])
{
  enum { IN_A } ;
  enum { OUT_B } ; 
  int i, k, K ;
  double const* A_pt ;
  double      * B_pt ;

  if( nin != 1 ) {
    mexErrMsgTxt("One argument required") ;
  } 
  
  if(!mxIsDouble(in[IN_A]) || mxIsComplex(in[IN_A]))
    mexErrMsgTxt("Real matrix expected") ;
  
  K = mxGetNumberOfElements(in[IN_A]) ;
  A_pt = mxGetPr(in[IN_A]) ;
  
  out[OUT_B] = mxDuplicateArray(in[IN_A]) ;
  B_pt = mxGetPr(out[OUT_B]) ;

  if(! initialized) {
    for(i = -N ; i <= N ; ++i) {
      erf_table[i + N] = erf(3.0 * i/N) ;
    }
    initialized = 1 ;
  }
  
  for(k = 0 ; k < K ; ++k) {
    double x = *A_pt++ ;
    if( x > 3.0) {
      *B_pt++ = 1.0 ;
    } else if( x < -3.0 ) {
      *B_pt++ = -1.0 ;
    } else {
      int i = (int) (x / 3.0 * N) ;
      *B_pt++ = erf_table[i+N] ;
    }
  }
}
