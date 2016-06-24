net = fitnet([30,30,30]);

net.trainFcn = 'traincgf';
net.performFcn = 'sse';
net.trainParam.max_fail = 30;
net.inputConnect = ones(4,1);
net.divideFcn = 'dividetrain';
net.trainParam.epochs = 250;
net.trainParam.showWindow = 0;


net = train(net, X, T);

good = 1;
for k=1:size(D,2)
    k
    crash = ShowDriving(D{k}, net, 3000, 0.1);
    close all
    if crash
        display('dead');
        good=0;
        break;
        
    end
end