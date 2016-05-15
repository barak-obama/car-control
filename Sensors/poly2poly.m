function X = poly2poly( P1, P2 )
X = [];
for i=2:size(P1,2)
    X = [X, seg2poly([P1(:,i), P1(:,i-1)],P2)];
end
end

