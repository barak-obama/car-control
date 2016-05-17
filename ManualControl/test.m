close all
DefaultMap

s = serial('/dev/cu.usbmodem1421');
fopen(s);
while 1
[x,y,d] = Joystick(s)
[str, canContinue] = updatereality(str, str.cars{1}, [(y-0.5)/100+0.5, (x-0.5)/100+0.5]);
clf
displayCarControlMap(str, 1);
if d || ~canContinue 
    break;
end
pause(1)
end

fclose(s)