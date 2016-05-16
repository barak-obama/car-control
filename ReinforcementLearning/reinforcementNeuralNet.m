function [ n ] = reinforcementNeuralNet( netsize, str, car, numsteps )
%netsize - vector of layer sizes including input and output
global struc caruc numstepsuc net
struc = str;
caruc = car;
numstepsuc = numsteps;
addpath('../Physics');
net = fitnet(netsize);
x = getreality(car)';
display(x);
net = train(net,getreality(car)',[1;1]);
n = net;
end