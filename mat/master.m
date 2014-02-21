%%%%%%%%%%%%%%%%%%%%%%%%%%
% Driver function for catching simulation
% Micah Corah
%%%%%%%%%%%%%%%%%%%%%%%%%%
close all
clear all

disp('Beginning simulation');
rng('shuffle','twister');
t=clock;
step=0.0016;
%Sampling space
block_dir=rand(1)*pi;
%block_dir=2.0548;
block_u=[0;0.5;0.09];
block_nu=[rot([0;0;1],block_dir)*[-6*rand(1);0;0];
          [0;0;12*pi*rand(1)-6*pi]];
%block_nu=[
         %0.6306;
         %-1.1997;
               %0;
               %0;
               %0;
          %9.7503
          %];

hand_control=[-0.1 -0.8 0.1 -0.8;zeros(6,4)];

[path]=runTest(block_u,block_nu,[-0.1 1.2 0.1 1.2],step);
close all;


%call to threaded regression function
%problems ordered x y theta
for i=1:2
  %trying resetting the hand control function
  %maybe this will deal with the problem of the local
  %minimum
  %hand_control=[0 -0.8];

  lower=[[-1;-20;-100] [-1;-20;-100]];
  upper=-lower;
  mask=[[1;1] [1;1]];
  %mask=[[0] [0]];

  t_reg=clock;
  %hand_control=planTrajectory(step, path(1:2,:)',lower,upper,mask,hand_control);
  hand_control=matlabTrajectory(step, path',lower,upper,hand_control);
  fprintf('Completed regression! Time: %d seconds\n',etime(clock,t_reg))
  disp('Controller:')
  s=polynomialToString(hand_control);
  disp(s);

  [path]=runTest(block_u,block_nu,hand_control,step);
  close all;
  fprintf('Completed test! Time: %d seconds\n',etime(clock,t))
end

figure();
x=[];
y=[];
for i=1:size(path,2)
  x=[x;evalPolynomial(hand_control(:,1),step*i)];
  y=[y;evalPolynomial(hand_control(:,2),step*i)];
end
time=[0:step:step*size(path,2)-1];
plot(time,path(1,:)','-g');
hold on;
plot(time',path(2,:)','-r');
plot(time',x,'*g');
plot(time',y,'*r');
hold off;

axis([0 time(end) -1 1]);
legend('goalx','goaly','handx','handy');
title('Position');

d=hand_control;
for i=1:size(lower)
  figure();
  x=[];
  y=[];
  for j=1:size(time,2)
    x=[x;evalPolynomial(d(:,1),time(j))];
    y=[y;evalPolynomial(d(:,2),time(j))];
  end
  
  lowerv=repmat(lower(i),size(time));
  upperv=repmat(upper(i),size(time));
  plot(time',lowerv','-b');
  hold on;
  plot(time',upperv,'-b');
  plot(time',x,'*g');
  plot(time',y,'*r');
  hold off;
  disp(['Control derivative' num2str(i-1)]);
  s=polynomialToString(d);
  disp(s);
  axis([0 time(end) lower(i) upper(i)]);
  legend('lower','upper','ndivx','ndivy');
  title(['Deriv Constraint: ' num2str(i-1)]);
  d=derivPoly(d);
end
input('done')
