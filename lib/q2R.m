function [R]=q2R(q)
  theta=2*acos(q(1));
  k=q(2:4)/sin(theta/2);
  R=kth2R(k,theta);
end
