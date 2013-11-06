function [ pose ] = Pose( x, y, theta )
%UNTITLED returns the homogeneous transformation matrix
%   Detailed explanation goes here
    pose=[cos(theta) -sin(theta) x;sin(theta) cos(theta) y; 0 0 1];
end

