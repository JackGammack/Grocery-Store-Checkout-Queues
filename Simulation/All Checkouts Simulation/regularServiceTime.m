function regSvcTime = regularServiceTime(svcTimesDist)
    regSvcTime = svcTimesDist(randi(length(svcTimesDist)));
    if regSvcTime < 1
        regSvcTime = 1;
    end
end