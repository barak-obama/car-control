load PermanentConditionsForFitness;
conditions = struct('blastrad', blastrad, 'gravity', gravity, 'LandSky', LandSky, 'simulationdelta', simulationdelta, 'tmax', tmax, 'wind', wind, 'xEnemy', xEnemy, 'xTank', xTank, 'yEnemy', yEnemy, 'yTank', yTank);
%conditions = struct('blastrad', 20, 'gravity', 300, 'LandSky', LandSky, 'simulationdelta', simulationdelta, 'tmax', tmax, 'wind', 200, 'xEnemy', xEnemy, 'xTank', xTank, 'yEnemy', yEnemy, 'yTank', yTank);
scorchExGen(20,0.1,0.5,0.7,conditions);
clear;