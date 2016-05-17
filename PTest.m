r = car.length / tan(wheel_angle);
back = [car.x; car.y] - (car.length / 2 )* [cos(pi / 2 - car.angle); sin(pi/2 - car.angle)];
front = [car.x; car.y] + (car.length / 2 )* [cos(pi / 2 - car.angle); sin(pi/2 - car.angle)];
b = front - back;
b = b / norm(b);
if r < 0
    b = back + abs(r) * [0 -1; 1 0] * b;
else
    b = back + abs(r) * [0 1; -1 0] * b;
end

displayCarControlMap(str, 1);
hold onstr
plot(back(1), back(2), 'ob');
plot(front(1), front(2), 'og');
plot(b(1), b(2), 'o')