close all
%DefaultMap
global sss prevSize
prevSize = length(T);
sss = str;
clear ppp;
s = serial('/dev/cu.usbmodem1411');
s.BytesAvailableFcnCount = 5;
s.BytesAvailableFcnMode = 'byte';
s.BytesAvailableFcn = @works;
fopen(s);