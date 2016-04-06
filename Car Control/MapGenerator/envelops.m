function [ b ] = envelops( cars, str )
b = 0;
for i=1:length(cars)
   if inpolygon(cars{1,i}.x,cars{1,i}.y,str.x,str.y) || ...
      inpolygon(cars{1,i}.fx,cars{1,i}.fy,str.x,str.y)
       b = 1;
       return;
   end
end
end