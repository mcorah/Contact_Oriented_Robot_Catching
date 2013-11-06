function [R]=g2R(g)
  theta=2*atan(norm(g));
  k=g/norm(g);
  R=kth2R(k,theta);
end
