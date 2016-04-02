function [ d ] = getDistance( angle, car, obstacles, map, cars )
    collisions = [];
    angle = pi - (angle + car.angleNorth);
    car_pos = [car.locationX, car.locationY];
    for i=1:length(obstacles)
        [d, isCollided] = collide(obstacles{i}, car_pos, angle);
        if isCollided
           collisions(end + 1) = d;
        end 
    end
    
    for i=1:length(cars)
        [d, isCollided] = collide(cars{i}, car_pos, angle);
        if isCollided
           collisions(end + 1) = d;
        end 
    end
    
     [d, isCollided] = collide(map, car_pos, angle);
     if isCollided
        collisions(end + 1) = d;
     end
     
     d = min(collisions);
end


function [d  , isCollided] = collide(obstacle, car_pos, angle)
    m = tan(angle);
    n = car_pos(2) - m * car_pos(1);
    distances  = [];
    isCollided = 0;
    for i=1:length(obstacle)
        j = i + 1;
        if i == length(obstacle)
            j = 1;
        end
        pos1 = obstacle{i};
        pos2 = obstacle{j};
        a = (pos1(1) - pos2(1)) / (pos1(2) - pos2(2));
        b = pos1(2) - a * pos1(1);
        
        x = (n - b) / (a-m);


        x1 = min(pos1(1), pos2(1));
        x2 = max(pos1(1), pos2(1));
        if (x1 < x) & (x < x2)
            isCollided = 1;
            y = m * x + n;
            distances(end + 1) = sqrt((x-car_pos(1))^2 + (y - car_pos(2))^2);
        end
        d = min(distance);
    end
end