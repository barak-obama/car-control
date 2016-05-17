function [ b ] = hascrashed( str, car )
if ~floor(mean(inpolygon(car.x, car.y, str.map(:,1), str.map(:,2))))
    b = 1;
    return;
end
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