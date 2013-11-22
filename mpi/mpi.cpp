#include <mpi.h>
#include <iostream>
#include <dlfcn.h>
#include "mex.h"
#include "string.h"

void mexFunction(int nlhs, mxArray* plhs[], int nrhs, const mxArray *prhs[])
{
  MPI_Init(NULL,NULL);
  int rank;
  int size;
  MPI_Comm_rank(MPI_COMM_WORLD,&rank);
  MPI_Comm_size(MPI_COMM_WORLD,&size);
  char buf[256];
  std::cout << "Reporting! Rank: " << rank << " Size: " << size << std::endl;

  
  MPI_Request request;
  MPI_Status status;
  if(!rank){
    strcpy(buf,"cd ..;setupCatching");
    for(int i=1;i<size;++i){
      MPI_Isend(buf,256,MPI_BYTE,i,0,MPI_COMM_WORLD,&request);
    }
  }else{
    MPI_Recv(buf,256,MPI_BYTE,0,0,MPI_COMM_WORLD,&status);
  }
  std::cout << "Calling Matlab" << std::endl;
  mexEvalString(buf);

  MPI_Finalize();
  return;
}
