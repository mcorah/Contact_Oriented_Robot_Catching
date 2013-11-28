all:bin/test bin/planTrajectory.mexa64

bin/test:src/test.cc src/doRegression.cc src/Polynomial.cc
	g++ -g  -Iinclude src/doRegression.cc src/Polynomial.cc src/test.cc -o bin/test
bin/planTrajectory.mexa64:src/doRegression.cc src/Polynomial.cc src/planTrajectory.cc
	mex -outdir bin -DGRADIENT -g -Iinclude src/planTrajectory.cc src/doRegression.cc src/Polynomial.cc

.PHONY:all
