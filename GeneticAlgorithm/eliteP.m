function [ pop ] = eliteP( population , percent)
pop = population.p(:,1:round(percent*size(population.p,2)));
end

