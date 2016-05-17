global dt
dt = 0.1;
DefaultMap;
netSize = [20, 10];
numStepsSim = 100;
numGenerations = 50;
chromoNum = 30;
elitePerc = 0.3;
crossPerc = 0.7;
mutPerc = 0.01;
inL = length(getreality(str.cars{1}));
[chromoLength, chromoIndex] = GenerateChromo(inL,2,netSize);
bestChromo = NeuralNetWeights(str,chromoLength,chromoIndex,netSize,...
    numStepsSim,chromoNum,numGenerations,elitePerc,crossPerc,mutPerc);
net = fitnet(netsize);
net = configure(net,[(1:inL)', (inL:-1:1)',(1:2:(inL*2))'],[(1:2)',(2:-1:1)', [1;1]]);
net = netFromChromo(bestChromo,chromoIndex,net);