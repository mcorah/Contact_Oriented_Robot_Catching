clc;
hold off;

p01=[0;0];p12=[1;0];p23=[1;0];p34=[1;0];p45=[1;0];p5T=[1;0];
P=[p01 p12 p23 p34 p45 p5T];

kcross=[0 -1;1 0];

q=rand(5,1)*2*pi;

figure(5);
plotplanararm(q,P,2,'k');
hold on;

R01=rotplane(q(1));
R12=rotplane(q(2));
R23=rotplane(q(3));
R34=rotplane(q(4));
R45=rotplane(q(5));
       
p5T_0=R01*R12*R23*R34*R45*p5T;
p4T_0=R01*R12*R23*R34*p45+p5T_0;
p3T_0=R01*R12*R23*p34+p4T_0;
p2T_0=R01*R12*p23+p3T_0;
p1T_0=R01*p12+p2T_0;
    
p0T=R01*(p12+R12*(p23+R23*(p34+R34*(p45+R45*p5T))));
q0T=sum(qq);
    
xT=[q0T;p0T];
    
JT=[[1 1 1 1 1];[kcross*p1T_0 kcross*p2T_0 kcross*p3T_0 kcross*p4T_0 kcross*p5T_0]];
    
Jtilde=null(JT);

dq1=(-1:.1:1);
dq2=(-1:.1:1);

for i=1:length(dq1)
    
    qq=q+Jtilde*[dq1(i);dq2(i)];
    
    plotplanararm(qq,P,1,'c');

end
