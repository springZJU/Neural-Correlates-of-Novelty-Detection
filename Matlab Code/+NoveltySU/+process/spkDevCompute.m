psthPara.binsize = 50; psthPara.binstep = 5; % ms
psthPushPara.binsize = 50; psthPushPara.binstep = 5; % ms
cwStr = ["correct", "wrong", "all"];
if contains(protStr, "Freq")
    devStr = "devFreq";
elseif contains(protStr, "Int")
    devStr = "devInt";
end
for cwIdx = 1 : length(cwStr)
    switch cwStr(cwIdx)
        case "correct"
            %% (cwStr(cwIdx))
            if dIndex == 1
                tIndex = [trialAll.(devStr)] == devType(dIndex) & [trialAll.correct] & [trialAll.oddballType] == "STD";
            else
                tIndex = [trialAll.(devStr)] == devType(dIndex) & [trialAll.correct] & [trialAll.oddballType] == "DEV";
            end
        case "wrong"
            if dIndex == 1
                tIndex = [trialAll.(devStr)] == devType(dIndex) & ~[trialAll.correct] & [trialAll.oddballType] == "STD";
            else
                tIndex = [trialAll.(devStr)] == devType(dIndex) & ~[trialAll.correct] & [trialAll.oddballType] == "DEV";
            end
        case "all"
            tIndex = [trialAll.(devStr)] == devType(dIndex);

    end
    trials = trialAll(tIndex);
    trialsSPK = trialsSpike(tIndex);
    % spike
    spkDev.(cwStr(cwIdx))(dIndex).devType = devType(dIndex);
    spkDev.(cwStr(cwIdx))(dIndex).trials = find(tIndex)';
    spkDev.(cwStr(cwIdx))(dIndex).trialNum = sum(tIndex);
    spkDev.(cwStr(cwIdx))(dIndex).pushLatency = [trialAll(tIndex).pushLatency]';
    if ~isempty(trialsSPK)
        temp = cell2mat(cellfun(@(x, y) [x(:, 1) - y(end) + y(1), x(:, 2)], struct2cell(trialsSPK)', {trials.soundOnsetSeq}', "UniformOutput", false));
        spkDev.(cwStr(cwIdx))(dIndex).frRaw_Early = cell2mat(cellfun(@(x) x(end), {trials.fr_Early}', "UniformOutput", false));
        spkDev.(cwStr(cwIdx))(dIndex).frRaw_Late = cell2mat(cellfun(@(x) x(end), {trials.fr_Late}', "UniformOutput", false));
    else
        temp = [-6000, 1];
        spkDev.(cwStr(cwIdx))(dIndex).frRaw_Early = 0;
        spkDev.(cwStr(cwIdx))(dIndex).frRaw_Late = 0;
    end
    spkDev.(cwStr(cwIdx))(dIndex).spikePlot = temp;
    spkDev.(cwStr(cwIdx))(dIndex).spikePlotOrdered = NoveltySU.utils.reOrderSpikePlot(temp);
    spkDev.(cwStr(cwIdx))(dIndex).PSTH = calPsth(temp(:, 1), psthPara, 1e3, 'EDGE', Window-5000, 'NTRIAL', sum(tIndex));
    spkDev.(cwStr(cwIdx))(dIndex).pushPSTH = calPsth([trialAll(tIndex).pushLatency]', psthPushPara, psthPushPara.binsize, 'EDGE', [200, 600]);
    spkDev.(cwStr(cwIdx))(dIndex).trialNum = sum(tIndex);
    spkDev.(cwStr(cwIdx))(dIndex).frMean_Early = mean(spkDev.(cwStr(cwIdx))(dIndex).frRaw_Early);
    spkDev.(cwStr(cwIdx))(dIndex).frSE_Early = SE(spkDev.(cwStr(cwIdx))(dIndex).frRaw_Early);
    spkDev.(cwStr(cwIdx))(dIndex).frMean_Late = mean(spkDev.(cwStr(cwIdx))(dIndex).frRaw_Late);
    spkDev.(cwStr(cwIdx))(dIndex).frSE_Late = SE(spkDev.(cwStr(cwIdx))(dIndex).frRaw_Late);

end