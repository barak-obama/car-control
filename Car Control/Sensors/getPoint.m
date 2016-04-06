function [ p ] = getPoint( orig, angle, length )
p = orig+length.*[cos(angle);sin(angle)];
end