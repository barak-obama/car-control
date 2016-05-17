function [ score, i ] = nstepsahead( str, car, net, numsteps )
for i=1:numsteps
    [str, canContinue] = updatereality(str, car, net(getreality(car)));
    if ~canContinue
       break;
    end
end
score = getrealityscore(str, car);
end