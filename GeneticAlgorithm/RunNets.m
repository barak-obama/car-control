global dt
dt = 0.1;
DefaultMap;
netSize = [10, 20];
numStepsSim = 300;
numGenerations = 100;
chromoNum = 10;
elitePerc = 0.3;
crossPerc = 0.7;
mutPerc = 0.01;
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