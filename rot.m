function [r]=rot(k,theta)
  k=k/norm(k);
  r=eye(3)+sin(theta)*matcross(k)+(1-cos(theta))*matcross(k)^2;
end
