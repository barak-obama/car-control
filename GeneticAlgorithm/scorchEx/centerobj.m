function centerobj(h)
%CENTEROBJ Center an user interface object on screen.
%   CENTEROBJ(H) centers the specified object within its parent object by
%   altering its 'position' attribute. H should be a handle to an object
%   with a 'position' attribute.

%  Ron Rubinstein
%  Computer Science Department
%  Technion, Haifa 32000 Israel
%  ronrubin@cs.technion.ac.il
%
%  September 2010


u = get(h,'Units');

set(h,'Units','normalized');
p = get(h,'Position');
p(1:2) = 0.5-p(3:4)/2;
set(h,'Position',p);

set(h,'Units',u);

end
