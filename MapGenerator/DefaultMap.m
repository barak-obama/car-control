str = GenerateCarControlMap(40,40,4.7 / 2,2.1 / 2,8,1);
displayCarControlMap(str);
hold on;
car = str.cars{1};
car_pos = ([cos(car.angle), sin(car.angle); -sin(car.angle), cos(car.angle)] * [0;car.length / 2] + [car.x; car.y])';
plot(car_pos(1), car_pos(2), '*');
plot(b, tan(pi/2 - car.angle)*(b - car.x) + car.y)
plot(car.x, car.y + car.length / 2, 'o')