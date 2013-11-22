#include <vector>
#include <assert.h>
#include <pthread.h>
#include "Polynomial.h"
#include "doRegression.h"
#include "mex.h"

struct Data
{
  Vector x;
  Vector y;
  Vector lower;
  Vector upper;
  Vector mask;
  Polynomial poly;
};

void* threadFunc(void* in){
  Data& data=*(Data*)in;
  for(int i=0;i<3;++i){
    std::cout << "(" << data.x[i] << ',' << data.y[i] << ')' << std::endl;
    std::cout << data.mask.size() << data.mask[0] << std::endl;
  }
  Polynomial* poly=new Polynomial(doRegression(data.x,data.y,data.lower,data.upper,data.mask,data.poly));
  delete &data;
  return poly;
}

void runThreads(Data** data, int instances)
{
  std::cerr << "ENTERING THREADS\n";
  pthread_t thread[instances-1];
  std::cerr << data[0]->y[0] << std::endl;
  for(int i=1;i<instances;++i){
    pthread_create(thread+i-1,NULL,threadFunc,(void**)(data[i]));
  }
  data[0]=(Data*)threadFunc( data[0]);
  for(int i=0;i<instances-1;++i){
    pthread_join(thread[i],(void**)(&(data[i+1])));
  }
  std::cerr << "EXITING THREADS";
  return;
}

void mexFunction(int nlhs, mxArray* plhs[], int nrhs, const mxArray *prhs[])
//lhs: polynomial array
//rhs: xdata,ydata, lower bounds, upper bounds, mask, initial vlaues
{
  //if(nrhs!=2)
    //mexErrMsgIdAndTxt( "print_array:inputs",
                       //"Two inputs required.");
  //else if(nlhs!=0)
    //mexErrMsgIdAndTxt( "print_array:outputs",
                       //"no output required.");
  //x and y data
  int instances=mxGetN(prhs[0]);//each column is an instance for the solver
  Data* data[instances];
  int width;
  for(int i=0;i<instances;++i){
    data[i]=new Data;
    width=mxGetM(prhs[0]);
    data[i]->x=toVector(mxGetPr(prhs[0])+width*i,width);

    width=mxGetM(prhs[1]);
    data[i]->y=toVector(mxGetPr(prhs[1])+width*i,width);

    assert(data[i]->y.size()>2);
    assert(data[i]->x.size()>2);
    std::cerr << "x: " << data[i]->x.size() << "y: " << data[i]->y.size() << std::endl;
    assert(data[i]->x.size()==data[i]->y.size());
    std::cout << "Data size: " << data[i]->x.size() << std::endl;
    for(int j=1;j<data[i]->x.size();++j){
      assert(data[i]->x[j-1]<data[i]->x[j]);
      //assert(data[i]->x.size()<3);
      //-- std::cout << '(' << x[i] << ',' << y[i] << ")\n";
    }

    //bounds arrays
    width=mxGetM(prhs[2]);
    data[i]->lower=toVector(mxGetPr(prhs[2])+width*i,width);
    width=mxGetM(prhs[3]);
    data[i]->upper=toVector(mxGetPr(prhs[3])+width*i,width);

    //mask
    width=mxGetM(prhs[4]);
    data[i]->mask=toVector(mxGetPr(prhs[4])+width*i,width);
  
    //get the polynomial
    width=mxGetM(prhs[5]);
    data[i]->poly=Polynomial(mxGetPr(prhs[5])+width*i,width);
  }
  runThreads(data,instances);
  Polynomial** results=(Polynomial**) data;
  std::cerr << "BACK" << std::endl;
  int max_order(0);
  for(int i=0;i<instances;++i){
    if(results[i]->order()>max_order)
      max_order=results[i]->order();
  }
  std::cerr << "order done: " << max_order << std::endl;

  plhs[0]=mxCreateNumericMatrix(0,0,mxDOUBLE_CLASS,mxREAL);
  double* result_data=(double*)mxMalloc(instances*(max_order+1)*sizeof(double));
  for(int i=0;i<instances;++i){
    for(int j=0;j<=max_order;++j){
      result_data[(max_order+1)*i+j]=(*(results[i]))[j];
    }
  }
  for(int i=0;i<instances;++i){
    delete results[i];
  }
  std::cerr << "copy done" << std::endl;
  mxSetPr(plhs[0],result_data);
  mxSetM(plhs[0],max_order+1);
  mxSetN(plhs[0],instances);
  return;
}
