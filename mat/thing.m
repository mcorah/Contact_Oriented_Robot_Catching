clc
clear all
close all
g=9.8;
m=2; %mass of object kg
h=1/60; %time-step
Jxx=1;
Jyy=1;
Jzz=1;
Jxy=0;
Jxz=0;
Jyz=0;
J=[Jxx Jxy Jxz;
   Jxy Jyy Jyz;
   Jxz Jyz Jzz];
M=[diag([m m m]) zeros(3);
   zeros(3)      J];
nf=7;
cone_divs=[0:2*pi/(nf-1):2*pi];
Gf=[cos(cone_divs);sin(cone_divs);zeros(4,length(cone_divs))];
U=0.1;
normal=[0;0;1];
Gn=[g*m*normal/norm(normal);0;0;0];
PSI=0;
vx=1;
vy=1;
vz=0;
rx=0;
ry=0;
rz=0;
%rz=.05;
E=ones(nf,1);
%Gb=I
A=[-M           Gn      Gf      zeros(6,1);
   Gn'          zeros(1,2+nf);
   Gf'          zeros(nf,1+nf)  E;
   zeros(1,6)   U       -E'     0];

FX=-Gn; %gravity
NU=[vx;vy;vz;rx;ry;rz]; %velocity changes!
b=[M*NU+FX*h;
   PSI/h;
   zeros(nf+1,1)];

big=10^20;
l=[-big*ones(6*2,1);zeros(size(A,1)-6*2,1)];
u=big*ones(size(A,1),1);
z0=zeros(size(A,1),1);
t=zeros(size(A,1),1);
mu=zeros(size(A,1),1);
Pn=[0 0 0 0 0 0]';
for i=1:100
  [z,mu]=pathlcp(A,b,l,u,z0);
  disp(z(1:6))
  NU=z(1:6)
b=[M*NU+FX*h;
   PSI/h;
   zeros(nf+1,1)];
  Pn=[Pn Pn(:,end)+z(1:6)*h]
end
