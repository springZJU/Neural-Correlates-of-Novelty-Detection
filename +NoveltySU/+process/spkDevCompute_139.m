psthPara.binsize = 50; psthPara.binstep = 5; % ms
psthPushPara.binsize = 50; psthPushPara.binstep = 5; % ms
cwStr = ["correct", "wrong", "all"];
trialAllTemp = trialByStd(sIndex).trialAll;
trialSel = trialByStd(sIndex).trialSel;
for cwIdx = 1 : length(cwStr)
    switch cwStr(cwIdx)
        case "correct"
            %% (cwStr(cwIdx))
            if dIndex == 1
                tIndex = [trialAllTemp.devFreq] == devType(dIndex) & [trialAllTemp.correct] & [trialAllTemp.oddballType] == "STD";
            else
                tIndex = [trialAllTemp.devFreq] == devType(dIndex) & [trialAllTemp.correct] & [trialAllTemp.oddballType] == "DEV";
            end
        case "wrong"
            if dIndex == 1
                tIndex = [trialAllTemp.devFreq] == devType(dIndex) & ~[trialAllTemp.correct] & [trialAllTemp.oddballType] == "STD";
            else
                tIndex = [trialAllTemp.devFreq] == devType(dIndex) & ~[trialAllTemp.correct] & [trialAllTemp.oddballType] == "DEV";
            end
        case "all"
            tIndex = [trialAllTemp.devFreq] == devType(dIndex);

    end
    trials = trialAllTemp(tIndex);
    trialsSPK = trialsSpike(trialSel(tIndex));
    % spike
    spkDev(sIndex).(cwStr(cwIdx))(dIndex).devType = devType(dIndex);
    spkDev(sIndex).(cwStr(cwIdx))(dIndex).trials = trialSel((tIndex));
    spkDev(sIndex).(cwStr(cwIdx))(dIndex).trialNum = sum(tIndex);
    spkDev(sIndex).(cwStr(cwIdx))(dIndex).pushLatency = [trialAllTemp(tIndex).pushLatency]';
    if ~isempty(trialsSPK)
        temp = cell2mat(cellfun(@(x, y) [x(:, 1) - y(end) + y(1), x(:, 2)], struct2cell(trialsSPK)', {trials.soundOnsetSeq}', "UniformOutput", false));
        spkDev(sIndex).(cwStr(cwIdx))(dIndex).frRaw_Early = cell2mat(cellfun(@(x) x(end), {trials.fr_Early}', "UniformOutput", false));
        spkDev(sIndex).(cwStr(cwIdx))(dIndex).frRaw_Late = cell2mat(cellfun(@(x) x(end), {trials.fr_Late}', "UniformOutput", false));
    else
        temp = [-6000, 1];
        spkDev(sIndex).(cwStr(cwIdx))(dIndex).frRaw_Early = 0;
        spkDev(sIndex).(cwStr(cwIdx))(dIndex).frRaw_Late = 0;
    end
    spkDev(sIndex).(cwStr(cwIdx))(dIndex).spikePlot = temp;
    spkDev(sIndex).(cwStr(cwIdx))(dIndex).spikePlotOrdered = NoveltySU.utils.reOrderSpikePlot(temp);
    spkDev(sIndex).(cwStr(cwIdx))(dIndex).PSTH = calPsth(temp(:, 1), psthPara, 1e3, 'EDGE', Window-5000, 'NTRIAL', sum(tIndex));
    spkDev(sIndex).(cwStr(cwIdx))(dIndex).pushPSTH = calPsth([trialAllTemp(tIndex).pushLatency]', psthPushPara, psthPushPara.binsize, 'EDGE', [200, 600]);
    spkDev(sIndex).(cwStr(cwIdx))(dIndex).trialNum = sum(tIndex);
    spkDev(sIndex).(cwStr(cwIdx))(dIndex).frMean_Early = mean(spkDev(sIndex).(cwStr(cwIdx))(dIndex).frRaw_Early);
    spkDev(sIndex).(cwStr(cwIdx))(dIndex).frSE_Early = SE(spkDev(sIndex).(cwStr(cwIdx))(dIndex).frRaw_Early);
    spkDev(sIndex).(cwStr(cwIdx))(dIndex).frMean_Late = mean(spkDev(sIndex).(cwStr(cwIdx))(dIndex).frRaw_Late);
    spkDev(sIndex).(cwStr(cwIdx))(dIndex).frSE_Late = SE(spkDev(sIndex).(cwStr(cwIdx))(dIndex).frRaw_Late);

end