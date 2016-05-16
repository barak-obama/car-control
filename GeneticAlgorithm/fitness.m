function [ ret ] = fitness( population, fitnessAlg )
fit = fitnessAlg(population);
[a,b] = sort(fit,'descend');
sorted = population(:,b);
%for i = 1:length(b)
%    sorted = [sorted,population(:,b(i))];
%end
ret = struct('p',sorted,'f',a);
end

