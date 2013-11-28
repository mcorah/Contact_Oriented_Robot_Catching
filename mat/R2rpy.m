function [r p y]=R2rpy(R)
  p=asin(R(3,2));
  if R(1,2)==0 && R(2,2)==0
    disp('error infinite solutions')
    return;
  end
  y=atan2(-R(1,2),R(2,2));
  r=acos(R(3,3)/cos(p));
end
