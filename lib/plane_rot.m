function [rot]=plane_rot(theta)
    rot=[cos(theta) -sin(theta);sin(theta) cos(theta)];
end