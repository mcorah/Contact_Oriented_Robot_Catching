function [g]=R2g(R)
  [k,theta]=R2kth(R);
  g=k*tan(theta/2);
end
