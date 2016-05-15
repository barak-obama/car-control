function [ str, canContinue ] = updatereality( str, car, nt )
%net
if ~isempty(nt)
    str.cars{car.id}.a = str.cars{car.id}.a + (nt(1)-0.5);
    str.cars{car.id}.angle = str.cars{car.id}.angle + (nt(2)-0.5);
    %physics
    str.cars{car.id}.v = str.cars{car.id}.v + str.cars{car.id}.a;
    str.cars{car.id}.x = str.cars{car.id}.x + cos(str.cars{car.id}.angle)*str.cars{car.id}.v;
    str.cars{car.id}.y = str.cars{car.id}.y + sin(str.cars{car.id}.angle)*str.cars{car.id}.v;
    %sensors
    [~, str.cars{car.id}.sensorData, str.cars{car.id}.points] = SensorData(car, str);
end
canContinue = 1-hascrashed(str,car);
end