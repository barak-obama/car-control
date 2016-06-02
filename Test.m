str = GenerateCarControlMap(50,50,4.7,2.1,20,1);

str.obstacles = {};
car = str.cars{1};
car.x = 25;
car.y = 25;
car.fx = 0;
car.fy = 0;
car.angle = -pi/4;
car.v = 6;

[~, car.sensorData, car.points] = SensorData(car, str);
str.cars{1} = car;

displayCarControlMap(str, 0);

dt = 0.01;

canContinue = 1;

while canContinue
    [ str, canContinue ] = updatereality( str, str.cars{1}, 0, 1, dt, -pi/5  );
    hold off
    displayCarControlMap(str, 0);
    pause(dt);
end
    

