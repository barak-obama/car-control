function [ curr ] = enemyFunc( prev, me )
if isempty(prev)
    curr = 0;
else
    curr = prev(end);
end
end

