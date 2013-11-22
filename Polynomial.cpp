//polynomial function class based on coefficients and supporting math
//Micah Corah

#include <vector>
#include <set>
#include <string>
#include <queue>
#include <stdlib.h>
#include <assert.h>
#include <iostream>
#include <algorithm>
#include "Polynomial.h"

static double power(double val, int pow);
static int findRoots(Polynomial& poly,double min, double max, double guess, std::set<double>& roots);
static double aveOrsame(double x, double y, double xp, double yp);

Polynomial::Polynomial()
  :roots(), roots_found(false), the_derivative(0),
   the_integral(0), threshold(DEFAULT_THRESHOLD) {}

Polynomial::Polynomial(const Polynomial& p)
  : the_polynomial(p.the_polynomial), roots(p.roots), roots_found(p.roots_found), the_derivative(0),
    the_integral(0), threshold(p.threshold)
{
  if(p.the_derivative!=0)
    the_derivative=new Polynomial(*p.the_derivative);
  if(p.the_integral!=0)
    the_integral=new Polynomial(*p.the_integral);
}

Polynomial::Polynomial(const double* data, int n, double threshold)
 : roots(), roots_found(false), the_derivative(0),
   the_integral(0), threshold(threshold)
{
  for(int i=0;i<n;++i){
    the_polynomial.push_back(data[i]);
  }
}

Polynomial::~Polynomial(){
  if(the_derivative!=0)
    delete the_derivative;
  if(the_integral!=0)
    delete the_integral;
}

std::ostream& operator<<(std::ostream& out, Polynomial& poly)
{
  out << "Polynomial: ";
  for(int i=0;i<=poly.order();++i){
    out << (i==0?' ':'+') << poly[i];
    if(i!=0)
      out << "*x^" << i;
    out << ' ';
  }
  return out;
}

Polynomial& Polynomial::operator=(const Polynomial& p){
  this->the_polynomial=p.the_polynomial;
  the_derivative=0;
  the_integral=0;
  roots_found=p.roots_found;
  roots=p.roots;
  threshold=p.threshold;
}

double Polynomial::operator()(double num) const
{
  return getVal(num);
  double result=0;
  for(int i=0;i<the_polynomial.size();++i)
    result+=the_polynomial[i]*power(num,i);
  return result;
}

double Polynomial::getVal(double num) const
{
  double result=0;
  for(int i=0;i<the_polynomial.size();++i)
    result+=the_polynomial[i]*power(num,i);
  return result;
}

double& Polynomial::operator[](int num)
{
  while (the_polynomial.size() < num)
    the_polynomial.push_back(0);
  return the_polynomial[num];
}

int Polynomial::order()
{
  int i;
  if(the_polynomial.size()==0) return 0;
  for(i=the_polynomial.size()-1;i!=0;--i)
    if(the_polynomial[i]!=0) break;
  return i;
}

Polynomial& Polynomial::derivative(int n)
{
  if(n==0)
    return *this;
  if(the_derivative==0){
    the_derivative=new Polynomial;
    for(int i=1; i < this->the_polynomial.size(); ++i){
      the_derivative->addDim(i*the_polynomial[i]);
    }
  }
  if(n==1)
    return *the_derivative;
  else
    return the_derivative->derivative(n-1);
}

Polynomial& Polynomial::integral(int n)
{
  if(the_integral==0){
    the_integral=new Polynomial;
    for(int i=0; i < this->the_polynomial.size(); ++i){
      the_integral->addDim(the_polynomial[i]/(i+1));
    }
    the_integral->addDim(0);
  }
  if(n==1)
    return *the_integral;
  else
    return the_integral->integral(n-1);
}

const std::set<double>& Polynomial::getRoots(double min, double max)
{
  return getRoots(min,max,(min+max)/2);
}

const std::set<double>& Polynomial::getRoots(double min, double max, double guess)
{
  if(!roots_found){
    findRoots(*this,min,max,guess,this->roots);
    roots_found=true;
  }
  return roots;
}

