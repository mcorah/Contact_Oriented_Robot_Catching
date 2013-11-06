function [R]=kth2R(k,theta)
  k=k/norm(k);
  R=eye(3)+sin(theta)*matcross(k)+(1-cos(theta))*matcross(k)^2;
end
