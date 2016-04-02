function [ str ] = GenerateCarControlCar( carLength, carWidth, cars, map )
a = sqrt((carLength/2)^2+(carWidth/2)^2);
mapMaxX = max(map(:,1)) - 2*a;
mapMinX = min(map(:,1)) + a;
mapMaxY = max(map(:,2)) - 2*a;
mapMinY = min(map(:,2)) + a;
x = rand*mapMaxX+mapMinX;
y = rand*mapMaxY+mapMinY;
while ~inMapNotInCars(map, cars, x, y)
    x = rand*mapMaxX+mapMinX;
    y = rand*mapMaxY+mapMinY;
end
str  = struct('x',x,'y',y,'length',carLength,'width',carWidth,'angle',rand*2*pi);
cars{1,end} = str;
x = rand*mapMaxX+mapMinX;
y = rand*mapMaxY+mapMinY;
while ~inMapNotInCars(map, cars, x, y)
    x = rand*mapMaxX+mapMinX;
    y = rand*mapMaxY+mapMinY;
end
str.fx = x;
str.fy = y;
end