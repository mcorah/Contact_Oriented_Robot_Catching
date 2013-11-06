theta=pi/2;
k_0=[3/5;0;4/5];
R0B=eye(3)+sin(theta)*matcross(k_0)+(1-cos(theta))*(matcross(k_0))^2
