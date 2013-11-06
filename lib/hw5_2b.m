clear all
close all
syms theta1 theta2 theta3 real
y=[0;1;0];
x=[1;0;0];
R01=rot(y,theta1);
disp('z_0 can be represented in by by multiplying by R01 transpose')
z=R01'*[0;0;1];
simplify(z)
R02=rot(z,theta2)*R01;
R0B=rot(x,theta3)*R02;
disp('evaluation of rotations:')
simplify(R0B)
