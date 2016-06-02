function [ reality ] = getreality( car )
reality = [car.v, car.a, car.angle, car.fx-car.x, car.fy-car.y];
reality(end+1) = reality(4).^3;
reality(end+1) = reality(5).^3;
reality(end+1) = reality(4).^5;
reality(end+1) = reality(5).^5;
reality(end+1) = reality(4).^7;
reality(end+1) = reality(5).^7;
for i = 1:size(car.sensorData, 2)
   for j = 1:size(car.sensorData, 1)
       reality(end+1) = sqrt(abs(car.sensorData(j, i, 1) - ...
           car.points(1, i))^2+abs(car.sensorData(j, i, 2) - ...
           car.points(2, i))^2);
   end
end
end

