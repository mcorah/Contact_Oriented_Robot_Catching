#include <iostream>
#include "math.h"
#include "doRegression.h"

#define DIM 4

static double calculateCost(Polynomial& poly, const Vector& x, const Vector& y);
static bool isValid(Polynomial& poly, Vector lower, Vector upper, double max_x);


Polynomial doRegression(const Vector& x, const Vector& y, const Vector& lower, const Vector& upper, const Vector& mask, Polynomial& guess)
{
  std::cerr << "RUNNING" << std::endl;
  double curr_cost;
  double min_cost=calculateCost(guess,x,y);
  Polynomial best=guess;
  double max_x=x.back();
  double min=-15;
  double max=15;
  double inc=0.2;
  int dim=DIM;
  for(int i=0;i<=dim;++i){
    if(mask.size()-1<i || mask[i]==0)
      guess[i]=min;
  }
  //check initial
  if(isValid(guess,lower,upper,max_x)){
    curr_cost=calculateCost(guess,x,y);
    if(curr_cost<min_cost){
      min_cost=curr_cost;
      best=guess;
      //-- std::cout << "Updating best: " << best << " error: " << curr_cost << std::endl;
    }
  }
  //for every dimension
  int n=0;
  //-- std::cout << "Initial: " << guess << std::endl;
  while(n<=dim){
    //std::cout << "Looping" << std::endl;
    //check if dimension changable
    while(mask.size()>n && mask[n]==1) ++n;
    //std::cout << "Current: " << guess << std::endl;
    if(guess[n]<max){
      //increment guess
      guess[n]+=inc;
      n=0;

      //check guess
      if(isValid(guess,lower,upper,max_x)){
        //-- std::cout << "Checking: " << guess << std::endl;
        curr_cost=calculateCost(guess,x,y);
        if(curr_cost<min_cost){
          min_cost=curr_cost;
          best=guess;
          //-- std::cout << "Updating best: " << best << " error: " << curr_cost << std::endl;
        }
      }
    }else{
      guess[n]=min;
      ++n;
    }
  }
  std::cout << "Best: " << best << " error: " << min_cost << std::endl;
  return best;
}

Vector toVector(double* data, int n)
{
  Vector v;
  for(int i=0;i<n;++i){
    v.push_back(data[i]);
  }
  return v;
}

static bool isValid(Polynomial& poly, Vector lower, Vector upper, double max_x)
{
  //-- std::cout << "Checking validity of: " << poly << std::endl;
  for(int i=0;i<lower.size();++i)
    if(poly.derivative(i).min(0,max_x)<lower[i]){
      //-- std::cout << "Failed lower dim: " << i << " val: " << lower[i] << " poly: " << poly << std::endl;
      return false;
    }
  for(int i=0;i<upper.size();++i)
    if(poly.derivative(i).max(0,max_x)>upper[i]){
      //-- std::cout << "Failed upper dim: " << i << " val: " << upper[i] << " poly: " << poly << std::endl;
      return false;
    }
  return true;
}

static double calculateCost(Polynomial& poly, const Vector& x, const Vector& y)
{
  double error=0;
  for(int i=0;i<x.size();++i){
    //check for nans, they be bad
    if(isfinite(y[i]) && isfinite(x[i]))
      error+=ABS(poly(x[i])-y[i]);
  }
  //-- std::cout << "Cost is: " << error << std::endl;
  return error;
}
