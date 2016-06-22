close all
%DefaultMap
global sss prevSize
prevSize = length(T);
sss = str;
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
X = [X,getreality(sss.cars{1})'];
T = [T,[y;x]];
[sss, canContinue] = updatereality(sss, sss.cars{1}, y, x, 0.1, 4*pi/10);
tic;
clf
displayCarControlMap(sss, 1);
drawnow;
display(toc);
if d || ~canContinue 
    fclose(s);
    if hascrashed(sss,sss.cars{1})||d
        X = X(:,1:prevSize);
        T = T(:,1:prevSize);
    end
    break;
end 
flushinput(s);
end

clf
displayCarControlMap(sss, 1);
drawnow;