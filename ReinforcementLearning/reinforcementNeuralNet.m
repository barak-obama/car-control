function [ net ] = reinforcementNeuralNet( netsize, str, car, numsteps )
%netsize - vector of layer sizes including input and output
addpath('../Physics');
net = fitnet(netsize);
net.performParam.str = str;
net.performParam.car = car;
net.performParam.numsteps = numsteps;
net.performParam.net = net;
net = train(net,getreality(car)',[1;1]);
end