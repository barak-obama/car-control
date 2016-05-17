function [ winning_values ] = scorchExGen( numChromo, elitePercentage, mutationPercentage, crossoverPercentage, conditions )
fitAlg = @(pop)fitnessFunc(pop);
crossAlg = @(a,b)crossFunc(a,b);
mutAlg = @(pop, j)mutFunc(pop, j);
global blastrad gravity LandSky simulationdelta tmax wind xEnemy xTank yEnemy yTank
blastrad = conditions.blastrad;
gravity = conditions.gravity;
LandSky = conditions.LandSky;
simulationdelta = conditions.simulationdelta;
tmax = conditions.tmax;
wind = conditions.wind;
xEnemy = conditions.xEnemy;
xTank = conditions.xTank;
yEnemy = conditions.yEnemy;
yTank = conditions.yTank;
hold on;
imagesc(LandSky);
axis xy;
xlim([0,800]);
ylim([0,600]);
pop = [randi(181,1,numChromo)-1;randi(1001,1,numChromo)-1];
fit = fitAlg(pop);
generation = 0;
while sum(fit==1)==0
    generation = generation + 1
    pop = GenAlg(pop,fitAlg,crossAlg,mutAlg,elitePercentage,mutationPercentage,crossoverPercentage);
    fit = fitAlg(pop);
    maxFit = max(fit)
    drawnow;
    %if ~mod(generation,100)
    %    [maxe, ind] = max(fit);
    %    scorchReducedGamePermanentConditions_GA(pop(:,ind));
    %    display(maxe);
    %end
end
winning_values = pop(:,fit==1);
close;
conditions.LandSky = uint8(conditions.LandSky);
scorchReducedGamePermanentConditions_GA(winning_values(:,1), conditions);
clc;
end

function [ret] = mutFunc(pop, j)
if j==2
    add = 31;
    maxe = 1000;
else
    add = 4;
    maxe = 180;
end
ra = randi(4);
if ra==1
    ret = pop(j)+add;
elseif ra==2
    ret = pop(j)-add;
elseif ra==3
    ret = pop(j)+1;
else
    ret = pop(j)-1;
end
ret = min(maxe,ret);
ret = max(0,ret);
end

function [c] = crossFunc(a, b)
if round(rand)
    c=[a(1);b(2)];
else
    c=[b(1);a(2)];
end
end

function [fit] = fitnessFunc( pop )
global blastrad gravity LandSky simulationdelta tmax wind xEnemy xTank yEnemy yTank
Adv = [wind;-gravity]*simulationdelta;
mostFit = 0;
allplot = plot(0);
for j=1:size(pop,2)
    position = [xTank;yTank];
    pop(:,j);
    speed = pop(2,j)*[cos(pi*pop(1,j)/180);sin(pi*pop(1,j)/180)];
    for i=2:(tmax/simulationdelta-1)
        [pos, spd] = nextStep(position(:,end), speed(:,end), Adv, simulationdelta);
        speed = [speed spd];
        position = [position pos];
        pos(1) = min(size(LandSky,2),pos(1));
        pos(2) = min(size(LandSky,1),pos(2));
        pos = max(1,pos);
        if LandSky(round(pos(2)),round(pos(1)))
            break;
        end
    end
    dist = sqrt(sum(abs([xEnemy;yEnemy]-position(:,end)).^2));
    if dist<blastrad
        fit(j) = 1
        position(:,end)
    else
        fit(j) = (1000-abs(xEnemy-position(1,end)))/1000;
    end
    if fit(j)>mostFit
        set(allplot,'Visible','off');
        allplot = plot(position(1,:),position(2,:));
    end
end
end

function [loc, speed] = nextStep(loc, speed, adv, smldlt)
speed = speed + adv;
loc = loc + speed*smldlt;
end