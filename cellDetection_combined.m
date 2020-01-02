function [regionList] = cellDetection_combined(image)
close all
%% prefilter to reduce peak noise
h = fspecial('average',3);    % Moving average - Filter
filtered = imfilter(image,h);
filtered = imclearborder(filtered);

%% Edge detection
[~,threshold] = edge(filtered,'sobel');

BW = edge(filtered,'sobel',threshold);

figure ('Name','after Smoothing and Normalization')
imshow(filtered,'DisplayRange',[min(image(:)) max(image(:))])
%
%visualize detection
vis_cells(filtered,BW,'after edge filtering')

%dilate
SE = strel('disk',1,0);
BWdil = imdilate(BW,SE);

%fill holes
BWfill = imfill(BWdil,4,'holes');

%reduce synapses size
%BWred = imerode(BWfill,SE);

% %normalize
% maxi = max(filtered(:));
% mini = min(filtered(:));
% filteredNorm= (image-mini)/(maxi-mini);

vis_cells(filtered,BWfill,'after dilatation and flood filling');

%clean image (max size = 3 pixels)
RegProp = regionprops(BWfill, 'PixelIdxList', 'PixelList', 'Area','Perimeter');       

% delete small regions;
RegPropNew = RegProp;
RegPropNew([RegProp.Area] <= 16) = [];

BWcleared = zeros(size(BW));
nRoi = length(RegPropNew);
for roi = 1:nRoi
    BWcleared(RegPropNew(roi).PixelIdxList) = 1;
end

BWcleared = imbinarize(BWcleared);
vis_cells(filtered,BWcleared,'after clearing');

%particle refinement
N = length(RegProp)*10;
regionList = repmat(struct('PixelIdxList',[]),1,N);
counter = 1;
unchanged = 0;
for roi = 1:nRoi
    %
    sprintf('%i _start',roi)
    if RegPropNew(roi).Area >= 40
        region = RegPropNew(roi).PixelList;
        idx = RegPropNew(roi).PixelIdxList;
        [centroids, section, xmin, ymin] = getCentroids(region,idx,filtered);
        [idxList, numbC] = getSingles(centroids, section);
        idxListtrans = idxList;
        idxList = coordTrans(idxListtrans, size(section),size(BWfill), xmin, ymin);
        [counter, regionList] = precising(regionList,idxList,numbC, size(BWfill), counter);
    else
        regionList(counter).PixelIdxList = RegPropNew(roi).PixelIdxList;
        regionList(counter).Area = length(RegPropNew(roi).PixelList);
        regionList(counter).PixelList = RegPropNew(roi).PixelList;
        counter = counter + 1;
        unchanged = unchanged + 1;
        regionList(counter-1).unchanged = 1;
    end
    
end
regionList = regionList(1:counter-1);

BW_watershed = zeros(size(BW));

%nRoi = length(RegPropNew);
nRoi = length(regionList);
for roi = 1:nRoi
    BW_watershed (regionList(roi).PixelIdxList) = 1;
end
BW_watershed = imbinarize(BW_watershed);
BW_watershed = imfill(BW_watershed,4,'holes');

regionStats = regionprops(BW_watershed, 'PixelIdxList', 'PixelList', 'Area','Perimeter');
regionStats([regionStats.Area] <= 9) = [];

BW_ws_cleared = zeros(size(BW));
nRoi = length(regionStats);
for roi = 1:nRoi
    BW_ws_cleared (regionStats(roi).PixelIdxList) = 1;
end

vis_cells(image,BW_ws_cleared,'after watershed');

end

