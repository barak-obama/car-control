function [ best ] = NeuralNetWeights( str, chromoLength, chromoIndex, ...
    netsize, numStepsSim, chromoNum, numGenerations, elitePercentage, ...
    crossoverPercentage, mutationPercentage )
pop = rand(chromoLength,chromoNum);
nets = cell(1,chromoNum);
for Generation=1:chromoNum
    nets{Generation} = fitnet(netsize);
    nets{Generation} = configure(nets{Generation},[(1:21)', (21:-1:1)',(1:0.5:11)'],[(1:2)',(2:-1:1)', [1;1]]);
end
fAlg = @(a) fitnessalg(a, str, chromoIndex, numStepsSim, nets);
cAlg = @(a, b) crossoveralg(a, b, chromoIndex);
mAlg = @(a, j) mutationalg(a, j);
bestChromos = struct;
bestChromos.p = [];
bestChromos.f = [];
for Generation=1:numGenerations
    Generation
    [pop, fitnessStr] = GenAlg(pop,fAlg,cAlg,mAlg,elitePercentage,mutationPercentage,crossoverPercentage);
    bestChromos.p(end+1) = fitnessStr.p(1);
    bestChromos.f(end+1) = fitnessStr.f(1);
    cont = 0;
    if length(bestChromos.f) > 3
       bestChromos.f(1) = []; 
       bestChromos.p(1) = [];
    else
        cont = 1;
    end
    for i=2:length(bestChromos.f)
        if bestChromos.f(i-1) < bestChromos.f(i)
           cont = 1;
           break;
        end
    end
    if ~cont
       break; 
    end
end
fit = fitnessalg(pop, str, chromoIndex, numStepsSim, nets);
[~, chromoIndex] = max(fit);
best = pop(:, chromoIndex);
end

function [ fit ] = fitnessalg( a, str, ind, numc, nets )
fit = zeros(1,size(a, 2));
for chromoFit = 1:length(fit)
    chromoFit
    fit(chromoFit) = fitness(a(:,chromoFit), str, ind, numc, nets{chromoFit});
end
end

function [ fit ] = fitness( a, str, ind, numc, net )
canContinue = ones(size(str.cars));
net = netFromChromo(a,ind,net);
global dt
for i=1:numc
    for j=1:length(canContinue)
        netans = net(getreality(str.cars{j}));
        [str, canContinue(j)] = updatereality(str,str.cars{j},netans(1),netans(2),dt,pi);
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
    c = [a(1:ind(cross));b(ind(cross)+1:end)];
else
    c = [b(1:ind(cross));a(ind(cross)+1:end)];
end
end

function [ a ] = mutationalg( a, j )
a = rand;
end