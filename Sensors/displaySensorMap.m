function displaySensorMap( car, sensorData, str )
p = polygonFromCar(car,0);
    addpath('../MapGenerator')
    displayCarControlMap(str);
    hold on;
k=1;
for j=-3*pi/4:pi/4:pi/4
    s=[p(1,:)',getPoint(p(1,:)',pi/2-car.angle+j,sensorData(k,1))];
    plot(s(1,:),s(2,:));
    k=k+1;
end
k=1;
for j=-pi/4:pi/4:3*pi/4
    s=[p(2,:)',getPoint(p(2,:)',pi/2-car.angle+j,sensorData(k,2))];
    plot(s(1,:),s(2,:));
    k=k+1;
end
k=1;
for j=-3*pi/4+pi:pi/4:pi/4+pi
    s=[p(3,:)',getPoint(p(3,:)',pi/2-car.angle+j,sensorData(k,3))];
    plot(s(1,:),s(2,:));
    k=k+1;
end
k=1;
for j=-pi/4+pi:pi/4:3*pi/4+pi
    s=[p(4,:)',getPoint(p(4,:)',pi/2-car.angle+j,sensorData(k,4))];
    plot(s(1,:),s(2,:));
    k=k+1;
end
end