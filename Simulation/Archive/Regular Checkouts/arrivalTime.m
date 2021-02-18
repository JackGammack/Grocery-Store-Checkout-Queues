function arvTime = arrivalTime(RandArrivalTimesDist)
    arvTime = RandArrivalTimesDist(randi(length(RandArrivalTimesDist)));
    if arvTime < 0
        arvTime = 0;
    end
end