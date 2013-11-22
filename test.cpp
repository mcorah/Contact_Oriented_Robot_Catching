#include <stdlib.h>
#include <iostream>
#include <set>
#include "Polynomial.h"
#include "doRegression.h"
//const double proto[3]={-1,0,1};
//const int nproto=3;

int main(int argc, char** argv){
  double *proto=new double[argc];
  for(int i=0;i<argc;++i)
    proto[i]=atof(argv[i]);

  Polynomial poly(proto,argc);
  std::cout << "f(0)=" << poly.getVal(0)
            << " f(1)=" << poly.getVal(1)
            << " f(2)=" << poly.getVal(2) << std::endl;

  //find the roots
  const std::set<double>& roots=poly.getRoots(-10,10);
  std::set<double>::const_iterator it;
  std::cout << poly << std::endl;
  std::cout << "Found roots: ";
  for(it=roots.begin();it!=roots.end();++it)
    std::cout << " (" << *it << ',' << poly(*it) << ')';
  std::cout << std::endl;
  std::cout << "Max: " << poly.max(-10,10) << " Min: " << poly.min(-10,10) << std::endl;;
  std::cout << "f(2.5)=" << poly(2.5) << std::endl;

  double x[100];
  double y[100];
  for(int i=0;i<100;++i){
    x[i]=0.1*i;
    y[i]=x[i]*x[i]*x[i]-1;
  }
  double lower[3]={-1,-10,-30};
  double upper[3]={1,10,30};
  double mask[2]={1,1};
  poly=doRegression(toVector(x,100),toVector(y,100),toVector(lower,2),toVector(upper,2),toVector(mask,2),poly);
  std::cout << "Result: " << poly << std::endl;
  return 0;
}
