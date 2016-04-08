function [ sensorData ] = SensorOutput( car, str )
p = polygonFromCar(car,0);
l = sqrt((max(str.map(:,1))-min(str.map(:,1)))^2+(max(str.map(:,2))-min(str.map(:,2)))^2);
sensorData = repmat(l,5,4);
k=1;
for j=-3*pi/4:pi/4:pi/4
    s=[p(1,:)',getPoint(p(1,:)',pi/2-car.angle+j,sensorData(k,1))];
    pfc = str.map';
    a = seg2poly(s,pfc);
    if ~isempty(a)
        sensorData(k,1) = min(sqrt(sum((a  - repmat(p(1,:)',1,size(a,2)))).^2));
    end
    k=k+1;
end
k=1;
for j=-pi/4:pi/4:3*pi/4
    s=[p(2,:)',getPoint(p(2,:)',pi/2-car.angle+j,sensorData(k,2))];
    pfc = str.map';
    a = seg2poly(s,pfc);
    if ~isempty(a)
        sensorData(k,2) = min(sqrt(sum((a  - repmat(p(2,:)',1,size(a,2)))).^2));
    end
    k=k+1;
end
k=1;
for j=-3*pi/4+pi:pi/4:pi/4+pi
    s=[p(3,:)',getPoint(p(3,:)',pi/2-car.angle+j,sensorData(k,3))];
    pfc = str.map';
    a = seg2poly(s,pfc);
    if ~isempty(a)
        sensorData(k,3) = min(sqrt(sum((a  - repmat(p(3,:)',1,size(a,2)))).^2));
    end
    k=k+1;
end
k=1;
for j=-pi/4+pi:pi/4:3*pi/4+pi
    s=[p(4,:)',getPoint(p(4,:)',pi/2-car.angle+j,sensorData(k,4))];
    pfc = str.map';
    a = seg2poly(s,pfc);
    if ~isempty(a)
        sensorData(k,4) = min(sqrt(sum((a  - repmat(p(4,:)',1,size(a,2)))).^2));
    end
    k=k+1;
end
for i=1:length(str.cars)
    if ~structcmp(str.cars{1,i},car)
        k=1;
        for j=-3*pi/4:pi/4:pi/4
            s=[p(1,:)',getPoint(p(1,:)',pi/2-car.angle+j,sensorData(k,1))];
            pfc = polygonFromCar(str.cars{1,i},0)';
            a = seg2poly(s,pfc);
            if ~isempty(a)
                sensorData(k,1) = min(sqrt(sum((a  - repmat(p(1,:)',1,size(a,2)))).^2));
            end
            k=k+1;
        end
        k=1;
        for j=-pi/4:pi/4:3*pi/4
            s=[p(2,:)',getPoint(p(2,:)',pi/2-car.angle+j,sensorData(k,2))];
            pfc = polygonFromCar(str.cars{1,i},0)';
            a = seg2poly(s,pfc);
            if ~isempty(a)
                sensorData(k,2) = min(sqrt(sum((a  - repmat(p(2,:)',1,size(a,2)))).^2));
            end
            k=k+1;
        end
        k=1;
        for j=-3*pi/4+pi:pi/4:pi/4+pi
            s=[p(3,:)',getPoint(p(3,:)',pi/2-car.angle+j,sensorData(k,3))];
            pfc = polygonFromCar(str.cars{1,i},0)';
            a = seg2poly(s,pfc);
            if ~isempty(a)
                sensorData(k,3) = min(sqrt(sum((a  - repmat(p(3,:)',1,size(a,2)))).^2));
            end
            k=k+1;
        end
        k=1;
        for j=-pi/4+pi:pi/4:3*pi/4+pi
            s=[p(4,:)',getPoint(p(4,:)',pi/2-car.angle+j,sensorData(k,4))];
            pfc = polygonFromCar(str.cars{1,i},0)';
            a = seg2poly(s,pfc);
            if ~isempty(a)
                sensorData(k,4) = min(sqrt(sum((a  - repmat(p(4,:)',1,size(a,2)))).^2));
            end
            k=k+1;
        end
    end
end
for i=1:length(str.obstacles)
    k=1;
    for j=-3*pi/4:pi/4:pi/4
        s=[p(1,:)',getPoint(p(1,:)',pi/2-car.angle+j,sensorData(k,1))];
        pfc = [str.obstacles{1,i}.x';str.obstacles{1,i}.y'];
        a = seg2poly(s,pfc);
        if ~isempty(a)
        	sensorData(k,1) = min(sqrt(sum((a  - repmat(p(1,:)',1,size(a,2)))).^2));
        end
        k=k+1;
    end
    k=1;
    for j=-pi/4:pi/4:3*pi/4
        s=[p(2,:)',getPoint(p(2,:)',pi/2-car.angle+j,sensorData(k,2))];
        pfc = [str.obstacles{1,i}.x';str.obstacles{1,i}.y'];
        a = seg2poly(s,pfc);
        if ~isempty(a)
        	sensorData(k,2) = min(sqrt(sum((a  - repmat(p(2,:)',1,size(a,2)))).^2));
        end
        k=k+1;
    end
    k=1;
    for j=-3*pi/4+pi:pi/4:pi/4+pi
        s=[p(3,:)',getPoint(p(3,:)',pi/2-car.angle+j,sensorData(k,3))];
        pfc = [str.obstacles{1,i}.x';str.obstacles{1,i}.y'];
        a = seg2poly(s,pfc);
        if ~isempty(a)
        	sensorData(k,3) = min(sqrt(sum((a  - repmat(p(3,:)',1,size(a,2)))).^2));
        end
        k=k+1;
    end
    k=1;
    for j=-pi/4+pi:pi/4:3*pi/4+pi
        s=[p(4,:)',getPoint(p(4,:)',pi/2-car.angle+j,sensorData(k,4))];
        pfc = [str.obstacles{1,i}.x';str.obstacles{1,i}.y'];
        a = seg2poly(s,pfc);
        if ~isempty(a)
        	sensorData(k,4) = min(sqrt(sum((a  - repmat(p(4,:)',1,size(a,2)))).^2));
        end
        k=k+1;
    end
end
end