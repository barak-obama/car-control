function [ organism ] = roulette( str )
s = sum(str.f);
r = rand;
c = 0;
for i=1:length(str.f)
    if(r>=c&&r<(c+(str.f(i)/s)))
        organism = str.p(:,i);
        break;
    end
    c = c+(str.f(i)/s);
end
end

