function displayCarControlMap( str )
figure;
hold on;
axis equal;
plot(str.map(:,1),str.map(:,2));
for i=1:length(str.cars)
    if ~isempty(str.cars{1,i})
        xy = polygonFromCar(str.cars{1,i}, 0);
        fill(xy(:,1),xy(:,2),'g');
        fx = str.cars{1,i}.fx;
        fy = str.cars{1,i}.fy;
        inc = max([str.cars{1,i}.length,str.cars{1,i}.width])/10;
        fill([fx-inc;fx-inc;fx+inc;fx+inc;fx-inc],[fy-inc;fy+inc;fy+inc;fy-inc;fy-inc],'b');
    end
end
for i=1:length(str.obstacles)
    if ~isempty(str.obstacles{1,i})
        fill(str.obstacles{1,i}.x,str.obstacles{1,i}.y,'r');
    end
end
end