function [ collision , point] = getDistance( angle, car, str, dot)
    collision = inf;
    angle = pi / 2 - (car.angle + angle);
    l = sqrt(2)*max(max(str.map)-min(str.map));
    for i=1:length(str.obstacles)
        [d, p] = collide(str.obstacles{i}.matrix, dot, angle, l);
        if d < collision
                collision = d;
                point = p;
        end
    end
    
    for i=1:length(str.cars)
        [d, p] = collide(polygonFromCar(str.cars{i}, 0), dot, angle, l);
        if car.id ~= str.cars{i}.id
            if d < collision
                    collision = d;
                    point = p;
            end
        end 
    end
    
    [d, p] = collide(str.map, dot, angle, l);
    if d < collision
            collision = d;
            point = p;
    end
end


function [distance, point] = collide(obstacle, dot, angle, max_distance)
    X = seg2poly([dot, dot + max_distance*[cos(angle);sin(angle)]], obstacle');
    D = sum(sqrt(X - diag(dot)*ones(size(X)).^2));
    [distance, k] = min(D);
    point = X(:, k);
end