xf=10;xo=0;vo=0;vf=0;
%xf=1;xo=0;vo=2;vf=2;
vmax=2;amax=4;dmax=1;
%vmax=5;amax=4;dmax=1;
pa1=.20;pa2=.30;
pb1=.35;pb2=.15;

t=0;
[x,v,a,ta,tb,tf]=scurvegen(xo,xf,vo,vf,vmax,amax,dmax,...
    pa1,pa2,pb1,pb2,t);
disp(['tf = ',num2str(tf)]);
N=100;
t=(0:tf/N:tf);

for i=1:length(t)
  [x(i),v(i),a(i),ta,tb,tf]=scurvegen(xo,xf,vo,vf,vmax,amax,dmax,...
      pa1,pa2,pb1,pb2,t(i));  
end
figure(4);plot(t,a);title('a');
figure(5);plot(t,v);title('v');
figure(6);plot(t,x);title('x');


