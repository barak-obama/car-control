load('C:\Users\jonir_000\Documents\MATLAB\car-control\TrainedNets\TrainingData.mat');
for k=1:1000
	k
	DefaultMap;
	for i=1:maxNum
        for j=1:max(size(str.cars))
            netAns = net(getreality(str.cars{j})');
            [str, canContinue] = updatereality(str,str.cars{j},netAns(1),netAns(2),dt,pi);
            if ~canContinue
            	break;
            end
        end
        if ~canContinue
        	break;
        end
        pause(dt/20);
	end
end