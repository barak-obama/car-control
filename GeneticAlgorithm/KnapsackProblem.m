function [fff chrom] = KnapsackProblem(elitePercentage,crossoverPercentage,mutationPercentage,chromoNum,percent1inMatrix)
load('ValueWeights.mat');
chromoLength = length(Value);
fitness = @(a) fitnesss(a);
cross = @(a,b,c) [a(1:c,1);b(c+1:length(b),1)];
crossover = @(a,b) cross(a,b,randi(chromoLength));
mutation = @(a) 1-a;
a = zeros(chromoLength,chromoNum);
r = rand(size(a));
a(r<percent1inMatrix) = 1;
fff = fitness(a);
averageF = [sum(fff)/length(fff),max(fff)];
ind = find(fff==1062);
generation=1
while isempty(ind) && generation<500
a = GenAlg(a,fitness,crossover,mutation,elitePercentage,mutationPercentage,crossoverPercentage);
fff = fitness(a);
averageF = [averageF;[sum(fff)/length(fff),max(fff)]];
ind = find(fff==1062);
generation=generation+1
if mod(generation,100)==0
    max(fff)
end
end
plot(averageF);
[fff, ind] = max(fff);
chrom = a(:,ind);
end

function [fit] = fitnesss(a)
load('ValueWeights.mat');
fit = (Value * a) .* ((Weights * a)<=40);
end