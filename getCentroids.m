function [centroid_idx, section, xmin, ymin] = getCentroids(PixelList,PixelIdxList,image)
% PixelList: x y coordinates
xmin = min(PixelList(:,1));
xmax = max(PixelList(:,1));
ymin = min(PixelList(:,2));
ymax = max(PixelList(:,2));

%Ausschnitt mit Nullran: zeros(ymax-ymin+1+4,xmax-xmin+1+4); (in jede
%Richtung eins mehr: oben+unten--> [y] + 4, rechts + links --> x + [4]
section = zeros(ymax-ymin+5,xmax-xmin+5);
coordTemp = PixelList;
coordTemp(:,1) = coordTemp(:,1) - xmin +3;
coordTemp(:,2) = coordTemp(:,2) - ymin +3;
sz = size(section);
linTemp = sub2ind(sz,coordTemp(:,2),coordTemp(:,1)); %!! attention: x is column, y is row

section(linTemp) = image(PixelIdxList);
%dilatate
SE = strel('disk',3,0);
secDil = imdilate(section,SE);

maxima = (section-secDil == 0) + (section ~= 0);
centroid_idx = find(maxima == 2);

end