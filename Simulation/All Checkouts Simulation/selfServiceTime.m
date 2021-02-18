function selfSvcTime = selfServiceTime(svcTimesDist)
    selfSvcTime = svcTimesDist(randi(length(svcTimesDist)));
    if selfSvcTime < 1
        selfSvcTime = 1;
    end
end