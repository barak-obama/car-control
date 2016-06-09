function [ c ] = crossesCarsObstacles( cars, obstacles, s )
c = 0;
for i=1:length(cars)
    c = ~isempty(seg2poly(s,polygonFromCar(cars{1,i},1)'));
    if c
        return;
    end
end
for i=1:length(obstacles)
    if ~isempty(obstacles{1,i})
        c = ~isempty(seg2poly(s,[obstacles{1,i}.x';obstacles{1,i}.y']));
        if c
            return;
        end
    end
end
end