function selfSvcTime = selfServiceTime(RandSelfServiceTimesDist)
    selfSvcTime = RandSelfServiceTimesDist(randi(length(RandSelfServiceTimesDist)));
    if selfSvcTime < 1
        selfSvcTime = 1;
    end
end