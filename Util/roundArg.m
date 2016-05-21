function [ r ] = roundArg( a )
%ROUNDARG Summary of this function goes here
%   Detailed explanation goes here
    if a > 0
        r = a - floor(a / (2*pi)) * (2*pi);
    elseif a < 0
        r = a + (-ceil(a / (2*pi)) + 1) * (2*pi);
    else
        r = 0;
    end
    
    if r > pi
        r = r - 2 * pi;
    end

end

