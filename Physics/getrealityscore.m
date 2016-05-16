function [ score ] = getrealityscore( str, car )
score = 1000 / (sqrt((car.x-car.fx)^2+(car.y-car.fy)^2)+4);
if hascrashed(str, car)
   score = score/2;
end
end

