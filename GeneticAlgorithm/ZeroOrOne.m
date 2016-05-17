function [generation,averageF] = ZeroOrOne(elitePercentage,crossoverPercentage,mutationPercentage,chromoLength,chromoNum,percent1inMatrix,maxGen)
fitness = @(a) sum(a);
cro = @(a,b,c) [a(1:c,1);b(c+1:length(b),1)];
cross = @(ab,c) cro(ab(:,c+1),ab(:,1-c+1),randi(chromoLength));
crossover = @(a,b) cross([a b],round(rand));
mutation = @(a) 1-a;
a = zeros(chromoLength,chromoNum);
r = rand(size(a));
a(r<percent1inMatrix) = 1;
fff = fitness(a);
averageF = zeros(100,2);
averageF(1,:) = [sum(fff)/length(fff),max(fff)];
ind = find(fff==chromoLength);
generation=1;
while(isempty(ind) && generation<maxGen)
a = GenAlg(a,fitness,crossover,mutation,elitePercentage,mutationPercentage,crossoverPercentage);
fff = fitness(a);
averageF(generation+1,:) = [sum(fff)/length(fff),max(fff)];
ind = find(fff==chromoLength);
generation=generation+1;
if mod(generation,100)==0
    max(fff)
end
end
%plot(averageF);
end