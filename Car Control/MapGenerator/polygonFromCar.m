function [ xy ] = polygonFromCar( car, doubleR )
pos = [car.x; car.y];
r = sqrt((car.length/2)^2+(car.width/2)^2);
if doubleR
   r = r*2; 
end
%R = [0;r];
alpha = asin(car.width/(2*r));
angle = -car.angle;

xy = [pos+r.*[cos(angle - alpha);sin(angle - alpha)],pos+r.*[cos(angle+alpha);sin(angle+alpha)],...
    pos+r.*[cos(pi + angle - alpha);sin(pi + angle - alpha)],...
    pos+r.*[cos(pi + angle+alpha);sin(pi + angle+alpha)],pos+r.*[cos(angle - alpha);sin(angle - alpha)]]';

%M1 = [[cos(angle-alpha) sin(angle-alpha)]; [-sin(car.angle) cos(car.angle)]];
%M2 = [[cos(car.angle + alpha) sin(car.angle + alpha)]; [-sin(car.angle + alpha) cos(car.angle + alpha)]];
%M3 = [[cos(car.angle + pi) sin(car.angle + pi)]; [-sin(car.angle + pi) cos(car.angle + pi)]];
%M4 = [[cos(car.angle + pi + alpha) sin(car.angle + pi + alpha)]; [-sin(car.angle + pi + alpha) cos(car.angle + pi + alpha)]];
%xy = [M1*R M2*R M3*R M4*R M1*R];
%xy = (xy+diag(pos)*ones(size(xy)))';
end