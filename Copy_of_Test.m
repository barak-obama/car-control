str = GenerateCarControlMap(50,50,4.7,2.1,20,1);

str.obstacles = {};
car = str.cars{1};
car.x = 25;
car.y = 25;
car.fx = 0;
car.fy = 0;
car.angle = -pi/4;
car.v = 0;

[~, car.sensorData, car.points] = SensorData(car, str);
str.cars{1} = car;

displayCarControlMap(str, 0);

dt = 0.5;

canContinue = 1;
% s = serial('/dev/cu.usbmodem1411');
% fopen(s);
% Joystick(s);
i = 0;
while canContinue
    i = i + 1;
    hold on;
%      [x, y, d] = Joystick(s);
%      if isnan(x)
%          x = 0;
%      end
    x = 0;
    if i > 30
        x = 0.6;
    end
    y = 0.8;
    d = 0;
    clf
    [ str, canContinue ] = updatereality( str, str.cars{1}, y, x, dt, 4 * pi/10  );
    hold off

    displayCarControlMap(str, 1);
    drawnow;
    pause(dt)
%     flushinput(s);
end