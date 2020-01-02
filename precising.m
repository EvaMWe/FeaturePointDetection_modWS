function[counter, regList] = precising(regList,ListOfAll,numbC, sizImg, counter)

for n = 1:numbC
    area = ListOfAll((ListOfAll(:,2) == n),1);
    regList(counter).PixelIdxList = area;
    regList(counter).Area = length(area);
    [r,c] = ind2sub(sizImg,area);    
    regList(counter).PixelList = [r c];
    counter = counter+1;
end
end