function [ net ] = netFromChromo( a, ind, net )
layers = net.layers(1:end-1);
lay = zeros(size(layers));
for i=1:length(layers)
   lay(i) = layers{i}.size;
end
layers = lay;
%putting new values
IW = [];
for i=1:layers(1)
    IW = [IW,a(ind(i)+1:ind(i+1))];
end
net.IW{1,1} = IW';
count = 0;
for i=2:length(layers)
    LW = [];
    for j=1:layers(i)
        LW = [LW,a(ind(layers(1)+j+count)+1:ind(layers(1)+j+1+count))];
    end
    net.LW{i,i-1} = LW';
    count = count + layers(i);
    net.b{i-1} = a(ind(sum(layers)+i-2)+1:ind(sum(layers)+i-1));
end
net.b{end-1} = a(ind(end-2)+1:ind(end-1));
net.b{end} = a(ind(end-1)+1:end);
end