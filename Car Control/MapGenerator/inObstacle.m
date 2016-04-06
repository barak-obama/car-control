function [ in ] = inObstacle( obstacles, x, y )
in = 0;
for i=1:length(obstacles)
    if ~isempty(obstacles{1,i})
        if inpolygon(x,y,obstacles{1,i}.x, obstacles{1,i}.y)
            in = 1;
            return;
        end
    end
end
end