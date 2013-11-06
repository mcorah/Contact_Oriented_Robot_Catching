function [R]=beta2R(beta)
  theta=norm(beta);
  k=beta/theta;
  R=kth2R(k,theta);
end
