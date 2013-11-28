function [k,theta]=R2kth(R)
  theta=acos((R(1,1)+R(2,2)+R(3,3)-1)/2);
  k=vee((R-R')/(2*sin(theta)));
  k=k/norm(k);
end
