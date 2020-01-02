function [ListOfAll, nC] = getSingles(centroids, section)

ListOfAll = find(section ~= 0);
ListOfAll = [ListOfAll zeros(length(ListOfAll),1)];
nC = length(centroids);
%markers = 1:nC;
W = nC +1; %Abgrenzung

%% initialize the dynamic lists
dynList = zeros(length(ListOfAll),2,nC); % pixelID,pixel_value,numberOfCentroids
for c = 1:nC
    %create the initial dynamic list
    ListOfAll((ListOfAll(:,1)==centroids(c)),2) = c;
    neighbors = getNeighbors(section,centroids(c),1);
    dynList(1:length(neighbors),1,c) = neighbors;  %pixelIDList
    dynList(1:length(neighbors),2,c) = section(neighbors); %pixelValue
    dynList(:,:,c) = sortrows(dynList(:,:,c),2,'descend');
end

%% start the algorithm
while ~all(ListOfAll(:,2))
    left = length(ListOfAll) - nnz(ListOfAll(:,2));
   % sprintf('%i left',left)
    for c = 1:nC
        point = dynList(1,1,c);
        
        n_old = sort(dynList(1:nnz(dynList(:,1,c)),1,c));
        n_old(n_old == point) = []; %current point is deleted from List
        
        n = getNeighbors(section,point,1);        
              
        
        %check if there are borderpixel
        n_check = n; 
        borders = ~ismember(n_check,ListOfAll(:,1));
        if sum(borders) ~= 0
            n(borders) = [];
            ListOfAll((ListOfAll(:,1) == point),2) = W;
        else
            % ckeck the neighbors
            marks = ListOfAll(ismember(ListOfAll(:,1),n_check),2);
            %otherMarks = markers(markers ~= c);
            label = sum(marks(marks ~= c & marks ~= 0 & marks ~= W));
            if label == 0
                ListOfAll((ListOfAll(:,1) == point),2) = c;
            else
                ListOfAll((ListOfAll(:,1) == point),2) = W;
            end
        end
        
        %refresh dynamic List
        
        % clean list of new points
        replicates = ~ismember(n, n_old);
        n = n(replicates);        
        already = ListOfAll((ListOfAll(:,2) ~= 0),1);
        n(ismember(n, already)) = [];
        
        n_temp = [n_old; n];
        dynList(1:length(n_temp),1,c) = n_temp;  %pixelIDList
        dynList(1:length(n_temp),2,c) = section(n_temp); %pixelValue
        dynList(:,:,c) = sortrows(dynList(:,:,c),2,'descend');       
        
    end
end
end
        

