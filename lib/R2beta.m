function [beta]=R2beta(R)
  [k,theta]=R2kth(R);
  beta=theta*k/norm(k);
end
