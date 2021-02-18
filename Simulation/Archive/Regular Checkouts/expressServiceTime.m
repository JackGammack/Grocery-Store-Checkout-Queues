function expSvcTime = expressServiceTime(RandExpressServiceTimesDist)
    expSvcTime = RandExpressServiceTimesDist(randi(length(RandExpressServiceTimesDist)));
    if expSvcTime < 1
        expSvcTime = 1;
    end
end