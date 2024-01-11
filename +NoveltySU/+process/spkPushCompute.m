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
    spkPush.(cwStr(cwIdx))(dIndex).devType = devType(dIndex);
    spkPush.(cwStr(cwIdx))(dIndex).trials = find(tIndex)';
    spkPush.(cwStr(cwIdx))(dIndex).trialNum = sum(tIndex);
    spkPush.(cwStr(cwIdx))(dIndex).pushLatency = [trialAll(tIndex).pushLatency]';
    if ~isempty(trialsSPK)
        temp = cell2mat(struct2cell(trialsSPK)');
        spkPush.(cwStr(cwIdx))(dIndex).frRaw_Early = cell2mat(cellfun(@(x) x(end), {trials.fr_Early}', "UniformOutput", false));
        spkPush.(cwStr(cwIdx))(dIndex).frRaw_Late = cell2mat(cellfun(@(x) x(end), {trials.fr_Late}', "UniformOutput", false));
    else
        temp = [-6000, 1];
        spkPush.(cwStr(cwIdx))(dIndex).frRaw_Early = 0;
        spkPush.(cwStr(cwIdx))(dIndex).frRaw_Late = 0;
    end
    spkPush.(cwStr(cwIdx))(dIndex).spikePlot = temp;
    spkPush.(cwStr(cwIdx))(dIndex).spikePlotOrdered = NoveltySU.utils.reOrderSpikePlot(temp);
    spkPush.(cwStr(cwIdx))(dIndex).PSTH = calPsth(temp(:, 1), psthPara, 1e3, 'EDGE', Window-5000, 'NTRIAL', sum(tIndex));
    spkPush.(cwStr(cwIdx))(dIndex).pushPSTH = calPsth([trialAll(tIndex).pushLatency]', psthPushPara, psthPushPara.binsize, 'EDGE', [200, 600]);
    spkPush.(cwStr(cwIdx))(dIndex).trialNum = sum(tIndex);
    spkPush.(cwStr(cwIdx))(dIndex).frMean_Early = mean(spkPush.(cwStr(cwIdx))(dIndex).frRaw_Early);
    spkPush.(cwStr(cwIdx))(dIndex).frSE_Early = SE(spkPush.(cwStr(cwIdx))(dIndex).frRaw_Early);
    spkPush.(cwStr(cwIdx))(dIndex).frMean_Late = mean(spkPush.(cwStr(cwIdx))(dIndex).frRaw_Late);
    spkPush.(cwStr(cwIdx))(dIndex).frSE_Late = SE(spkPush.(cwStr(cwIdx))(dIndex).frRaw_Late);

end