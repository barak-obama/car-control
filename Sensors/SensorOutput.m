function [ sensorData ] = SensorOutput( car, str )
p = polygonFromCar(car,0);
l = sqrt((max(str.map(:,1))-min(str.map(:,1)))^2+(max(str.map(:,2))-min(str.map(:,2)))^2);
sensorData = repmat(l,5,4);
for i=1:length(str.cars)
    if ~structcmp(str.cars{1,i},car)
        k=1;
        for j=-3*pi/4:pi/4:pi/4
            s=[p(1,:)',getPoint(p(1,:)',car.angle+j,l)];
            a = seg2poly(s,polygonFromCar(str.cars{1,i},0)');
            display(s);
            if ~isempty(a)
                a = a(:,1);
                sensorData(k,1) = min([sensorData(k,1);sqrt(sum(a.^2+p(1,:)'.^2))]);
            end
            k=k+1;
        end
        k=1;
        for j=-pi/4:pi/4:3*pi/4
            s=[p(2,:)',getPoint(p(2,:)',car.angle+j,l)];
            a = seg2poly(s,polygonFromCar(str.cars{1,i},0)');
            display(s);
            if ~isempty(a)
                a = a(:,1);
                sensorData(k,1) = min([sensorData(k,1);sqrt(sum(a.^2+p(2,:)'.^2))]);
            end
            k=k+1;
        end
        k=1;
        for j=-3*pi/4+pi:pi/4:pi/4+pi
            s=[p(3,:)',getPoint(p(3,:)',car.angle+j,l)];
            a = seg2poly(s,polygonFromCar(str.cars{1,i},0)');
            display(s);
            if ~isempty(a)
                a = a(:,1);
                sensorData(k,1) = min([sensorData(k,1);sqrt(sum(a.^2+p(3,:)'.^2))]);
            end
            k=k+1;
        end
        k=1;
        for j=-pi/4+pi:pi/4:3*pi/4+pi
            s=[p(4,:)',getPoint(p(4,:)',car.angle+j,l)];
            a = seg2poly(s,polygonFromCar(str.cars{1,i},0)');
            display(s);
            if ~isempty(a)
                a = a(:,1);
                sensorData(k,1) = min([sensorData(k,1);sqrt(sum(a.^2+p(4,:)'.^2))]);
            end
            k=k+1;
        end
    end
end
for i=1:length(str.obstacles)
    k=1;
    for j=-3*pi/4:pi/4:pi/4
        s=[p(1,:)',getPoint(p(1,:)',car.angle+j,l)];
        a = seg2poly(s,[str.obstacles{1,i}.x';str.obstacles{1,i}.y']);
            display(s);
        if ~isempty(a)
            a = a(:,1);
            sensorData(k,1) = min([sensorData(k,1);sqrt(sum(a.^2+p(1,:)'.^2))]);
        end
        k=k+1;
    end
    k=1;
    for j=-pi/4:pi/4:3*pi/4
        s=[p(2,:)',getPoint(p(2,:)',car.angle+j,l)];
        a = seg2poly(s,[str.obstacles{1,i}.x';str.obstacles{1,i}.y']);
            display(s);
        if ~isempty(a)
            a = a(:,1);
            sensorData(k,1) = min([sensorData(k,1);sqrt(sum(a.^2+p(2,:)'.^2))]);
        end
        k=k+1;
    end
    k=1;
    for j=-3*pi/4+pi:pi/4:pi/4+pi
        s=[p(3,:)',getPoint(p(3,:)',car.angle+j,l)];
        a = seg2poly(s,[str.obstacles{1,i}.x';str.obstacles{1,i}.y']);
            display(s);
        if ~isempty(a)
            a = a(:,1);
            sensorData(k,1) = min([sensorData(k,1);sqrt(sum(a.^2+p(3,:)'.^2))]);
        end
        k=k+1;
    end
    k=1;
    for j=-pi/4+pi:pi/4:3*pi/4+pi
        s=[p(4,:)',getPoint(p(4,:)',car.angle+j,l)];
        a = seg2poly(s,[str.obstacles{1,i}.x';str.obstacles{1,i}.y']);
            display(s);
        if ~isempty(a)
            a = a(:,1);
            sensorData(k,1) = min([sensorData(k,1);sqrt(sum(a.^2+p(4,:)'.^2))]);
        end
        k=k+1;
    end
end
end