function numItems = numberOfItems(RandItemsDist)
    numItems = ceil(RandItemsDist(randi(length(RandItemsDist))));
    if numItems < 1
        numItems = 1;
    end
end