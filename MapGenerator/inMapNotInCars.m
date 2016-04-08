function [ possible ] = inMapNotInCars( map, cars, x, y )
possible = inpolygon(x,y,map(:,1),map(:,2));
if possible
    for i=1:length(cars)
        if ~isempty(cars{1,i})
            xy = polygonFromCar(cars{1,i}, 1);
            possible = ~inpolygon(x,y,xy(:,1),xy(:,2));
            if i~=length(cars)
                possible = possible & ...
                (((x-cars{1,i}.fx)^2+(y-cars{1,i}.fy)^2)>...
                sqrt((cars{1,i}.length/2)^2+(cars{1,i}.width/2)^2));
            end
            if ~possible
               return;
            end
        end
    end
end
end