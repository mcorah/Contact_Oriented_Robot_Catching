clear all
close all
syms theta1 theta2 theta3 real
y=[0;1;0];
z=[0;0;1];
x=[1;0;0];
R01=rot(y,theta1);
R02=rot(z,theta2)*R01;
R0B=rot(x,theta3)*R02;

R0B*y;
disp('find theta2: R0B_1,2=')
disp(R0B(1,2))
disp('find theta3: R0B(3,2)/R0B(2,2)=')
disp(simplify(R0B(3,2)/R0B(2,2)))
disp('find theta1 given theta2: R0B(1,3)/cos(theta2)')
disp(R0B(1,3)/cos(theta2))

disp('consider the case where theta2=n*pi')
R0B_2=subs(R0B,[theta2],[pi/2])
disp('There are now only two constraints to be satisfied and R0B_21*R0B_23=')
disp(simplify(R0B_2(2,1)*R0B_2(2,3)))

