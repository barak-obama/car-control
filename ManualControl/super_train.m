X = [];
T = [];
D = {};

str = GenerateCarControlMap(50,50,4.7,2.1,3,1);

while 1
    trainNet
    pause
    str = GenerateCarControlMap(50,50,4.7,2.1,3,1);
end

