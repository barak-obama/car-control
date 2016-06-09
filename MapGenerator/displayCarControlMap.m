function [ ppp ] = displayCarControlMap( str, withsensors )
hold on;
axis equal;
ppp = plot(str.map(:,1),str.map(:,2));
for i=1:length(str.cars)
    if ~isempty(str.cars{i})
        xy = polygonFromCar(str.cars{i}, 0);
        fill(xy(:,1),xy(:,2),'g');
        if withsensors
            for k=1:size(str.cars{i}.points, 2)
                plot(str.cars{i}.points(1,k), ...
                    str.cars{i}.points(2,k), 'o');
            end

            for j=1:size(str.cars{i}.sensorData, 2)
                for k = 1:size(str.cars{i}.sensorData, 1)
                    plot([str.cars{i}.sensorData(k, j, 1) str.cars{i}.points(1, j)],...
                        [str.cars{i}.sensorData(k, j, 2) str.cars{i}.points(2, j)]);
                end
            end
        end
    end
end
for i=1:length(str.obstacles)
    if ~isempty(str.obstacles{1,i})
        fill(str.obstacles{1,i}.x,str.obstacles{1,i}.y,'r');
    end
end
hold off;
end