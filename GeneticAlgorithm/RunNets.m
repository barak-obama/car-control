global dt
dt = 0.1;
DefaultMap;
<<<<<<< HEAD
netSize = [10];
numStepsSim = 50;
numGenerations = 50;
chromoNum = 10;
elitePerc = 0.3;
crossPerc = 0.7;
mutPerc = 0.01;
=======
pause;
netSize = [20];
numStepsSim = 100;
numGenerations = 50;
chromoNum = 15;
elitePerc = 0.7;
crossPerc = 0.01;
mutPerc = 0.003;
>>>>>>> 0179593d8083010e5469550da00a9869152c098e
inL = length(getreality(str.cars{1}));
[chromoLength, chromoIndex] = GenerateChromo(inL,2,netSize);
bestChromo = NeuralNetWeights(str,chromoLength,chromoIndex,netSize,...
    numStepsSim,chromoNum,numGenerations,elitePerc,crossPerc,mutPerc);
net = fitnet(netSize);
net = configure(net,[(1:inL)', (inL:-1:1)',(1:2:(inL*2))'],[(1:2)',(2:-1:1)', [1;1]]);
net = netFromChromo(bestChromo,chromoIndex,net);
display('Ready! press enter to play simulation');
pause;
ShowDriving(str,net,numStepsSim*2);