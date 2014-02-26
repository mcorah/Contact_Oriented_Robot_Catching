# Contact-Oriented Catching
A project focused on robotic catching of irregular and unwieldy objects on a plane

## Setup:
This project is still very much alpha, so requirements are hardly static.
For the the most part nothing needs to be built except for experimental components.
Primarily, you will need to download the rpi-matlab-simulator to the source folder.

After
## Dependencies:

* rpi-matlab-simulator
```
svn checkout http://rpi-matlab-simulator.googlecode.com/svn/simulator/ rpi-matlab-simulator-read-only
```
for now install install the simulator into the project directory

* OpenMPI
None of the functionality currently uses MPI, but it will likely be added in the future

In order to run any of the mpi functionality, a custom build of OpenMPI (Matlab will get mad if you use MPICH) is likely needed.
Matlab has a thing against dynamic libraries, so some specific compiler options will be required:
```
#!/bin/bash
./configure \
--prefix=$PWD/../install \
--with-threads=posix \
--enable-mpi-thread-multiple \
--without-memory-manager \
--disable-dlopen \
--enable-opal-multi-threads
```
note:
```
--disable-dlopen
```
appears to be what allows OpenMPI to cooperate with Matlab
