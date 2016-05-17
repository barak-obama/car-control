function [ population ] = GenAlg( population, fitnessAlg, crossoverAlg, mutationAlg, elitePercentage, mutationPercentage, crossoverPercentage )
str = fitness(population, fitnessAlg);
population = mutationP(crossoverP(eliteP(str, elitePercentage), str, crossoverPercentage, crossoverAlg), mutationPercentage, mutationAlg);
end

