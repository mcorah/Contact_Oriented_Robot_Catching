function [R]=rpy2R(r,p,y)
  R=rot([0;0;1],y)*rot([1;0;0],p)*rot([0;1;0],r);
end
