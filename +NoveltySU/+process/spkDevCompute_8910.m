trialAllTemp = trialAll(ismember(cellfun(@length, {trialAll.soundOnsetSeq}'), [8, 9, 10]));
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
                tIndex = [trialAllTemp.(devStr)] == devType(dIndex) & [trialAllTemp.correct] & [trialAllTemp.oddballType] == "STD";
            else
                tIndex = [trialAllTemp.(devStr)] == devType(dIndex) & [trialAllTemp.correct] & [trialAllTemp.oddballType] == "DEV";
            end
        case "wrong"
            if dIndex == 1
                tIndex = [trialAllTemp.(devStr)] == devType(dIndex) & ~[trialAllTemp.correct] & [trialAllTemp.oddballType] == "STD";
            else
                tIndex = [trialAllTemp.(devStr)] == devType(dIndex) & ~[trialAllTemp.correct] & [trialAllTemp.oddballType] == "DEV";
            end
        case "all"
            tIndex = [trialAllTemp.(devStr)] == devType(dIndex);

    end
    trials = trialAllTemp(tIndex);
    trialsSPK = trialsSpike(tIndex);
    % spike
    spkDev_8910.(cwStr(cwIdx))(dIndex).devType = devType(dIndex);
    spkDev_8910.(cwStr(cwIdx))(dIndex).trials = find(tIndex)';
    spkDev_8910.(cwStr(cwIdx))(dIndex).trialNum = sum(tIndex);
    spkDev_8910.(cwStr(cwIdx))(dIndex).pushLatency = [trialAllTemp(tIndex).pushLatency]';
    if ~isempty(trialsSPK)
        temp = cell2mat(cellfun(@(x, y) [x(:, 1) - y(end) + y(1), x(:, 2)], struct2cell(trialsSPK)', {trials.soundOnsetSeq}', "UniformOutput", false));
        spkDev_8910.(cwStr(cwIdx))(dIndex).frRaw_Early = cell2mat(cellfun(@(x) x(end), {trials.fr_Early}', "UniformOutput", false));
        spkDev_8910.(cwStr(cwIdx))(dIndex).frRaw_Late = cell2mat(cellfun(@(x) x(end), {trials.fr_Late}', "UniformOutput", false));
    else
        temp = [-6000, 1];
        spkDev_8910.(cwStr(cwIdx))(dIndex).frRaw_Early = 0;
        spkDev_8910.(cwStr(cwIdx))(dIndex).frRaw_Late = 0;
    end
    spkDev_8910.(cwStr(cwIdx))(dIndex).spikePlot = temp;
    spkDev_8910.(cwStr(cwIdx))(dIndex).spikePlotOrdered = NoveltySU.utils.reOrderSpikePlot(temp);
    spkDev_8910.(cwStr(cwIdx))(dIndex).PSTH = calPsth(temp(:, 1), psthPara, 1e3, 'EDGE', Window-5000, 'NTRIAL', sum(tIndex));
    spkDev_8910.(cwStr(cwIdx))(dIndex).pushPSTH = calPsth([trialAllTemp(tIndex).pushLatency]', psthPushPara, psthPushPara.binsize, 'EDGE', [200, 600]);
    spkDev_8910.(cwStr(cwIdx))(dIndex).trialNum = sum(tIndex);
    spkDev_8910.(cwStr(cwIdx))(dIndex).frMean_Early = mean(spkDev_8910.(cwStr(cwIdx))(dIndex).frRaw_Early);
    spkDev_8910.(cwStr(cwIdx))(dIndex).frSE_Early = SE(spkDev_8910.(cwStr(cwIdx))(dIndex).frRaw_Early);
    spkDev_8910.(cwStr(cwIdx))(dIndex).frMean_Late = mean(spkDev_8910.(cwStr(cwIdx))(dIndex).frRaw_Late);
    spkDev_8910.(cwStr(cwIdx))(dIndex).frSE_Late = SE(spkDev_8910.(cwStr(cwIdx))(dIndex).frRaw_Late);

end