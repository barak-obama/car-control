function [ best ] = NeuralNetWeights( str, chromoLength, chromoIndex, ...
    netsize, numStepsSim, chromoNum, numGenerations, elitePercentage, ...
    crossoverPercentage, mutationPercentage )
pop = rand(chromoLength,chromoNum);
nets = cell(1,chromoNum);
for i=1:chromoNum
    nets{i} = fitnet(netsize);
    nets{i} = configure(nets{i},(1:21)',(1:2)');
end
fAlg = @(a) fitnessalg(a, str, chromoIndex, numStepsSim, nets);
cAlg = @(a, b) crossoveralg(a, b, chromoIndex);
mAlg = @(a, j) mutationalg(a, j);
for i=1:numGenerations
    pop = GenAlg(pop,fAlg,cAlg,mAlg,elitePercentage,mutationPercentage,crossoverPercentage);
end
fit = fitnessalg(pop);
[~, chromoIndex] = max(fit);
best = pop(:, chromoIndex);
end

function [ fit ] = fitnessalg( a, str, ind, numc, nets )
fit = zeros(size(a, 2));
for i = 1:length(fit)
    fit(i) = fitness(a(:,i), str, ind, numc, nets{i});
end
end

function [ fit ] = fitness( a, str, ind, numc, net )
canContinue = ones(size(str.cars));
layers = net.layers(1:end-1);
lay = zeros(size(layers));
for i=1:length(layers)
   lay(i) = layers{i}.size;
end
layers = lay;
view(net);
pause;
net.IW{1,1} = [];
for i=2:length(net.LW)
   net.LW{i,i-1} = [];
end
for i=1:length(net.b)
   net.b{i} = []; 
end
%putting new values
for i=1:layers(1)
    net.IW{1,1} = [net.IW{1,1};a(ind(i):ind(i+1))];
end
count = 0;
for i=1:length(layers)
    for j=1:layers(i)
        net.LW{i+1,i} = [net.LW{i+1,i},a(ind(layers(1)+j+count):ind(layers(1)+1+j+count))];
    end
    count = count + layers(i);
    net.b{i} = a(ind(layers(1)+sum(layers)+i):ind(ind(layers(1)+sum(layers)+i+1)));
end
net.b{end} = a(ind(end-1):end);
view(net);
pause;
for i=1:numc
    for j=1:length(canContinue)
        [str, canContinue(j)] = updatereality(str,str.cars{j},net(getreality(str.cars{j})));
    end
end
for i=1:length(canContinue)
    canContinue(i) = getrealityscore(str,str.cars{i});
end
fit = mean(canContinue);
end

function [ c ] = crossoveralg( a, b, ind )
cross = randi(length(ind)-2)+1;
if rand<0.5
    c = [a(1:ind(cross));b(ind(cross):end)];
else
    c = [b(1:ind(cross));a(ind(cross):end)];
end
end

function [ a ] = mutationalg( a, j )
a(j) = rand;
end