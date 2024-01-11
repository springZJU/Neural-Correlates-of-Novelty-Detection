ccc
ROOTPATH = strcat(getRootDirPath(mfilename("fullpath"), 4), "Data\ProcessData\");
protStr = "ActiveFreqRight";
temp = dirItem(strcat(ROOTPATH, protStr), "spkData.mat");
popRes = cell2mat(cellfun(@(x) NoveltySU.population.loadPopData(x), temp.file, "UniformOutput", false));
popRes = addFieldToStruct(popRes, repmat(cellstr(protStr), length(popRes), 1), "protStr");

%% select data
% CM cell32
selectRes = popRes(matches({popRes.Date}', "CM_20200706_A49L19cell32"));
spkDev = selectRes.spkDev;
devType = [selectRes.spkDev.all.devType]';
devStr = cellfun(@(x) num2str(roundn(x, -2)), num2cell(devType(2:5)/devType(1)), "UniformOutput", false);
pushRatio = selectRes.behavThrRes.behavRes;
lanmuda = devType / devType(1);
diffSel = 2;

%% Fig2
Fig = figure;
set(Fig, "Position", [486.6   41.8  488.8  741.6]);
%Fig2a
subplot(5, 2, 1)
behavThrRes.behavRes = selectRes.behavThrRes.behavRes;
Fig2.a.devType = devType;
Fig2.a.pushRatio = pushRatio;
Fig2.a.behavFit = mPFit([lanmuda, pushRatio], "xFit", 1:0.01:lanmuda(end));
plot(Fig2.a.behavFit.xFit, Fig2.a.behavFit.yFit, "k-", "LineWidth", 2); hold on
scatter(Fig2.a.devType ./ Fig2.a.devType(1) , Fig2.a.pushRatio, 40, "black"); hold on

xlim([1, 1.5]);
ylim([0, 1]);
xlabel("Frequency Ratio(dev/std)");
ylabel("Ratio of Pressing Button");
title("behavior");

% Fig2b
subplot(5, 2, 2)
Fig2.b.trialNum = num2cell([[0; cumsum([spkDev.correct(2:end-1).trialNum]')]+1, cumsum([spkDev.correct(2:end).trialNum]')], 2);
Fig2.b.meanPush = cell2mat(cellfun(@(x) mean(x), {spkDev.correct(2:end).pushLatency}', "UniformOutput", false));
Fig2.b.pushPlot = cell2mat(cellfun(@(x, y) [x, (y(1):y(2))'], {spkDev.correct(2:end).pushLatency}', Fig2.b.trialNum, "UniformOutput", false));
Fig2.b.yLine = [0; cumsum([spkDev.correct(2:end-1).trialNum]')];
temp = [0; cumsum([spkDev.correct(2:end).trialNum]')];
Fig2.b.yTick = mean([temp(1:end-1), temp(2:end)], 2);
Fig2.b.yTickLabel = string(devStr);
scatter(Fig2.b.pushPlot(:, 1), Fig2.b.pushPlot(:, 2), 3, 'red', 'filled'); hold on;
plot([0, 1000], repmat(Fig2.b.yLine, 1, 2), "k-", "LineWidth", 1); hold on;
cellfun(@(x, y) NoveltySU.plot.multiPlot(gca, [x, x], y, "k"), num2cell(Fig2.b.meanPush), Fig2.b.trialNum, "UniformOutput", false);
yticks(Fig2.b.yTick);
yticklabels(Fig2.b.yTickLabel);
xlim([0, 600]);
ylim([0, max(Fig2.b.pushPlot(:, 2))]);
title("devOnset Push Plot");
ylabel("Frequancy Ratio (dev/std)");
xlabel("Time (ms)");

% Fig2c
subplot(5, 2, [3 4])
Date = string(selectRes.Date);
ORIGINPATH = strrep(ROOTPATH, "ProcessData", "OriginData\ToneCF\");
TONEPATH = strcat(ORIGINPATH, Date, "\spkData.mat");
Fig2.c.TONEPATH = TONEPATH;
FigFRA = NoveltySU.FRA.FRA_Example(TONEPATH, "off");
Fig2.c.FR = FigFRA.Children(2).Children.CData;
image(Fig2.c.FR, 'CDataMapping', 'scaled');
yticks(10:10:70);
yticklabels(cellfun(@(x) num2str(x), num2cell(10:10:70), "uni", false));
xticks(1:2:25);
freq = roundn(log10(logspace(0.200, 19.079, 13)), -1);
xticklabels(cellfun(@(x) num2str(x), num2cell(freq), "UniformOutput", false));

ylabel("SPL(dB)");
colorbar;

% Fig2d
subplot(5, 2, [5, 6])
spkStd = selectRes.spkStd;
idx = spkDev.all(diffSel).trials;
stdDevLag = [selectRes.trialAll(idx).devOnset]' - cell2mat(cellfun(@(x) x(1), {selectRes.trialAll(idx).soundOnsetSeq}', "UniformOutput", false));
selectNum = num2cell(idx);
Fig2.d.spikePlotDev = spkDev.all(diffSel).spikePlot;
temp = cellfun(@(x) Fig2.d.spikePlotDev(Fig2.d.spikePlotDev(:, 2) == x, :), selectNum, "UniformOutput", false);
Fig2.d.spikePlotStd = cell2mat(cellfun(@(x, y, z) findWithinInterval([x(:, 1)+y-3500, z*ones(size(x, 1), 1)], [-4000, -100], 1), temp, num2cell(stdDevLag), num2cell(1:length(temp))', "UniformOutput", false));
Fig2.d.spikePlotDev = cell2mat(cellfun(@(x, y) findWithinInterval([x(:, 1), y*ones(size(x, 1), 1)], [0, 1000], 1), temp, num2cell(1:length(temp))', "UniformOutput", false));

scatter(Fig2.d.spikePlotStd(:, 1), Fig2.d.spikePlotStd(:, 2), 3, 'black', 'filled'); hold on;
scatter(Fig2.d.spikePlotDev(:, 1), Fig2.d.spikePlotDev(:, 2), 3, 'red', 'filled'); hold on;
xlim([-3600, 1000]);
xticks(-3500:500:1000);
xticklabels(cellfun(@(x) num2str(x), num2cell([0:500:3000, 0:500:1000]), "UniformOutput", false));
title("dev/std = 1.21");
ylabel("Frequancy Ratio (dev/std)");
xlabel("Time (ms)");

% Fig2e
subplot(5, 2, 7)
pushFR = cellfun(@(x) [x, ones(length(x), 1)], {spkDev.correct(2:end).frRaw_Late}', "UniformOutput", false);
nopushFR = cellfun(@(x) [x, zeros(length(x), 1)], {spkDev.wrong(2:end).frRaw_Late}', "UniformOutput", false);
fr_Raw = cellfun(@(x, y) [x; y], pushFR, nopushFR, "uni", false);
zscore_FR = cell2mat(cellfun(@(x) [zscore(x(:, 1)), x(:, 2)], fr_Raw, "UniformOutput", false));
Fig2.e.zscore_FR = zscore_FR;
pushZscore = zscore_FR(zscore_FR(:, 2) == 1, :);
nopushZscore = zscore_FR(zscore_FR(:, 2) == 0, :);
binEdges = -1.5:1:3.5;
pushBarVal = histcounts(pushZscore(:, 1), binEdges);
nopushBarVal = histcounts(nopushZscore(:, 1), binEdges);
Fig2.e.binEdges = [binEdges(1:end-1); binEdges(1:end-1)]'+0.5;
Fig2.e.barVal = [pushBarVal; nopushBarVal]';
b = bar(gca, Fig2.e.binEdges, Fig2.e.barVal, 2);
b(1).FaceColor = [1 0 0]; b(1).BarWidth = 1;
b(2).FaceColor = [0 0 0]; b(2).BarWidth = 1;
xlabel("zscore value");
ylabel("counts");
title("250-350ms");
[~, Fig2.e.ttest] = ttest2(pushZscore(:, 1), nopushZscore(:, 1));
Fig2.e.noPushZ = Fig2.e.zscore_FR(Fig2.e.zscore_FR(:, 2) == 0, 1);
Fig2.e.PushZ = Fig2.e.zscore_FR(Fig2.e.zscore_FR(:, 2) == 1, 1);

% Fig2f and t-test
subplot(5, 2, 8)
[~, Fig2.f.ttest_Early] = ttest2(spkDev.wrong(diffSel).frRaw_Early, spkDev.correct(diffSel).frRaw_Early, "Tail", "left");
[~, Fig2.f.ttest_Late] = ttest2(spkDev.wrong(diffSel).frRaw_Late, spkDev.correct(diffSel).frRaw_Late, "Tail", "left");

% PSTH v1: binsize = 50ms, binstep = 5ms
% Fig2.f.x = spkDev.correct(diffSel).PSTH(:, 1);
% Fig2.f.push = spkDev.correct(diffSel).PSTH(:, 2);
% Fig2.f.noPush = spkDev.wrong(diffSel).PSTH(:, 2);
% PSTH v2: binsize = 100, binstep = 20ms
Window = [-1000, 6000];  
psthpara.binsize = 200; psthpara.binstep = 10;
correctPSTH = calPsth(spkDev.correct(diffSel).spikePlot(:, 1), psthpara, 1e3, "EDGE", Window-5000, "NTRIAL", spkDev.correct(diffSel).trialNum);
wrongPSTH = calPsth(spkDev.wrong(diffSel).spikePlot(:, 1), psthpara, 1e3, "EDGE", Window-5000, "NTRIAL", spkDev.wrong(diffSel).trialNum);
Fig2.f.x = correctPSTH(:, 1); Fig2.f.push = correctPSTH(:, 2); Fig2.f.noPush = wrongPSTH(:, 2);
plot(Fig2.f.x, Fig2.f.push, "r-", "DisplayName", "pressing button"); hold on;
plot(Fig2.f.x, Fig2.f.noPush, "k-", "DisplayName", "no-pressing button"); hold on;
xlim([0, 1000]);
xlabel("Time (ms)");
ylabel("Firing Rate(Hz)");


% Fig2g
subplot(5, 2, 9)
[Fig2.g.falseAlarm, Fig2.g.Hit, ~, Fig2.g.DP] = perfcurve(zscore_FR(:, 2), zscore_FR(:, 1), 1);
plot(Fig2.g.falseAlarm, Fig2.g.Hit, "r-"); hold on
plot([0, 0], [1, 1], "k--"); hold on
xlabel("False-alarm rate");
ylabel("Hit Rate");
title(['DP = ', num2str(roundn(Fig2.g.DP, -2))]);


% Fig2h
subplot(5, 2, 10)
temp = selectRes.DPRes;
Fig2.h.time = [temp.timePoint]';
Fig2.h.DP = [temp.value]';
Fig2.h.sigT = [temp([temp.p]' <= 0.05).timePoint]';
Fig2.h.sigDP = [temp([temp.p]' <= 0.05).value]';
Fig2.h.noSigT = [temp([temp.p]' > 0.05).timePoint]';
Fig2.h.noSigDP = [temp([temp.p]' > 0.05).value]';
plot(Fig2.h.time, Fig2.h.DP, "k-", "LineWidth", 2); hold on;
scatter(Fig2.h.sigT, Fig2.h.sigDP, 30, "black", "filled"); hold on;
scatter(Fig2.h.noSigT, Fig2.h.noSigDP, 30, "black"); hold on;
plot([0, 1000], [0.5, 0.5], "k--");
ylim([0, 1]);
xlabel("Time (ms)");
ylabel("DRP");

save(strcat(getRootDirPath(mfilename("fullpath"), 1), "Figure2A_H_Plot.mat"), "Fig2", "-v7.3");