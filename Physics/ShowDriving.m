function ShowDriving( str, net, maxNum, dt )
figure;
displayCarControlMap(str,1);
for i=1:maxNum
    for j=1:max(size(str.cars))
        netAns = net(getreality(str.cars{j})');
        [str, canContinue] = updatereality(str,str.cars{j},netAns(1),netAns(2),dt,4*pi/10);
        clf
        displayCarControlMap(str,1);
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