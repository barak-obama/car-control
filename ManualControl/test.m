close all
%DefaultMap
prevSize = length(T);
global sss
sss = str;
clear ppp;
s = serial('COM5');
s.BytesAvailableFcnCount = 5;
s.BytesAvailableFcnMode = 'byte';
s.BytesAvailableFcn = @works;
fopen(s);