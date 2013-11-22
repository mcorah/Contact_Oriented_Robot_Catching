#!/bin/bash -x
./install/bin/mpirun -np $1 -prefix $PWD xterm -e "matlab -nojvm -nosplash -nodesktop Dgdb -r \"disp('Hello World!');mpi\""
#./install/bin/mpirun -np $1 -prefix $PWD matlab -nojvm -nosplash -nodesktop -Dgdb -r "dbmex on; disp('Hello World!');mpi"
