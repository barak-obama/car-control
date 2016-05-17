function [ population ] = mutationP( population, mutationPercentage, mutationAlg )
    for i = 1:size(population,2)
        for j = 1:size(population,1)
            if(rand<mutationPercentage)
                population(j,i) = mutationAlg(population(:,i),j);
            end
        end
    end
end

