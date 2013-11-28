#include "mex.h"
#include <iostream>

void mexFunction(int nlhs, mxArray* plhs[], int nrhs, const mxArray *prhs[])
{
  if(nrhs!=2)
    mexErrMsgIdAndTxt( "print_array:inputs",
                       "Two inputs required.");
  //else if(nlhs!=0)
    //mexErrMsgIdAndTxt( "print_array:outputs",
                       //"no output required.");
  double *X=mxGetPr(prhs[0]);
  mwSize nX = mxGetN(prhs[0]);  
  double *Y=mxGetPr(prhs[1]);
  mwSize nY = mxGetN(prhs[1]);  
  for (int i=0;i<nX;i++) {
    std::cout << X[i]  <<" ";            
  }     
  std::cout << std::endl;
  for (int i=0;i<nY;i++) {
    std::cout << Y[i]  <<" ";            
  }     
  std::cout << std::endl;
  plhs[0]=mxCreateNumericMatrix(0,0,mxDOUBLE_CLASS,mxREAL);
  double* data=(double*)mxMalloc(3*sizeof(double));
  data[0]=0;data[1]=1;data[2]=2;
  mxSetPr(plhs[0],data);
  mxSetM(plhs[0],1);
  mxSetN(plhs[0],3);
  return;
}
