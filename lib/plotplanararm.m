%
% name: plotplanararm
%
% input: 
%   q = joint angle vector (Nx1 array)
%   P = constant link length vectors as a matrix([p01 p12 p23 pNT])
%          2xN+1 matrix
%   width = linewidth (default is 1, set to 2 for thick line)
%   c = color code of the plot (e.g., 'k' for black, 'b' for blue, etc.)
%
% example usage:
%   q = [pi/2;pi/4;pi/3];p01=[0;0];p12=[1;1];p23=[1;0];p3T=[0;1];
%   P = [p01 p12 p23 p3T];
%   figure(1);
%   P0=plotplanararm(q,P,2,'r')
%
function P0=plotplanararm(q,P,width,c)

n=length(q);
k=size(P,1);
P0=zeros(k,n+1);
P0(:,1)=P(:,1);
R=eye(k,k);
for i=1:n
  R=R*rotplane(q(i));
  P0(:,i+1)=P0(:,i)+R*P(:,i+1);
end   
  
h=plot([0 P0(1,:)],[0 P0(2,:)],c,[0 P0(1,:)],[0 P0(2,:)],'o',P0(1,n+1),P0(2,n+1),'r*');
set(h,'linewidth',width)
