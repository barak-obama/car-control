function works(obj, event)
global sss X T
[x, y, d] = Joystick(obj);
display([x, y, d])
X = [X,getreality(sss.cars{1})'];
T = [T,[y;x]];
[sss, canContinue] = updatereality(sss, sss.cars{1}, y, x, 0.1, 4*pi/10);
clf
displayCarControlMap(sss, 1);
drawnow;
flushinput(obj);
flushoutput(obj);
if d || ~canContinue 
    fclose(obj);
    if hascrashed(sss,sss.cars{1})||d
        global prevSize
        X = X(:,1:prevSize);
        T = T(:,1:prevSize);
    end
end
end