static int findRoots(Polynomial& poly,double min, double max, double guess, std::set<double>& roots)
{
  Polynomial& derivative=poly.derivative();
  double y,x,yp;
  double threshold=poly.getThreshold();

  std::queue<double> guesses;
  guesses.push(guess);
  guesses.push(min);
  guesses.push(max);
  guesses.push(drand48()*(max-min)+min);
  guesses.push(drand48()*(max-min)+min);
  guesses.push(drand48()*(max-min)+min);

  while(guesses.size() && roots.size()<poly.order()){
    x=guesses.front();
    guesses.pop();
    y=poly(x);
    yp=derivative(x);
    //std::cout<<"Current guess: " << x << ',' << y << std::endl;

    //find zeros by Newtons method
    int iterations=0;
    //while(ABS(y)>threshold && iterations++ < NEWTON_MAX){
    while(iterations++ < NEWTON_MAX && yp!=0){
      if(ABS(y)<threshold){
        if(roots.find(x)!=roots.end()) break;
        //std::cout << "EVALUATING CANDIDATE " << x << std::endl;
        //test zero against known zeros
        std::set<double>::iterator lower=roots.lower_bound(x);
        std::set<double>::iterator upper;
        if(lower!=roots.begin())
          upper=lower--;
        else{
          upper=lower;
          lower=roots.end();
        }
        double ylo(0);
        double yup(0);
        if(upper!=roots.end()){
          yup=poly(*upper);
        }
        if(lower!=roots.end()){
          yup=poly(*lower);
        }
        //test against nearbye roots assuming no two zeros can be within the threshold
        //may add more later to allow multiple
        //if(upper!=roots.end()) std::cout << "Upper: " << *upper << std::endl;
        //if(lower!=roots.end()) std::cout << "Lower: " << *lower << std::endl;
        if(lower==roots.end() && upper==roots.end()){
          //std::cout << "No roots yet!" << std::endl;
          assert(!roots.size());
        }

        if(lower!=roots.end() && ABS(*lower-x)<100*threshold){
          if(upper!=roots.end() && ABS(*upper-x)<100*threshold){
            //std::cout << "both within" << std::endl;
            //have to be a little more careful now
            //potentially have two roots or one 
            //current value either replaces one or both
            if(ABS(y)<ABS(yup)){
              if(ABS(y)<ABS(ylo)){
                //better than both
                //replace upper and lower for now
                //much more logic will be required to make a good regression
                double temp=*lower;
                roots.erase(upper);
                roots.erase(temp);
                //std::cout << "double erase" << std::endl;
              }else{
                //if y is better than upper delete upper
                //std::cout << "erase" << std::endl;
                roots.erase(upper);
              }
            }else if(ABS(y)<ABS(ylo)){
              //if y is better than lower delete lower
              //std::cout << "erase" << std::endl;
              roots.erase(lower);
            }else{
              //failed if not yet found
              //std::cout << "breaking" << std::endl;
              break;
            }
          }else if(ylo>0){
            //std::cout << "lower within" << std::endl;
            if(y<0){
              //roots both close, deal with problem
              x=x+(*lower-x)*-ylo/y;
              //std::cout << "erase" << std::endl;
              roots.erase(lower);
            }else if(y<ylo){
              //root is better
              //std::cout << "erase" << std::endl;
              roots.erase(lower);
            }else{
              //failed if not yet found
              //std::cout << "breaking" << std::endl;
              break;
            }
          }else if(ylo<0){
            if(y>0){
              x=x+(*lower-x)*-ylo/y;
              //std::cout << "erase" << std::endl;
              roots.erase(lower);
            }else if(y>ylo){
              //std::cout << "erase" << std::endl;
              roots.erase(lower);
            }else{
              //failed if not yet found
              //std::cout << "breaking" << std::endl;
              break;
            }
          }else{
            //failed if not yet found
            //std::cout << "breaking" << std::endl;
            break;
          }
        }else if(upper!=roots.end() && ABS(*upper-x)<100*threshold){
          //std::cout << "upper within" << std::endl;
          if(yup>0){
            if(y<0){
              //roots both close, deal with problem
              x=((x+*upper)/2);
              //std::cout << "erase" << std::endl;
              roots.erase(upper);
            }else if(y<yup){
              //root is better
              //std::cout << "erase" << std::endl;
              roots.erase(upper);
            }else{
              //failed if not yet found
              //std::cout << "breaking" << std::endl;
              break;
            }
          }else if(yup<0){
            if(y>0){
              x=((x+*upper)/2);
              //std::cout << "erase" << std::endl;
              roots.erase(upper);
            }else if(y>yup){
              //std::cout << "erase" << std::endl;
              roots.erase(upper);
            }else{
              //failed if not yet found
              //std::cout << "breaking" << std::endl;
              break;
            }
          }
        }else{
          //a new root was found, we can now search some more on either side
          //converges when all paths end in finding and existing root
          if(roots.size()<poly.order()){
            //std::cout << "FOUND NEW ROOT: " << x << std::endl;
            guesses.push((x+max)/2);
            guesses.push((x+max)/2);
            guesses.push(drand48()*(max-min)+min);
            guesses.push(drand48()*(max-min)+min);
          }
        }
        //std::cout << "breaking, and inserting" << std::endl;
        roots.insert(x);
        break;
      } //if(ABS(y)<threshold)
      x=x-y/yp;
      y=poly(x);
      yp=derivative(x);
      //std::cout<<"Current guess: " << x << ',' << y << std::endl;
      //std::string temp;
      //std::cin >> temp;
    } //while(iterations++ < NEWTON_MAX && yp!=0)
  } //while(guesses.size() && roots.size()<poly.order())
}

double Polynomial::max(double min, double max){
  double max_found=getVal(min);
  if(getVal(max)>max_found)
    max_found=getVal(max);
  this->derivative().getRoots(min,max);
  std::set<double>::iterator it;
  for(it=derivative().roots.begin();it!=derivative().roots.end();++it){
    if(max_found<getVal(*it)){
      max_found=getVal(*it);
    }
  }
  return max_found;
}

double Polynomial::min(double min, double max){
  double min_found=getVal(min);
  if(getVal(max)<min_found)
    min_found=getVal(max);
  this->derivative().getRoots(min,max);
  std::set<double>::iterator it;
  for(it=derivative().roots.begin();it!=derivative().roots.end();++it){
    if(min_found>getVal(*it)){
      min_found=getVal(*it);
    }
  }
  return min_found;
}

static double power(double val, int pow)
{
  if(pow==-1){
    //std::cout << "bad stuff" << std::endl;
    return 1;
  }else if(pow==0){
    //std::cout << "zero power, returning 1" << std::endl;
    return 1;
  }else if(pow&1){
    //std::cout << pow << " is odd, squaring " << val << " raising to " << pow/2 << std::endl;
    return val*power(val*val,pow/2);
  }else{
    //std::cout << pow << " is even, squaring " << val << " raising to " << pow/2 << std::endl;
    return power(val*val,pow/2);
  }
}

static double aveOrsame(double x, double y, double xp, double yp)
{
  if(y<0 && yp>0)
      return (x+xp)/2;
  else if(y>0 && yp<0)
      return (x+xp)/2;
  return x;
}
