theta=pi/2;
k_0=[3/5;0;4/5];
R0B=eye(3)+sin(theta)*matcross(k_0)+(1-cos(theta))*(matcross(k_0))^2;
p_0=[1;-1;1];
p_B=R0B'*p_0

R0C=eye(3)+sin(pi/4)*matcross(k_0)+(1-cos(pi/4))*(matcross(k_0))^2
p_C=R0C*p_0
