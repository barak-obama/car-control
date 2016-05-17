function [ best, fitNess ] = PrisonerDillema( elitePercentage, crossoverPercentage, mutationPercentage, chromoNum, percent1, enemy, maxFitness, maxGenerations, lll )
a = zeros(16,chromoNum);
r = rand(size(a));
a(r<percent1) = 1;
cross = @(a,b,c) [a(1:c,1);b(c+1:length(b),1)];
crossover = @(a,b) cross(a,b,randi(16));
mutation = @(a) 1-a;
fitAlg = @(a) fitnes(a, enemy, lll);
generation = 0;
fff = fitAlg(a);
fitplot = [mean(fff),max(fff)];
while generation<maxGenerations && fitplot(end,2)<maxFitness
    generation = generation + 1
    a = GenAlg(a,fitAlg,crossover,mutation,elitePercentage,mutationPercentage,crossoverPercentage);
    fff = fitAlg(a);
    fitplot = [fitplot;[mean(fff),max(fff)]];
    
    imagesc(a)
    colormap('gray')
    title(generation)
    drawnow;
end
best = fitnes(a,enemy, lll);
[fitNess,ind] = max(best);
best = getFit(a(:,ind),enemy, lll);
plot(fitplot);
end

function [fit] = fitnes(population, enemy, lll)
fit = [];
for i=1:size(population,2)
    ff = getFit(population(:,i),enemy,lll);
    fit = [fit;sum(ff(:,3))];
end
end

function [sum] = getFit(chromo, enemy, lll)
fitn = [];
alg = [];
enen = [];
prevGames = [[0;0] [0;0]];
for i=1:lll
    enen = [enen;enemy(alg, enen)];
    alg = [alg;chromo([8 4 2 1]*[prevGames(:,1);prevGames(:,2)]+1)];
switch [2 1]*[alg(end);enen(end)]
    case 0
        fitn = [fitn ; 3];
    case 1
        fitn = [fitn ; 0];
    case 2
        fitn = [fitn ; 10];
    case 3 
        fitn = [fitn ; 1];
end
prevGames = [prevGames(:,2) [alg(end);enen(end)]];
end
sum = [alg enen fitn];
end