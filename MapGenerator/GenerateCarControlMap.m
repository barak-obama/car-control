function [ str ] = GenerateCarControlMap( sizeX, sizeY, length, width, numObstacles, numCars )
%function [ str ] = GenerateCarControlMap( sizeX, sizeY, length, width, numObstacles, numCars )
%[ str ] - returns a structure containing the cars, obstacles and the map
%polygon.
%sizeX - the size of the map on the x axis
%sizeY - the size of the map on the y axis
%length - the length of the cars
%width - the width of the cars
%numObstacles - the number of obstacles to create
%numCars - the number of cars to create
obstacles = cell(1,numObstacles);
cars = cell(1,numCars);
map = [[0,0];[0,sizeY];[sizeX,sizeY];[sizeX,0];[0,0]];
for i=1:max(size(cars))
    cars{1,i} = GenerateCarControlCar(length,width,cars,map);
end
for i=1:max(size(obstacles))
    obstacles{1,i} = GenerateCarControlObstacle(obstacles,map,cars);
end
str.map = map;
str.cars = cars;
str.obstacles = obstacles;
for i=1:max(size(str.cars))
   [~, str.cars{i}.sensorData, str.cars{i}.points] = SensorData(str.cars{i}, str);
end
end