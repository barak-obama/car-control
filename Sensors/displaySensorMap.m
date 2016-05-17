function displaySensorMap( sensorDataP, points )
for i=1:size(points, 2)
    plot(points(1,i), points(2,i), 'o');
end

for j=1:size(sensorDataP, 2)
     for i = 1:size(sensorDataP, 1)
        plot([sensorDataP(i, j, 1) points(1, j)], [sensorDataP(i, j, 2) points(2, j)]);
     end
end
end