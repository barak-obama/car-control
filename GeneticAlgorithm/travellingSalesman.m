function [ best, distance ] = travellingSalesman( locations, num, maxgen, elitePercentage, crossoverPercentage, mutationPercentage )
fitness = @(a) fitnessA(a);
cross = @(a,b,c) [a(1:c,1);b(c+1:length(b),1)];
crossover = @(a,b) cross(a,b,randi(chromoLength));
mutation = @(a) 1-a;
for
GenAlg(pop,fitness,crossover,mutation,elitePercentage,mutationPercentage,crossoverPercentage);
end
function [d] = fitnessA( a )
    d=0;
    for i=2:length(a)
    d = d+sqrt((a(i).x-a(i-1).x)^2+(a(i).y-a(i-1).y)^2);
    end
    d=1/d;
end
function [pop] = population(options)
pop = [];
while ~isempty(options)
    ran = randi(length(options));
    pop = [pop;options(ran)];
    options(ran) = [];
end
end