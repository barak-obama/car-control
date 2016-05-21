function [ score ] = getrealityscore( str, car )
if hascrashed(str, car)
   score = 0;
   return;
end
score = 1000 / (sqrt((car.x-car.fx)^2+(car.y-car.fy)^2)+4);
end

