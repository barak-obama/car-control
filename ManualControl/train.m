close all
%DefaultMap
global prevSize
strC = str;
prevSize = length(T);
clear ppp;
s = serial('COM6');
%s.BytesAvailableFcnCount = 5;
%s.BytesAvailableFcnMode = 'byte';
%s.BytesAvailableFcn = @works;
fopen(s);
Joystick(s);
while 1
[x, y, d] = Joystick(s);
display([x, y, d])
if isnan(x)
    x=0;
end
X = [X,getreality(strC.cars{1})'];
T = [T,[y;x]];
[strC, canContinue] = updatereality(strC, strC.cars{1}, y, x, 0.05, 4*pi/10);
clf
displayCarControlMap(strC, 1);
drawnow;
if d || ~canContinue 
    fclose(s);
    if hascrashed(strC,strC.cars{1})||d
        X = X(:,1:prevSize);
        T = T(:,1:prevSize);
    else
        D{end+1} = str;
    end
    break;
end 
flushinput(s);
end