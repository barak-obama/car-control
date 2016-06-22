function works(obj, event)
global sss X T
[x, y, d] = Joystick(obj);
display([x, y, d])
% x = (x-0.5)/2;
% y = (y-0.5);
X = [X,getreality(sss.cars{1})'];
T = [T,[y;x]];
[sss, canContinue] = updatereality(sss, sss.cars{1}, y, x/10, 0.1, 4*pi/10);
clf
displayCarControlMap(sss, 1);
if d || ~canContinue 
    fclose(obj);
    if hascrashed(sss,sss.cars{1})||d
        global prevSize
        X = X(:,1:prevSize);
        T = T(:,1:prevSize);
    end
end
pause(0.0004);
end