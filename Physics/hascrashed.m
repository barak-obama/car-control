function [ b ] = hascrashed( str, car )
polyCar = polygonFromCar(car,0);
if ~floor(mean(inpolygon(polyCar(:,1), polyCar(:,2), str.map(:,1), str.map(:,2))))
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