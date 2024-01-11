function valueDist = generateDistribution(popRes, value)
for pIndex = 1 : length(popRes)
    if strcmpi(value, "thr")
        valueDist(popRes(pIndex).APPos, popRes(pIndex).LRPos) = popRes(pIndex).collectRes.neuThr_Late;
    elseif strcmpi(value, "DRP")
        valueDist(popRes(pIndex).APPos, popRes(pIndex).LRPos) = popRes(pIndex).collectRes.DP(6, 2);
    end
end
end