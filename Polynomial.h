//polynomial function class based on coefficients and supporting math
//Micah Corah
//
#ifndef POLYNOMIAL_H
#define POLYNOMIAL_H

#define DEFAULT_THRESHOLD 0.0001
#define BIG 1e20
#define NEWTON_MAX 200
#define ABS(x) (x<0?-(x):(x))

#include <vector>
#include <set>
#include <iostream>

class Polynomial{
public:
  Polynomial();
  Polynomial(const Polynomial& p);
  Polynomial(const double* data, int n, double threshold=DEFAULT_THRESHOLD);
  ~Polynomial();
  friend std::ostream& operator<<(std::ostream& out,Polynomial& poly);
  double operator()(double num) const;
  double& operator[](int num);
  Polynomial& operator=(const Polynomial& p);
  double getVal(double num) const;
  Polynomial& derivative(int n=1);
  Polynomial& integral(int n=1);
  int order();
  void addDim(double val=0) { the_polynomial.push_back(val); }
  void setThreshold(double _threshold) { threshold=_threshold; };
  double getThreshold() { return threshold; };
  //have to deal with the issue that calls may have different bounds
  const std::set<double>& getRoots(double min, double max);
  const std::set<double>& getRoots(double min, double max, double guess);
  double max(double min, double max);
  double min(double min, double max);
private:
    std::vector<double> the_polynomial;
    std::set<double> roots;
    bool roots_found;
    Polynomial* the_derivative;
    Polynomial* the_integral;
    double threshold;
};

#endif
