all:test planTrajectory.mexa64

test:test.cpp doRegression.cpp Polynomial.cpp
	g++ -g  doRegression.cpp Polynomial.cpp test.cpp -o test
planTrajectory.mexa64:doRegression.cpp Polynomial.cpp planTrajectory.cpp
	mex -g planTrajectory.cpp doRegression.cpp Polynomial.cpp

.PHONY:all
