function [ population ] = crossoverP(population ,str , crossoverPercentage, crossoverAlg )
for i = size(population,2)+1:size(str.p,2)
a = roulette(str);
b = roulette(str);
con = 1;
if(rand<=crossoverPercentage)
     c = crossoverAlg(a,b);
     con = 0;
end
if rand>=0.5&&con
     c = a;
elseif con
     c = b;
end
population = [population, c];
end
end

