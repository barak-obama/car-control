function works(obj, event)
global sss X T
[x, y, d] = Joystick(obj);
x = (x-0.5)/2;
y = (y-0.5);
X = [X,getreality(sss.cars{1})'];
T = [T,[y;x]];
[sss, canContinue] = updatereality(sss, sss.cars{1}, y, x, 0.1, pi);
clf
displayCarControlMap(sss, 0);
ylim([sss.cars{1}.y-10, sss.cars{1}.y+40]);
if d || ~canContinue 
    fclose(obj);
    if hascrashed(sss,sss.cars{1})||d
        global prevSize
        X = X(:,1:prevSize);
        T = T(:,1:prevSize);
    end
end
pause(0.01);
end