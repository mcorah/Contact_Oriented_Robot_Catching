function [R]=qv2R(qv)
  q0=sqrt(1-(qv'*qv));
  R=q2R([q0;qv]);
end
