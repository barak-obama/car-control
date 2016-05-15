function [ sensorDataD, sensorDataP, points, angles] = SensorData(car, str)
    angles = [0 pi/4 pi/2;...
            pi  3*pi/4 pi/2;...
            pi 5*pi/4 3*pi/2;...
            2*pi 7*pi/4 3*pi/2];
    sensorDataD = zeros(size(angles, 2),4);
    sensorDataP = zeros([size(sensorDataD),2]);
    points = [cos(car.angle) sin(car.angle); -sin(car.angle) cos(car.angle)]...
            * [car.width / 2 car.width / 2 -car.width / 2 -car.width / 2;...
            car.length/2 -car.length/2 -car.length/2 car.length/2];
            
    points = points + (diag([car.x, car.y]) * ones(size(points)));
    for i=1:4
        current_angles = angles(i, :);
        point = points(:,i);
        for j=1:length(current_angles)
            [d, p] = getDistance(current_angles(j),car, str, point );
            sensorDataD(j, i) = d;
            sensorDataP(j, i, :) = p;
        end
        
    end
end

