function [ score ] = getrealityscore( str, car )
score = hascrashed(str, car) + 1/sqrt((car.x-car.fx)^2+(car.y-car.fy)^2);
end

