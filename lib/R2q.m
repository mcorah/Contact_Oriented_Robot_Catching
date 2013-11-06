function [q]=R2q(R)
  [k,theta]=R2kth(R);
  q0=cos(theta/2);
  qv=sin(theta/2)*k/norm(sin(theta/2)*k)*sqrt((1-cos(theta/2)));
  q=[q0;qv]/norm([q0;qv]);
end
