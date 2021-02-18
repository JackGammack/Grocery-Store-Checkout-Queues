function regSvcTime = regularServiceTime(RandRegularServiceTimesDist)
    regSvcTime = RandRegularServiceTimesDist(randi(length(RandRegularServiceTimesDist)));
    if regSvcTime < 1
        regSvcTime = 1;
    end
end