clc
clear all
close all
g=-9.8;
m=2; %mass of object kg
h=1/20; %time-step
Jxx=1;
Jyy=1;
Jzz=1;
Jxy=0;
Jxz=0;
Jyz=0;
J=[Jxx Jxy Jxz;
   Jxy Jyy Jyz;
   Jxz Jyz Jzz];
nf=31;
cone_divs=[0:2*pi/(nf-1):2*pi];
Gf=[cos(cone_divs);sin(cone_divs);zeros(4,length(cone_divs))];
U=6;
theta=pi/15;
normal=[0;sin(theta);cos(theta)];
FX=[g*m*normal;0;0;0]; %gravity
Gn=[0;0;-FX(3);0;0;0];
PSI=0;
vx=2.5;
vy=-0.6;
vz=0;
rx=0;
ry=0;
rz=4;
%rz=.05;
E=ones(nf,1);
%Gb=I
NU=[vx;vy;vz;rx;ry;rz]; %velocity changes!
big=10^20;
%l=[zeros(6,1);-big*ones(size(A,1)-6,1)];
%u=[zeros(6,1);big*ones(size(A,1)-6,1)];
Pn=[1.5 3 0 0 0 0]';
%Pn=[1.5 1.5 0 0 0 0]';

%main loop
it=40;
start=clock;
for i=1:it-1
  RB=rpy2R(NU(5),NU(4),NU(6));

  M=[diag([m m m]) zeros(3);
    zeros(3)      RB*J*RB'];

  A=[-M           Gn      Gf      zeros(6,1);
    Gn'          zeros(1,2+nf);
    Gf'          zeros(nf,1+nf)  E;
    zeros(1,6)   U       -E'     0];

  b=[M*NU(:,end)+FX*h;
     PSI/h;
     zeros(nf+1,1)];

  l=[-big*ones(6*1,1);zeros(size(A,1)-6*1,1)];
  u=big*ones(size(A,1),1);
  z0=zeros(size(A,1),1);
  [z,mu]=pathlcp(A,b,l,u,z0);
  %disp(z(1:6));
  NU=[NU z(1:6)];
  Pn=[Pn Pn(:,end)+z(1:6)*h];
end
elapsed=etime(clock,start);
fprintf('Time elapsed: %d Seconds per Timestep: %d Sim to real time: %d\n',elapsed,elapsed/it,h*it/elapsed)
plot(Pn(1,:),Pn(2,:),'x',Pn(1,:)+0.03*cos(Pn(6,:)),Pn(2,:)+0.03*sin(Pn(6,:)),'.');
axis([0 3 0 3]);
vel=(NU.*NU);
vel=(vel(1,:)+vel(2,:)).^(1/2);
figure
plot(1:it,vel,'.');
figure
plot(1:it,NU(6,:),'.');
