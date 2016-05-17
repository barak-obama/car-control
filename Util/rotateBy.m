function [ p ] = rotateBy( point, angle, varargin )

    fixed_point = [0,0];
    if ~isempty(varargin)
        fixed_point = varargin{1};
    end
    
    rotation_matrix = [cos(angle) sin(angle); -sin(angle) cos(angle)];
    p = (point - fixed_point) * rotation_matrix + fixed_point;
%ROTATE Summary of this function goes here
%   Detailed explanation goes here


end

