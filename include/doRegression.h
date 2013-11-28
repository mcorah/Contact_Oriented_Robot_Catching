#ifndef doRegression_H
#define doRegression_H
#include <vector>
#include "Polynomial.h"
typedef std::vector<double> Vector;
Polynomial doRegression(const Vector& x, const Vector& y, const Vector& lower, const Vector& upper, const Vector& mask, Polynomial& guess);
Polynomial gradientDescent(const Vector& x, const Vector& y, const Vector& lower, const Vector& upper, const Vector& mask, Polynomial& guess);
Vector toVector(double* data, int n);
#endif
