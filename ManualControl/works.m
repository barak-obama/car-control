function works(obj, event)
global sss X T
[x, y, d] = Joystick(obj);
x = (x-0.5)/2;
y = (y-0.5);
X = [X,getreality(sss.cars{1})'];
T = [T,[y;x]];
[sss, canContinue] = updatereality(sss, sss.cars{1}, y, x, 0.1, pi);
clf
displayCarControlMap(sss, 1);
if d || ~canContinue 
    fclose(obj);
end
pause(0.01);
end