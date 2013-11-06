%
% kincontrol3link.m
% script for the kinematic control of a 3 link planar arm
%
clear all;close all;
% link lengths
l1=2;
l2=2;
l3=1;
P=[[0;0],[l1;0],[l2;0],[l3;0]];
% location of the obstacle ball
c=[3;3];
% true radius and the assumed radius (with buffer)
rtrue=1.0;r=1.5;
%%rtrue=2.5;r=2.8;
%%rtrue=2.5;r=3.5;

% feedback gains
kp1=1;
kp2=2;
kp3=2;

% initial and final task coordinate 
x0=[0;0;0];
xd=[pi/2;0;5];

Kp=diag([kp1;kp2;kp3]); % gain
gamma=25; % collision avoidane

deltat=.01;
q0=[0;0;0];

sim('kincontrol');

% joint angle trajectory
q=q';

clear M
figure(10);
% plot the motion in the reference frame
theta=(0:2*pi/40:2*pi);
plot(c(1)+rtrue*cos(theta),c(2)+rtrue*sin(theta),'--')
hold on
title('motion trajectory of tip of arm');
xlabel('x');ylabel('y');
axis([-5,5,-5,5]);axis('square');grid

j=1;
plotplanararm(q0,P,2,'k');
for i=1:10:length(t)
  plotplanararm(q(:,i),P,1,'c');
  M(j)=getframe;
end
plotplanararm(q(:,length(t)),P,2,'r');
movie(M);

% comparison between the actual and desired task coordinate
figure(1);
plot(t,xT(:,1),t,xd(1)*ones(size(t)),'x');
title('q_{0T}');xlabel('time (sec)');ylabel('task angle (rad)');
figure(2);
plot(t,xT(:,2),t,xd(2)*ones(size(t)),'x');
title('x_{0T}');xlabel('time (sec)');ylabel('task x-coordinate');
figure(3);
plot(t,xT(:,3),t,xd(3)*ones(size(t)),'x')
title('y_{0T}');xlabel('time (sec)');ylabel('task y-coordinate');
