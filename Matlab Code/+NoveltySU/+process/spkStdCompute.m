psthPara.binsize = 50; psthPara.binstep = 5; % ms

tIndex = [trialAll.stdNum] == stdType(sIndex) & [trialAll.oddballType] == "DEV";
trials = trialAll(tIndex);
trialsSPK = trialsSpike(tIndex);
% spike
spkStd(sIndex).stdNum = stdType(sIndex);
spkStd(sIndex).trials = find(tIndex)';
spkStd(sIndex).trialNum = sum(tIndex);
temp = cell2mat(struct2cell(trialsSPK)');
spkStd(sIndex).spikePlot = NoveltySU.utils.reOrderSpikePlot(temp);
spkStd(sIndex).PSTH = calPsth(temp(:, 1), psthPara, 1e3, 'EDGE', Window, 'NTRIAL', sum(tIndex));
spkStd(sIndex).trialNum = sum(tIndex);
spkStd(sIndex).frRaw_Early = cell2mat(cellfun(@(x) x(1 : end-1), {trials.fr_Early}', "UniformOutput", false));
spkStd(sIndex).frMean_Early = mean(spkStd(sIndex).frRaw_Early, 1);
spkStd(sIndex).frSE_Early = SE(spkStd(sIndex).frRaw_Early, 1);
spkStd(sIndex).frRaw_Late = cell2mat(cellfun(@(x) x(1 : end-1), {trials.fr_Late}', "UniformOutput", false));
spkStd(sIndex).frMean_Late = mean(spkStd(sIndex).frRaw_Late, 1);
spkStd(sIndex).frSE_Late = SE(spkStd(sIndex).frRaw_Late, 1);
