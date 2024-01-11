function timeLag = timeLagCalculation(PlotData,timeLagPlotPara)
AUCPercent = 0.5;
eval([GetStructStr(timeLagPlotPara) '=ReadStructValue(timeLagPlotPara);']);
cue_types = unique(fields(PlotData.SpikeAnalysis.SpikePsth));


for cueN = 1:length(cue_types)
    psthBuffer = PlotData.SpikeAnalysis.SpikePsth.(cue_types{cueN});
    for devDiff = 1:length({psthBuffer.(alignment)})
        if devDiff == 1
            fullPsthBuffer = psthBuffer(devDiff).(alignment).Wrong;
        else
            fullPsthBuffer = psthBuffer(devDiff).(alignment).Correct;
        end
% timeLag of behavioral responses
        behavPsthBuffer = psthBuffer(devDiff).behavRes;
        if ~isempty([behavPsthBuffer.y])
        edges = [behavPsthBuffer.edges]';
        timePoints = edges(:,3);
        timePointsIdx = find(timePoints >= win(1) & timePoints <= win(2));
        localPsthBuffer = [[behavPsthBuffer(timePointsIdx).y]' timePoints(timePointsIdx)];
        for n = 1:size(localPsthBuffer,1)
            timeLagBuffer(n,1) = sum(localPsthBuffer(1:n,1));
        end
        [~,timeLagIdx] = min(abs(timeLagBuffer-AUCPercent*timeLagBuffer(end)));
        timeLag.(cue_types{cueN})(devDiff).behavRes = localPsthBuffer(timeLagIdx,2);
        else
            timeLag.(cue_types{cueN})(devDiff).behavRes = [];
        end



% timeLag of neuronal responses
        if ~isempty([fullPsthBuffer.y])
        edges = [fullPsthBuffer.edges]';
        timePoints = edges(:,3);
        timePointsIdx = find(timePoints >= win(1) & timePoints <= win(2));
        localPsthBuffer = [[fullPsthBuffer(timePointsIdx).y]' timePoints(timePointsIdx)];
        for n = 1:size(localPsthBuffer,1)
            timeLagBuffer(n,1) = sum(localPsthBuffer(1:n,1));
        end
        [~,timeLagIdx] = min(abs(timeLagBuffer-AUCPercent*timeLagBuffer(end)));
        timeLag.(cue_types{cueN})(devDiff).neuralRes = localPsthBuffer(timeLagIdx,2);
        else
            timeLag.(cue_types{cueN})(devDiff).neuralRes = [];
        end
    end
end


