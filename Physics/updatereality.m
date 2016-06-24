function [ str, canContinue, crash] = updatereality( str, car, a, wheel_angle, dt, max_wheel_angle, varargin  )
    %display([a,wheel_angle]);
    car.a = a;
    car.v = a * dt + car.v;
    wheel_angle = wheel_angle * max_wheel_angle;

    if wheel_angle ~= 0
        r = car.length / tan(wheel_angle);
        back = [car.x; car.y] - (car.length / 2 )* [cos(pi / 2 - car.angle); sin(pi/2 - car.angle)];
        front = [car.x; car.y] + (car.length / 2 )* [cos(pi / 2 - car.angle); sin(pi/2 - car.angle)];
        b = front - back;
        b = b / norm(b);
        if r < 0
            b = back + abs(r) * [0 -1; 1 0] * b;
        else
            b = back + abs(r) * [0 1; -1 0] * b;
        end
        

%         plot(b(1), b(2), 'ob');
        hold on;
        
        theta = (car.v / r) * dt;
        new_end = rotateBy(back, theta, b);
        
        angle = atan((new_end(2) - b(2))/(new_end(1) - b(1)));
        if r > 0
             if b(1) < new_end(1)
                 angle = angle + pi;
             end
        else
             if new_end(1) < b(1)
             	angle = angle + pi;
             end
        end
        angle = angle + pi/2;
        angle = roundArg(angle);
        car.angle = pi/2 - angle;
        
        
        car.x = (car.length / 2) * cos(pi/2 - car.angle) + new_end(1);
        car.y = (car.length / 2) * sin(pi/2 - car.angle) + new_end(2);
    else
        car.x = car.x + car.v * dt * cos(pi/2 - car.angle);
        car.y = car.y + car.v * dt * sin(pi/2 - car.angle);
    end
    [~, car.sensorData, car.points] = SensorData(car, str);
    str.cars{car.id} = car;
    canContinue = 1-hascrashed(str,car);
    crash = hascrashed(str,car);
    if canContinue
        min = (sum(max(str.map).^2).^0.5)/(20*sum([car.length, car.width].^2).^0.5);
        canContinue = 1-(abs(car.fx-car.x)<min && abs(car.fy-car.y)<min);
    end
end 