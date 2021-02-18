function expSvcTime = expressServiceTime(svcTimesDist)
    expSvcTime = svcTimesDist(randi(length(svcTimesDist)));
    if expSvcTime < 1
        expSvcTime = 1;
    end
end