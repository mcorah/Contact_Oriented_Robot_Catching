%
% planar rotation matrix
%
% R=rot(theta)
%
% theta in radians 
% 
function R=rotplane(theta)

R=[cos(theta) -sin(theta);sin(theta) cos(theta)];
