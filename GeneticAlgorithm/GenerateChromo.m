function [ cl, ind ] = GenerateChromo( numInputs, numOutputs, netSize )
ind = 0;
netSize = [numInputs,netSize,numOutputs];
for i=2:length(netSize)
    ind = [ind,(1:netSize(i)).*netSize(i-1)+ind(end)];
end
for i=2:length(netSize)
   ind(end+1) = ind(end)+netSize(i); 
end
cl = ind(end);
end

