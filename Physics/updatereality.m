function [ str, canContinue ] = updatereality( str, car, a, wheel_angle, dt, max_wheel_angle  )
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

        theta = -car.v * dt / r;

        new_end = rotateBy(back, theta, b);

        car.angle = 0;
        if b(1) ~= new_end(1)
            car.angle = pi / 2 - atan((b(2) - new_end(2)) / (b(1) - new_end(1)));
        end

        car.x = (car.length / 2) * cos(pi/2 - car.angle) + new_end(1);
        car.y = (car.length / 2) * sin(pi/2 - car.angle) + new_end(2); 
    else
        car.x = car.x + car.v * cos(pi/2 - car.angle);
        car.y = car.y + car.v * sin(pi/2 - car.angle);
    end

    [~, car.sensorData, car.points] = SensorData(car, str);
    str.cars{car.id} = car;
    canContinue = 1-hascrashed(str,car);
end 