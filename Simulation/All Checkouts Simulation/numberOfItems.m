function numItems = numberOfItems(itmsDist)
    numItems = ceil(itmsDist(randi(length(itmsDist))));
    if numItems < 1
        numItems = 1;
    end
end