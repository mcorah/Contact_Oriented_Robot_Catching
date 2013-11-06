clear all
close all
syms theta1 theta2 theta3 real
y=[0;1;0];
z=[0;0;1];
x=[1;0;0];
R01=rot(y,theta1);
R02=rot(z,theta2)*R01;
R0B=rot(x,theta3)*R02;
simplify(R0B)
