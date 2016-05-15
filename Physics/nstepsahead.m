function [ score, i ] = nstepsahead( str, car, net, numsteps )
score = getrealityscore(str, car);
for i=1:numsteps
    [str, canContinue] = updatereality(str, car, net(getreality(car)));
    if ~canContinue
       break;
    end
end
score = getrealityscore(str, car) - score;
end