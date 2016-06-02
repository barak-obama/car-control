function [ str, canContinue ] = updatereality( str, car, a, wheel_angle, dt, max_wheel_angle, varargin  )
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
        

        plot(b(1), b(2), 'ob');
        hold on;
        
        theta = car.v * dt / r;
        new_end = rotateBy(back, theta, b);
        
        m1 = -(new_end(1) - b(1))/(new_end(2) - b(2));
        m2 = -(back(1) - b(1))/(back(2) - b(2));
        angle = atan(abs((m1-m2)/(1-m1*m2)));
        car.angle = car.angle - sign(r) * angle;
        
%         p_angle = car.angle;
%         if b(2) ~= new_end(2)
%         	car.angle = roundArg(pi / 2 - atan((new_end(1) - b(1)) / (b(2) - new_end(2))));
%             if abs(p_angle - car.angle) > abs(p_angle - pi - car.angle)
%                 car.angle = pi + car.angle;
%         	elseif abs(p_angle - car.angle) > abs(p_angle + pi - car.angle)
%             	car.angle = car.angle - pi;
%             end
%         else
%             display('inside');
%             if r > 0
%                 if b(1)>new_end(1)
%                     car.angle = 0;
%                 else
%                     car.angle = pi;
%                 end
%             else
%                 if b(1)<new_end(1)
%                     car.angle = 0;
%                 else
%                     car.angle = pi;
%                 end
%             end
%         end
        
        

        car.x = (car.length / 2) * cos(pi/2 - car.angle) + new_end(1);
        car.y = (car.length / 2) * sin(pi/2 - car.angle) + new_end(2);
    else
        car.x = car.x + car.v * cos(pi/2 - car.angle);
        car.y = car.y + car.v * sin(pi/2 - car.angle);
    end
    [~, car.sensorData, car.points] = SensorData(car, str);
    str.cars{car.id} = car;
    canContinue = 1-hascrashed(str,car);
    if canContinue
        min = (sum(max(str.map).^2).^0.5)/(20*sum([car.length, car.width].^2).^0.5);
        canContinue = 1-(abs(car.fx-car.x)<min && abs(car.fy-car.y)<min);
    end
end 