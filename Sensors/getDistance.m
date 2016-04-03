function [ d ] = getDistance( car,angle, map, obstacles, cars, back )
    collisions = [];
<<<<<<< HEAD:getDistance.m
    angle = pi/2 - (angle + car.angle);
    car_pos = ([cos(car.angle), sin(car.angle); -sin(car.angle), cos(car.angle)] * [car.length; 0] + [car.x; car.y])';
=======
    angle = 2*pi - (angle + car.angle);
    car_pos = [car.x, car.y];
>>>>>>> 06f472c5b6da8363ffc7e767f1a06c36f6e5a668:Sensors/getDistance.m
    for i=1:length(obstacles)
        [d, isCollided] = collide(obstacles{1,i}, car_pos, angle);
        if isCollided
           collisions(end + 1) = d;
        end 
    end
    
    for i=1:length(cars)
        [d, isCollided] = collide(cars{1,i}, car_pos, angle);
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
        pos1 = obstacle(:,i);
        pos2 = obstacle(:,j);
        a = (pos1(1) - pos2(1)) / (pos1(2) - pos2(2));
        b = pos1(2) - a * pos1(1);
        
        x = (n - b) / (a-m);


        x1 = min(pos1(1), pos2(1));
        x2 = max(pos1(1), pos2(1));
        if (x1 < x) && (x < x2)
            isCollided = 1;
            y = m * x + n;
            distances(end + 1) = sqrt((x-car_pos(1))^2 + (y - car_pos(2))^2);
        end
        d = min(distance);
    end
end