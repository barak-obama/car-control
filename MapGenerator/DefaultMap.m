addpath('../Sensors')
str = GenerateCarControlMap(40,40,4.7,2.1,20,1);
%str.cars = cell(0,0);
displayCarControlMap(str);
hold on;

 car = str.cars{1};
 
 [ sensorDataD, sensorDataP, points] = SensorData(car, str);
 
 for i=1:size(points, 2)
     plot(points(1,i), points(2,i), 'o');
 end
 
 
 for j=1:size(sensorDataP, 2)
      for i = 1:size(sensorDataP, 1)
         p = sensorDataP(i, j, :);
         
         plot([p(1) points(1, j)], [p(2) points(2, j)]);
      end
 end
