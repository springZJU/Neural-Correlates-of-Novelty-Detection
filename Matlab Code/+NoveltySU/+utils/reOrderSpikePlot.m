function spikePlot = reOrderSpikePlot(spikePlot)
trialNum = unique(spikePlot(:, 2));
for tIndex = 1 : length(trialNum)
    spikePlot(spikePlot(:, 2) == trialNum(tIndex), 2) = tIndex;
end
end