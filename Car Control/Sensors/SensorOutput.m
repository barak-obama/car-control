function [ sensorData ] = SensorOutput( car, str )
p = polygonFromCar(car,0);
figure;
plot(p(:,1),p(:,2));
hold on;
axis equal;
pause;
l = sqrt((max(str.map(:,1))-min(str.map(:,1)))^2+(max(str.map(:,2))-min(str.map(:,2)))^2);
sensorData = repmat(l,5,4);
for i=1:length(str.cars)
    if ~structcmp(str.cars{1,i},car)
        k=1;
        for j=-3*pi/4:pi/4:pi/4
            s=[p(1,:)',getPoint(p(1,:)',-car.angle+j,l)];
            pfc = polygonFromCar(str.cars{1,i},0)';
            a = seg2poly(s,pfc);
            if ~isempty(a)
                a = a(:,end);
                display(a);
                h1 = plot(s(1,:),s(2,:));
                h2 = plot(pfc(1,:),pfc(2,:));
                pause;
                delete(h1);
                delete(h2);
                sensorData(k,1) = min([sensorData(k,1);sqrt(sum(abs(a.^2-p(1,:)'.^2)))]);
            end
            k=k+1;
        end
        k=1;
        for j=-pi/4:pi/4:3*pi/4
            s=[p(2,:)',getPoint(p(2,:)',-car.angle+j,l)];
            pfc = polygonFromCar(str.cars{1,i},0)';
            a = seg2poly(s,pfc);
            if ~isempty(a)
                a = a(:,end);
                display(a);
                h1 = plot(s(1,:),s(2,:));
                h2 = plot(pfc(1,:),pfc(2,:));
                pause;
                delete(h1);
                delete(h2);
                sensorData(k,2) = min([sensorData(k,2);sqrt(sum(abs(a.^2-p(2,:)'.^2)))]);
            end
            k=k+1;
        end
        k=1;
        for j=-3*pi/4+pi:pi/4:pi/4+pi
            s=[p(3,:)',getPoint(p(3,:)',-car.angle+j,l)];
            pfc = polygonFromCar(str.cars{1,i},0)';
            a = seg2poly(s,pfc);
            if ~isempty(a)
                a = a(:,end);
                display(a);
                h1 = plot(s(1,:),s(2,:));
                h2 = plot(pfc(1,:),pfc(2,:));
                pause;
                delete(h1);
                delete(h2);
                sensorData(k,3) = min([sensorData(k,3);sqrt(sum(abs(a.^2-p(3,:)'.^2)))]);
            end
            k=k+1;
        end
        k=1;
        for j=-pi/4+pi:pi/4:3*pi/4+pi
            s=[p(4,:)',getPoint(p(4,:)',-car.angle+j,l)];
            pfc = polygonFromCar(str.cars{1,i},0)';
            a = seg2poly(s,pfc);
            if ~isempty(a)
                a = a(:,end);
                display(a);
                h1 = plot(s(1,:),s(2,:));
                h2 = plot(pfc(1,:),pfc(2,:));
                pause;
                delete(h1);
                delete(h2);
                sensorData(k,4) = min([sensorData(k,4);sqrt(sum(abs(a.^2-p(4,:)'.^2)))]);
            end
            k=k+1;
        end
    end
end
for i=1:length(str.obstacles)
    k=1;
    for j=-3*pi/4:pi/4:pi/4
        s=[p(1,:)',getPoint(p(1,:)',-car.angle+j,l)];
        pfc = [str.obstacles{1,i}.x';str.obstacles{1,i}.y'];
        a = seg2poly(s,pfc);
        if ~isempty(a)
            a = a(:,end);
            display(a);
            h1 = plot(s(1,:),s(2,:));
            h2 = plot(pfc(1,:),pfc(2,:));
            pause;
            delete(h1);
            delete(h2);
            sensorData(k,1) = min([sensorData(k,1);sqrt(sum(abs(a.^2-p(1,:)'.^2)))]);
        end
        k=k+1;
    end
    k=1;
    for j=-pi/4:pi/4:3*pi/4
        s=[p(2,:)',getPoint(p(2,:)',-car.angle+j,l)];
        pfc = [str.obstacles{1,i}.x';str.obstacles{1,i}.y'];
        a = seg2poly(s,pfc);
        if ~isempty(a)
            a = a(:,end);
            display(a);
            h1 = plot(s(1,:),s(2,:));
            h2 = plot(pfc(1,:),pfc(2,:));
            pause;
            delete(h1);
            delete(h2);
            sensorData(k,2) = min([sensorData(k,2);sqrt(sum(abs(a.^2-p(2,:)'.^2)))]);
        end
        k=k+1;
    end
    k=1;
    for j=-3*pi/4+pi:pi/4:pi/4+pi
        s=[p(3,:)',getPoint(p(3,:)',-car.angle+j,l)];
        pfc = [str.obstacles{1,i}.x';str.obstacles{1,i}.y'];
        a = seg2poly(s,pfc);
        if ~isempty(a)
            a = a(:,end);
            display(a);
            h1 = plot(s(1,:),s(2,:));
            h2 = plot(pfc(1,:),pfc(2,:));
            pause;
            delete(h1);
            delete(h2);
            sensorData(k,3) = min([sensorData(k,3);sqrt(sum(abs(a.^2-p(3,:)'.^2)))]);
        end
        k=k+1;
    end
    k=1;
    for j=-pi/4+pi:pi/4:3*pi/4+pi
        s=[p(4,:)',getPoint(p(4,:)',-car.angle+j,l)];
        pfc = [str.obstacles{1,i}.x';str.obstacles{1,i}.y'];
        a = seg2poly(s,pfc);
        if ~isempty(a)
            a = a(:,end);
            display(a);
            h1 = plot(s(1,:),s(2,:));
            h2 = plot(pfc(1,:),pfc(2,:));
            pause;
            delete(h1);
            delete(h2);
            sensorData(k,4) = min([sensorData(k,4);sqrt(sum(abs(a.^2-p(4,:)'.^2)))]);
        end
        k=k+1;
    end
end
end