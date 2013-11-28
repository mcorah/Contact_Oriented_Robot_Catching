#include <gsl/gsl_multimin.h>
#include <iostream>
#include "math.h"
#include "doRegression.h"

#define DIM 10

static double calculateCost(Polynomial& poly, const Vector& upper, const Vector& lower, const Vector& x, const Vector& y);
static Vector calculateGradient(Polynomial& poly, const Vector& upper, const Vector& lower, const Vector& x, const Vector& y, int order);
static bool isValid(Polynomial& poly, Vector lower, Vector upper, double max_x);


Polynomial doRegression(const Vector& x, const Vector& y, const Vector& lower, const Vector& upper, const Vector& mask, Polynomial& guess)
{
  //-- std::cerr << "RUNNING" << std::endl;
  double curr_cost;
  double min_cost=calculateCost(guess,upper,lower,x,y);
  Polynomial best=guess;
  double max_x=x.back();
  double min=-15;
  double max=15;
  double inc=0.2;
  int dim=DIM;
  for(int i=0;i<=dim;++i){
    if(mask.size()-1<i || ABS(mask[i])<0)
      guess.setCoefficient(i,min);
  }
  //check initial
  if(isValid(guess,lower,upper,max_x)){
    curr_cost=calculateCost(guess,upper,lower,x,y);
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
      guess.setCoefficient(n,guess[n]+inc);
      n=0;

      //check guess
      if(isValid(guess,lower,upper,max_x)){
        //-- std::cout << "Checking: " << guess << std::endl;
        curr_cost=calculateCost(guess,upper,lower,x,y);
        if(curr_cost<min_cost){
          min_cost=curr_cost;
          best=guess;
          //-- std::cout << "Updating best: " << best << " error: " << curr_cost << std::endl;
        }
      }
    }else{
      guess.setCoefficient(n,min);
      ++n;
    }
  }
  //-- std::cout << "Best: " << best << " error: " << min_cost << std::endl;
  return best;
}

Polynomial gradientDescent(const Vector& x, const Vector& y, const Vector& lower, const Vector& upper, const Vector& mask, Polynomial& guess)
{
  Polynomial poly, new_poly, best_poly;
  best_poly=poly=new_poly=guess;
  Vector grad;
  double best_cost, curr_cost, prev_cost;
  best_cost=curr_cost=prev_cost=calculateCost(poly,upper,lower,x,y);
  double a;
  int fail=0;
  int dim=DIM;
  int num=0;

  //ensure that you are starting with a valid guess
  while(!isValid(poly,lower,upper,x.back())){
    for(int i=0;i<=poly.order();++i){
      if(mask.size()-1<i || ABS(mask[i])<1){
        poly.setCoefficient(i,0.8*poly[i]);
      }
    }
  }
  while(fail++<100 && num<2e4){
    grad=calculateGradient(poly,upper,lower,x,y,dim);
    a=1e-9;

    while(num++<1e5){
      new_poly=poly;
      for(int i=0;i<=dim;++i){
        if(mask.size()-1<i || ABS(mask[i])<1){
          new_poly.setCoefficient(i,poly[i]-a*grad[i]);
        }
      }
      //-- std::cerr << "Candidate: " << poly << std::endl;

      //if(isValid(new_poly,lower,upper,1.2*x.back())){
      if(isValid(new_poly,lower,upper,x.back())){
        curr_cost=calculateCost(new_poly,upper,lower,x,y);
        if(curr_cost<=prev_cost){
          poly=new_poly;
          prev_cost=curr_cost;
          a*=1.1;

          --fail;

          if(curr_cost<best_cost){
            best_poly=poly;
          }
        }else{
          //--std::cerr << "Failed due to cost, best: " << prev_cost << " curr: " << curr_cost << std::endl;
          break;
        }
      }else{
        //--std::cerr << "Failed validity test" << std::endl;
        break;
      }
    }
  }
  std::cout << "Num tests: " << num << std::endl;
  return best_poly;
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
  for(int i=0;i<lower.size();++i){
#ifdef NONEWTON
    Polynomial& p=poly.derivative(i);
    for(double j=0;j<max_x;j+=0.01){
      if(p(j)<lower[i]) return false;
    }
#else
    if(poly.derivative(i).min(0,max_x)<lower[i]){
      //-- std::cout << "Failed lower dim: " << i << " val: " << lower[i] << " poly: " << poly << std::endl;
      return false;
    }
#endif
  }
  for(int i=0;i<upper.size();++i){
#ifdef NONEWTON
    Polynomial& p=poly.derivative(i);
    for(double j=0;j<max_x;j+=0.01){
      if(p(j)>upper[i]) return false;
    }
#else
    if(poly.derivative(i).max(0,max_x)>upper[i]){
      //-- std::cout << "Failed upper dim: " << i << " val: " << upper[i] << " poly: " << poly << std::endl;
      return false;
    }
#endif
  }
  return true;
}

static double calculateCost(Polynomial& poly, const Vector& upper, const Vector& lower, const Vector& x, const Vector& y)
{
  double ave_error=0;
  double min_error=ABS(poly(x[0])-y[0]);
  double boundary=0;
  double temp;
  double val,diff;
  int num_d_const=upper.size();//assuming num upper and lower constraints same for now
  Vector derivatives(num_d_const,0);
  Vector prev_derivatives(num_d_const,0);
  for(int i=0;i<x.size();++i){
    //check for nans, they be bad
    if(isfinite(y[i]) && isfinite(x[i])){
      val=poly(x[i]);
      diff=ABS(val-y[i]);
      ave_error+=diff;
      if(diff<min_error) min_error=diff;

      if(upper.size()){
        temp=(val-upper[0])+(upper[0]-lower[0])/30;
        boundary+=(temp>0?temp*temp:0);
      }
      if(lower.size()){
        temp=(lower[0]-val)+(upper[0]-lower[0])/30;
        boundary+=(temp>0?temp*temp:0);
      }
      derivatives[0]=val;
#if 0
      for(int j=1; j<num_d_const && j<=i ;++j){
        derivatives[j]=(derivatives[j-1]-prev_derivatives[j-1])/(x[0]-x[1]);

        temp=(val-upper[j])+(upper[j]-lower[j])/30;
        boundary+=(temp>0?temp*temp:0);
        temp=(lower[j]-val)+(upper[j]-lower[j])/30;
        boundary+=(temp>0?temp*temp:0);
      }
#endif
    }
  }
  ave_error/=x.size();
  //-- std::cout << "Cost is: " << error << std::endl;
  return ave_error+0.5*min_error+0.5*boundary;
  //return ave_error+min_error;
}

static Vector calculateGradient(Polynomial& poly, const Vector& upper, const Vector& lower, const Vector& x, const Vector& y, int order)
{
  double delta=1e-7;
  Polynomial ptemp=poly;
  double lesser,greater;
  
  Vector result(order+1);

  for(int i=0;i<=order;++i){
    ptemp.setCoefficient(i,ptemp[i]-delta/2);
    lesser=calculateCost(ptemp,upper,lower,x,y);

    ptemp.setCoefficient(i,ptemp[i]+delta/2);
    greater=calculateCost(ptemp,upper,lower,x,y);
    
    result[i]=(greater-lesser)/delta;
    ptemp.setCoefficient(i,poly[i]);
  }
  return result;
}
