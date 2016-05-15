function [ b ] = hascrashed( str, car )
addpath('../sensors');
cars = 1:max(size(str.cars));
cars(car.id) = [];
b = 0;
if ~isempty(cars)
    for c=str.cars{cars}
            if ~isempty(poly2poly(polygonFromCar(car,0),polygonFromCar(c,0)))
                b = 1;
                return;
            end
    end
end
for i=1:max(size(str.obstacles))
        if ~isempty(poly2poly(polygonFromCar(car,0)',str.obstacles{i}.matrix'))
            b = 1;
            return;
        end
end
end