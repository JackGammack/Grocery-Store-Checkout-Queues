function arvTime = arrivalTime(arvTimesDist)
    arvTime = arvTimesDist(randi(length(arvTimesDist)));
    if arvTime < 0
        arvTime = 0;
    end
end