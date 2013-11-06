%
% kincontrol3link.m
% script for the kinematic control of a 3 link planar arm
%
clear all;close all;
% link lengths
l1=2;
l2=2;
l3=1;
% location of the obstacle ball
c=[3;3];
% true radius and the assumed radius (with buffer)
rtrue=1.0;r=1.5;
%%rtrue=2.5;r=2.8;
%%rtrue=2.5;r=3.5;

% feedback gains
kp1=1;
kp2=1;
kp3=1;

% initial and final task coordinate 
x0=[0;0;0];
xd=[pi/2;0;5];

% solve for the arm kinematic equation
options=odeset;
Kp=diag([kp1;kp2;kp3]); % gain
%gamma=10; % collision avoidane
gamma=20; % collision avoidane
T=10; % simulation time
[t,x]=ode45('kincontrol3linkfunc',[0,T],x0,options,l1,l2,l3,c,r,xd,Kp,gamma);
% joint angle trajectory
x=x';
% task frame orientation (q0T)
th=sum(x);
% task frame location (p0T)
px=l1*cos(x(1,:))+l2*cos(x(1,:)+x(2,:))+l3*cos(x(1,:)+x(2,:)+x(3,:));
py=l1*sin(x(1,:))+l2*sin(x(1,:)+x(2,:))+l3*sin(x(1,:)+x(2,:)+x(3,:));
% joint 1 location
px1=l1*cos(x(1,:));
py1=l1*sin(x(1,:));
% joint 2 location
px2=l1*cos(x(1,:))+l2*cos(x(1,:)+x(2,:));
py2=l1*sin(x(1,:))+l2*sin(x(1,:)+x(2,:));
% comparison between the actual and desired task coordinate
figure(1);
plot(t,th,t,xd(1),'x');
title('q_{0T}');xlabel('time (sec)');ylabel('task angle (rad)');
figure(2);
plot(t,px,t,xd(2),'x');
title('x_{0T}');xlabel('time (sec)');ylabel('task x-coordinate');
figure(3);
plot(t,py,t,xd(3),'x')
title('y_{0T}');xlabel('time (sec)');ylabel('task y-coordinate');

% plot the motion in the reference frame
theta=(0:2*pi/40:2*pi);
figure(4);plot(px,py,c(1)+rtrue*cos(theta),c(2)+rtrue*sin(theta),'--')
title('motion trajectory of tip of arm');
xlabel('x');ylabel('y');
axis([-5,5,-5,5]);axis('square');grid

% make a movie
hold off
figure(5);plot(px,py,'o',c(1)+rtrue*cos(theta),c(2)+rtrue*sin(theta),'--')
axis([-2,5,-2,5]);axis('square');
hold on 
j=1;
N=length(t);
clear M;
for i=(1:N/50:N)
  ii=fix(i);
  plot([0 px1(ii) px2(ii) px(ii)],[0 py1(ii) py2(ii) py(ii)],'--');
  M(j)=getframe;
  j=j+1;
end
movie(M);
hold off
