function [ xy ] = polygonFromCar( car, doubleR )
pos = [car.x; car.y];
r = sqrt((car.length/2)^2+(car.width/2)^2);
if doubleR
   r = r*2; 
end
R = [0;r];
alpha = acos((2 * (r^2) - car.width^2) / (2 * (r^2)));

M1 = [[cos(car.angle) sin(car.angle)]; [-sin(car.angle) cos(car.angle)]];
M2 = [[cos(car.angle + alpha) sin(car.angle + alpha)]; [-sin(car.angle + alpha) cos(car.angle + alpha)]];
M3 = [[cos(car.angle + pi) sin(car.angle + pi)]; [-sin(car.angle + pi) cos(car.angle + pi)]];
M4 = [[cos(car.angle + pi + alpha) sin(car.angle + pi + alpha)]; [-sin(car.angle + pi + alpha) cos(car.angle + pi + alpha)]];
xy = [M1*R M2*R M3*R M4*R M1*R];
xy = (xy+diag(pos)*ones(size(xy)))';
end