function [ str ] = GenerateCarControlObstacle( obstacles, map, cars )
mapMaxX = max(map(:,1));
mapMinX = min(map(:,1));
mapMaxY = max(map(:,2));
mapMinY = min(map(:,2));
maxP = (mapMaxX-mapMinX)*(mapMaxY-mapMinY)/(20*length(obstacles)^2);
maxP = max([1,round(maxP)]);
maxD = sqrt((mapMaxX-mapMinX)*(mapMaxY-mapMinY))/sqrt(2*length(obstacles));
str.x = zeros(randi(maxP,1)+3,1);
str.y = zeros(size(str.x));
x = rand*mapMaxX+mapMinX;
y = rand*mapMaxY+mapMinY;
while ~inMapNotInCars(map,cars,x,y) || inObstacle(obstacles, x, y)
    x = rand*mapMaxX+mapMinX;
    y = rand*mapMaxY+mapMinY;
end
str.x(1) = x;
str.y(1) = y;
str.x(end) = x;
str.y(end) = y;
for i=2:length(str.x)-1
    x = rand*2*maxD-maxD;
    md = sqrt(maxD^2-x^2);
    y = str.y(i-1)+rand*2*md-md;
    x = str.x(i-1)+x;
    s1 = [[x,str.x(i-1)];[y,str.y(i-1)]];
    s2 = [[x,str.x(1)];[y,str.y(1)]];
    cp = [[str.x(1:i-1)',str.x(end)];[str.y(1:i-1)',str.y(end)]];
    while ~inMapNotInCars(map,cars,x,y) || inObstacle(obstacles, x, y) || ...
          crossesCarsObstacles(cars,obstacles,s1) || ...
          crossesCarsObstacles(cars,obstacles,s2) || ...
          ~isempty(seg2poly(s1,cp)) || ~isempty(seg2poly(s2,cp))
        x = rand*2*maxD-maxD;
        md = sqrt(maxD^2-x^2);
        y = str.y(i-1)+rand*2*md-md;
        x = str.x(i-1)+x;
        s1 = [[x,str.x(i-1)];[y,str.y(i-1)]];
        s2 = [[x,str.x(1)];[y,str.y(1)]];
    end
    str.x(i) = x;
    str.y(i) = y;
end
if envelops(cars,str)
   str = GenerateCarControlObstacle(obstacles,map,cars); 
end

str.matrix = [str.x, str.y];
end