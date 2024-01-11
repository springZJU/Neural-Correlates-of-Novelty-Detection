ccc
ROOTPATH = strcat(getRootDirPath(mfilename("fullpath"), 4), "Data\ProcessData\");
cd(getRootDirPath(mfilename("fullpath"), 2))
protStr = "ActiveFreqRight";
temp = dirItem(strcat(ROOTPATH, protStr), "spkData.mat");
popRes_A = cell2mat(cellfun(@(x) NoveltySU.population.loadPopData(x), temp.file, "UniformOutput", false));
popRes_A = addFieldToStruct(popRes_A, repmat(cellstr(protStr), length(popRes_A), 1), "protStr");
% popRes_A = rmfield(popRes_A, ["behavThrRes_8910", "DPRes_8910", "neuThrRes_8910", "spkDev_8910"]);

protStr = "ActiveFreqLeft";
temp = dirItem(strcat(ROOTPATH, protStr), "spkData.mat");
popRes_B = cell2mat(cellfun(@(x) NoveltySU.population.loadPopData(x), temp.file, "UniformOutput", false));
popRes_B = addFieldToStruct(popRes_B, repmat(cellstr(protStr), length(popRes_B), 1), "protStr");
% popRes_B = rmfield(popRes_B, ["behavThrRes_8910", "DPRes_8910", "neuThrRes_8910", "spkDev_8910"]);

protStr = "ActiveNoneFreqRight";
temp = dirItem(strcat(ROOTPATH, protStr), "spkData.mat");
popRes_C = cell2mat(cellfun(@(x) NoveltySU.population.loadPopData(x), temp.file, "UniformOutput", false));
popRes_C = addFieldToStruct(popRes_C, repmat(cellstr(protStr), length(popRes_C), 1), "protStr");
% popRes_C = rmfield(popRes_C, ["behavThrRes_8910", "DPRes_8910", "neuThrRes_8910", "spkDev_8910"]);


protStr = "ActiveFreqNoResponse";
temp = dirItem(strcat(ROOTPATH, protStr), "spkData.mat");
popRes_D = cell2mat(cellfun(@(x) NoveltySU.population.loadPopData(x), temp.file, "UniformOutput", false));
popRes_D = addFieldToStruct(popRes_D, repmat(cellstr(protStr), length(popRes_D), 1), "protStr");
% popRes_D = rmfield(popRes_D, ["behavThrRes_8910", "DPRes_8910", "neuThrRes_8910", "spkDev_8910"]);

% popRes_D(6) = []; % delete CM_ty20200_A48L19cell29


% merge
popRes = [popRes_A; popRes_B; popRes_C; popRes_D];

%% select data
temp = [popRes_A; popRes_B; popRes_C];
matchIdx = NoveltySU.utils.selectData.decideRegion(temp, "A1");
popSelect = temp(cell2mat(matchIdx));


%% Fig 5
Fig = figure;
maximizeFig(Fig)

selectRes = popRes(matches({popRes.Date}', "CM_ty20191_A50L17cell5") & matches({popRes.protStr}', "ActiveFreqRight"));
devType = [selectRes.spkDev.all.devType]';
% Fig5a CM cell5
subplot(4, 3, 1);
Date = string(selectRes.Date);
ORIGINPATH = strrep(ROOTPATH, "ProcessData", "OriginData\ToneCF");
TONEPATH = strcat(ORIGINPATH, Date, "\spkData.mat");
Fig5.a.TONEPATH = TONEPATH;
result = NoveltySU.FRA.FRA_Data(TONEPATH);
temp = cellfun(@(x) x(2).spikes, {result.data.trials}', "UniformOutput", false);

for fIndex = 1 :length(temp)
    repeat = length(temp{fIndex});
    Fig5.a.rasterTemp{fIndex, 1} = cell2mat(cellfun(@(x, y) [x, y*ones(length(x), 1)], temp{fIndex}, num2cell((fIndex-1)*length(temp{fIndex})+1 : fIndex*length(temp{fIndex}))', "uni", false));
    Fig5.a.spikeRaw{fIndex, 1} = cell2mat(cellfun(@(x) length(x), temp{fIndex}, "uni", false));
    Fig5.a.frMean(fIndex, 1) = mean(Fig5.a.spikeRaw{fIndex, 1})*10;
    Fig5.a.frSE(fIndex, 1) = SE(Fig5.a.spikeRaw{fIndex, 1})*10;
end
Fig5.a.repeat = repeat;
Fig5.a.rasterPlot = cell2mat(Fig5.a.rasterTemp);
scatter(Fig5.a.rasterPlot(:, 1), Fig5.a.rasterPlot(:, 2), 5, "black", "filled"); hold on;
cellfun(@(x) NoveltySU.plot.multiPlot(gca, [0, 100], [x, x], "k", "-", 0.5), num2cell((repeat:repeat:repeat*length(temp)-repeat)+0.5), "UniformOutput", false);
yticks([1, 9, 17, 26]*length(temp{1})-length(temp{1})/2);
yticklabels(mat2cellStr([result.data([1, 9, 17, 26]).freq]));
ylim([0, 26*length(temp{1})]);
xlim([0, 100]);

% Fig5b
subplot(4,3,2)
Fig5.b.tone = roundn([result.data.freq]/1000, -1);
Fig5.b.frMean = Fig5.a.frMean;
Fig5.b.frSE = Fig5.a.frSE;
errorbar(1:length(Fig5.b.tone), Fig5.b.frMean, Fig5.b.frSE, "k-", "LineWidth", 1); hold on
stdFreqPos = find(Fig5.b.tone == roundn(devType(1)/1000, -1));
if stdFreqPos < 26
    xticks([1, stdFreqPos, 26]);
    xticklabels(string(cellfun(@num2str, num2cell([result.data(1).freq, devType(1), result.data(end).freq]), 'UniformOutput', false)));
else
    xticks([1, 26]);
    xticklabels(string(cellfun(@num2str, num2cell([result.data(1).freq, result.data(end).freq]), 'UniformOutput', false)));
end
xlim([0.9, 26.1]);
plot([stdFreqPos, stdFreqPos], [0, max(Fig5.b.frMean) + max(Fig5.b.frSE)], "k--"); hold on
Fig5.b.stdFreqPos = stdFreqPos;
xlabel("Frequency(kHz)");
ylabel("Firing Rate(kHz)");
title("std<dev");


% Fig5c
subplot(4,3,3)
Fig5.c.devDiff = [selectRes.spkDev.correct.devType]'./ selectRes.spkDev.correct(1).devType;
Fig5.c.respMean = [selectRes.spkDev.correct.frMean_Late]';
Fig5.c.respSE = [selectRes.spkDev.correct.frSE_Late]';
[Fig5.c.anovaP, Fig5.c.postHoc, ~, Fig5.c.postHoc_H] = mAnovaCell({selectRes.spkDev.correct(2:end).frRaw_Late}', "label", (1:4)');
xticks(Fig5.c.devDiff);
xlabel("Frequency Ratio(dev/std)");
ylabel("Firing Rate(kHz)");
title("250-350ms");
errorbar(Fig5.c.devDiff, Fig5.c.respMean, Fig5.c.respSE, "k-", "LineWidth", 1); hold on;


% Fig5d CM cell1
selectRes = popRes(matches({popRes.Date}', "CM_ty20191_A50R10cell1") & matches({popRes.protStr}', "ActiveFreqLeft"));
devType = [selectRes.spkDev.all.devType]';
subplot(4, 3, 4);
Date = string(selectRes.Date);
ORIGINPATH = strrep(ROOTPATH, "ProcessData", "OriginData\ToneCF");
TONEPATH = strcat(ORIGINPATH, Date, "\spkData.mat");
Fig5.d.TONEPATH = TONEPATH;
clear result
result = NoveltySU.FRA.FRA_Data(TONEPATH);
temp = cellfun(@(x) x(2).spikes, {result.data.trials}', "UniformOutput", false);

for fIndex = 1 :length(temp)
    repeat = length(temp{fIndex});
    Fig5.d.rasterTemp{fIndex, 1} = cell2mat(cellfun(@(x, y) [x, y*ones(length(x), 1)], temp{fIndex}, num2cell((fIndex-1)*length(temp{fIndex})+1 : fIndex*length(temp{fIndex}))', "uni", false));
    Fig5.d.spikeRaw{fIndex, 1} = cell2mat(cellfun(@(x) length(x), temp{fIndex}, "uni", false));
    Fig5.d.frMean(fIndex, 1) = mean(Fig5.d.spikeRaw{fIndex, 1})*10;
    Fig5.d.frSE(fIndex, 1) = SE(Fig5.d.spikeRaw{fIndex, 1})*10;
end
Fig5.d.repeat = repeat;
Fig5.d.rasterPlot = cell2mat(Fig5.d.rasterTemp);
scatter(Fig5.d.rasterPlot(:, 1), Fig5.d.rasterPlot(:, 2), 5, "black", "filled"); hold on;
cellfun(@(x) NoveltySU.plot.multiPlot(gca, [0, 100], [x, x], "k", "-", 0.5), num2cell((repeat:repeat:repeat*length(temp)-repeat)+0.5), "UniformOutput", false);
yticks([1, 9, 17, 26]*length(temp{1})-length(temp{1})/2);
yticklabels(mat2cellStr([result.data([1, 9, 17, 26]).freq]));
ylim([0, 26*length(temp{1})]);
xlim([0, 100]);


% Fig5e

subplot(4,3,5)
Fig5.e.tone = roundn([result.data.freq]/1000, -1);
Fig5.e.frMean = Fig5.d.frMean;
Fig5.e.frSE = Fig5.d.frSE;
errorbar(1:length(Fig5.e.tone), Fig5.e.frMean, Fig5.e.frSE, "k-", "LineWidth", 1); hold on
stdFreqPos = find(Fig5.e.tone == roundn(devType(1)/1000, -1));
if stdFreqPos < 26
    xticks([1, stdFreqPos, 26]);
    xticklabels(string(cellfun(@num2str, num2cell([result.data(1).freq, devType(1), result.data(end).freq]), 'UniformOutput', false)));
else
    xticks([1, 26]);
    xticklabels(string(cellfun(@num2str, num2cell([result.data(1).freq, result.data(end).freq]), 'UniformOutput', false)));
end
xlim([0.9, 26.1]);
plot([stdFreqPos, stdFreqPos], [0, max(Fig5.e.frMean) + max(Fig5.e.frSE)], "k--"); hold on
Fig5.e.stdFreqPos = stdFreqPos;
xlabel("Frequency(kHz)");
ylabel("Firing Rate(kHz)");
title("std>dev");

% Fig5f
subplot(4,3,6)
Fig5.f.devDiff = [selectRes.spkDev.correct.devType]'./ selectRes.spkDev.correct(1).devType;
Fig5.f.respMean = [selectRes.spkDev.correct.frMean_Late]';
Fig5.f.respSE = [selectRes.spkDev.correct.frSE_Late]';
[Fig5.f.anovaP, Fig5.f.postHoc, ~, Fig5.f.postHoc_H] = mAnovaCell({selectRes.spkDev.correct(2:end).frRaw_Late}', "label", (1:4)');
errorbar(Fig5.f.devDiff, Fig5.f.respMean, Fig5.f.respSE, "k-", "LineWidth", 1); hold on;
xlabel("Frequency Ratio(dev/std)");
ylabel("Firing Rate(kHz)");
title("250-350ms");


% Fig5g
subplot(4, 3, 7);
selectRes = popRes(matches({popRes.Date}', "Monica_20200812_A24R20cell90") & matches({popRes.protStr}', "ActiveFreqNoResponse"));
devType = [selectRes.spkDev.all.devType]';
Date = string(selectRes.Date);
ORIGINPATH = strrep(ROOTPATH, "ProcessData", "OriginData\ToneCF");
TONEPATH = strcat(ORIGINPATH, Date, "\spkData.mat");
Fig5.g.TONEPATH = TONEPATH;
result = NoveltySU.FRA.FRA_Data(TONEPATH);
temp = cellfun(@(x) x(2).spikes, {result.data.trials}', "UniformOutput", false);
for fIndex = 1 :length(temp)
    Fig5.g.rasterTemp{fIndex, 1} = cell2mat(cellfun(@(x, y) [x, y*ones(length(x), 1)], temp{fIndex}, num2cell((fIndex-1)*length(temp{fIndex})+1 : fIndex*length(temp{fIndex}))', "uni", false));
    Fig5.g.spikeRaw{fIndex, 1} = cell2mat(cellfun(@(x) length(x), temp{fIndex}, "uni", false));
    Fig5.g.frMean(fIndex, 1) = mean(Fig5.g.spikeRaw{fIndex, 1})*10;
    Fig5.g.frSE(fIndex, 1) = SE(Fig5.g.spikeRaw{fIndex, 1})*10;
end
Fig5.g.repeat = repeat;
Fig5.g.rasterPlot = cell2mat(Fig5.g.rasterTemp);
scatter(gca, Fig5.g.rasterPlot(:, 1), Fig5.g.rasterPlot(:, 2), 5, "black", "filled"); hold on;
cellfun(@(x) NoveltySU.plot.multiPlot(gca, [0, 100], [x, x], "k", "-", 0.5), num2cell((repeat:repeat:repeat*length(temp)-repeat)+0.5), "UniformOutput", false);
yticks([1, 9, 17, 26]*length(temp{1})-length(temp{1})/2);
yticklabels(mat2cellStr([result.data([1, 9, 17, 26]).freq]));
ylim([0, 26*length(temp{1})]);
xlim([0, 100]);


% Fig5h
subplot(4,3,8)
Fig5.h.tone = roundn([result.data.freq]/1000, -2);
errorbar(1:length(Fig5.h.tone), Fig5.g.frMean, Fig5.g.frSE, "k-", "LineWidth", 1); hold on
stdFreqPos = find(Fig5.h.tone == roundn(devType(1)/1000, -2));
if stdFreqPos < 26 && stdFreqPos > 1
    xticks([1, stdFreqPos, 26]);
    xticklabels(string(cellfun(@num2str, num2cell([result.data(1).freq, devType(1), result.data(end).freq]), 'UniformOutput', false)));
else
    xticks([1, 26]);
    xticklabels(string(cellfun(@num2str, num2cell([result.data(1).freq, result.data(end).freq]), 'UniformOutput', false)));
end
xticklabels(string(cellfun(@num2str, num2cell([result.data(1).freq, devType(1), result.data(end).freq]), 'UniformOutput', false)));
xlim([0.9, 26.1]);
plot([stdFreqPos, stdFreqPos], [0, max(Fig5.g.frMean) + max(Fig5.g.frSE)], "k--"); hold on
Fig5.g.stdFreqPos = stdFreqPos;
xlabel("Frequency(kHz)");
ylabel("Firing Rate(kHz)");
title("std<dev");

% Fig5i
subplot(4,3,9)
Fig5.i.devDiff = [selectRes.spkDev.correct.devType]'./ selectRes.spkDev.correct(1).devType;
Fig5.i.respMean = [selectRes.spkDev.correct.frMean_Late]';
Fig5.i.respSE = [selectRes.spkDev.correct.frSE_Late]';
[Fig5.i.anovaP, Fig5.i.postHoc, ~, Fig5.i.postHoc_H] = mAnovaCell({selectRes.spkDev.correct(2:end).frRaw_Late}', "label", (1:4)');
[~, Fig5.i.ttestP]  = ttest2(selectRes.spkDev.correct(2).frRaw_Late, selectRes.spkDev.correct(5).frRaw_Late);
errorbar(Fig5.i.devDiff, Fig5.i.respMean, Fig5.i.respSE, "k-", "LineWidth", 1); hold on;
xlabel("Frequency Ratio(dev/std)");
ylabel("Firing Rate(kHz)");


% Fig5j
subplot(4,3, 10);
Fig5.j.devType = 0:4;
popFreqRight.Monica = popSelect(matches({popSelect.protStr}', ["ActiveFreqRight", "ActiveNoneFreqRight"]) & contains({popSelect.Date}', "Monica"));
popFreqRight.CM = popSelect(matches({popSelect.protStr}', ["ActiveFreqRight", "ActiveNoneFreqRight"]) & contains({popSelect.Date}', "CM"));
tempMonica = cell2mat(cellfun(@(x) [x.correct.frMean_Late]', {popFreqRight.Monica.spkDev}', "UniformOutput", false)');
[Fig5.j.anovaP_Monica, Fig5.j.postHoc_Monica] = mAnovaCell(num2cell(tempMonica(2:end, :)', 1)', "label", (1:4)');
[~, Fig5.j.ttestP_Monica_2_3] = ttest(tempMonica(2, :), tempMonica(3, :));
[~, Fig5.j.ttestP_Monica_3_4] = ttest(tempMonica(3, :), tempMonica(4, :));
[~, Fig5.j.ttestP_Monica_4_5] = ttest(tempMonica(4, :), tempMonica(5, :));
[~, Fig5.j.ttestP_Monica_2_5] = ttest(tempMonica(2, :), tempMonica(5, :));

Fig5.j.respMean_Monica = mean(tempMonica, 2);
Fig5.j.respSE_Monica = SE(tempMonica, 2);
tempCM = cell2mat(cellfun(@(x) [x.correct.frMean_Late]', {popFreqRight.CM.spkDev}', "UniformOutput", false)');
[Fig5.j.anovaP_CM, Fig5.j.postHoc_CM] = mAnovaCell(num2cell(tempCM(2:end, :)', 1)', "label", (1:4)');
[~, Fig5.j.ttestP_CM_2_3] = ttest(tempCM(2, :), tempCM(3, :), "Tail", "left");
[~, Fig5.j.ttestP_CM_3_4] = ttest(tempCM(3, :), tempCM(4, :), "Tail", "left");
[~, Fig5.j.ttestP_CM_4_5] = ttest(tempCM(4, :), tempCM(5, :), "Tail", "left");
[~, Fig5.j.ttestP_CM_2_5] = ttest(tempCM(2, :), tempCM(5, :), "Tail", "left");
Fig5.j.respMean_CM = mean(tempCM, 2);
Fig5.j.respSE_CM = SE(tempCM, 2);

errorbar(Fig5.j.devType, Fig5.j.respMean_Monica, Fig5.j.respSE_Monica, "m-", "LineWidth", 1, "DisplayName", "Monica"); hold on;
errorbar(Fig5.j.devType, Fig5.j.respMean_CM, Fig5.j.respSE_CM, "g-", "LineWidth", 1, "DisplayName", "CM"); hold on;
xlabel("Frequency Ratio(log(dev/std))");
ylabel("Firing Rate(Hz)");
title("ActiveFreqRight");

% Fig5k
subplot(4,3, 11);
Fig5.k.devType = 4:-1:0;
popFreqLeft.Monica = popSelect(matches({popSelect.protStr}', "ActiveFreqLeft") & contains({popSelect.Date}', "Monica"));
popFreqLeft.CM = popSelect(matches({popSelect.protStr}', "ActiveFreqLeft") & contains({popSelect.Date}', "CM"));
tempMonica = cell2mat(cellfun(@(x) [x.correct.frMean_Late]', {popFreqLeft.Monica.spkDev}', "UniformOutput", false)');
[Fig5.k.anovaP_Monica, Fig5.k.postHoc_Monica] = mAnovaCell(num2cell(tempMonica(2:end, :)', 1)', "label", (1:4)');
[~, Fig5.k.ttestP_Monica_2_3] = ttest(tempMonica(2, :), tempMonica(3, :));
[~, Fig5.k.ttestP_Monica_3_4] = ttest(tempMonica(3, :), tempMonica(4, :));
[~, Fig5.k.ttestP_Monica_4_5] = ttest(tempMonica(4, :), tempMonica(5, :));
[~, Fig5.k.ttestP_Monica_2_5] = ttest(tempMonica(2, :), tempMonica(5, :));
Fig5.k.respMean_Monica = mean(tempMonica, 2);
Fig5.k.respSE_Monica = SE(tempMonica, 2);
tempCM = cell2mat(cellfun(@(x) [x.correct.frMean_Late]', {popFreqLeft.CM.spkDev}', "UniformOutput", false)');
[Fig5.k.anovaP_CM, Fig5.k.postHoc_CM] = mAnovaCell(num2cell(tempCM(2:end, :)', 1)', "label", (1:4)');
[~, Fig5.k.ttestP_CM_2_3] = ttest(tempCM(2, :), tempCM(3, :), "Tail", "left");
[~, Fig5.k.ttestP_CM_3_4] = ttest(tempCM(3, :), tempCM(4, :), "Tail", "left");
[~, Fig5.k.ttestP_CM_4_5] = ttest(tempCM(4, :), tempCM(5, :), "Tail", "left");
[~, Fig5.k.ttestP_CM_2_5] = ttest(tempCM(2, :), tempCM(5, :), "Tail", "left");
Fig5.k.respMean_CM = mean(tempCM, 2);
Fig5.k.respSE_CM = SE(tempCM, 2);errorbar(Fig5.k.devType, Fig5.k.respMean_Monica, Fig5.k.respSE_Monica, "m-", "LineWidth", 1, "DisplayName", "Monica"); hold on;
errorbar(Fig5.k.devType, Fig5.k.respMean_CM, Fig5.k.respSE_CM, "g-", "LineWidth", 1, "DisplayName", "CM"); hold on;
xlabel("Frequency Ratio(log(dev/std))");
ylabel("Firing Rate(Hz)");
title("ActiveFreqLeft");

% Fig5l
subplot(4,3, 12);
Fig5.l.devType = 0:4;
popNoResponse.Monica = popRes_D(contains({popRes_D.Date}', "Monica"));
popNoResponse.CM = popRes_D(contains({popRes_D.Date}', "CM"));
tempMonica = cell2mat(cellfun(@(x) [x.correct.frMean_Late]', {popNoResponse.Monica.spkDev}', "UniformOutput", false)');
[Fig5.l.anovaP_Monica, Fig5.l.postHoc_Monica] = mAnovaCell(num2cell(tempMonica(2:end, :)', 1)', "label", (1:4)');
[~, Fig5.l.ttestP_Monica_2_3] = ttest(tempMonica(2, :), tempMonica(3, :));
[~, Fig5.l.ttestP_Monica_3_4] = ttest(tempMonica(3, :), tempMonica(4, :));
[~, Fig5.l.ttestP_Monica_4_5] = ttest(tempMonica(4, :), tempMonica(5, :));
[~, Fig5.l.ttestP_Monica_2_5] = ttest(tempMonica(2, :), tempMonica(5, :));
Fig5.l.respMean_Monica = mean(tempMonica, 2);
Fig5.l.respSE_Monica = SE(tempMonica, 2);
tempCM = cell2mat(cellfun(@(x) [x.correct.frMean_Late]', {popNoResponse.CM.spkDev}', "UniformOutput", false)');
[Fig5.l.anovaP_CM, Fig5.l.postHoc_CM] = mAnovaCell(num2cell(tempCM(2:end, :)', 1)', "label", (1:4)');
[~, Fig5.l.ttestP_CM_2_3] = ttest(tempCM(2, :), tempCM(3, :), "Tail", "left");
[~, Fig5.l.ttestP_CM_3_4] = ttest(tempCM(3, :), tempCM(4, :), "Tail", "left");
[~, Fig5.l.ttestP_CM_4_5] = ttest(tempCM(4, :), tempCM(5, :), "Tail", "left");
[~, Fig5.l.ttestP_CM_2_5] = ttest(tempCM(2, :), tempCM(5, :), "Tail", "left");
Fig5.l.respMean_CM = mean(tempCM, 2);
Fig5.l.respSE_CM = SE(tempCM, 2);errorbar(Fig5.l.devType, Fig5.l.respMean_Monica, Fig5.l.respSE_Monica, "m-", "LineWidth", 1, "DisplayName", "Monica"); hold on;
errorbar(Fig5.l.devType, Fig5.l.respMean_CM, Fig5.l.respSE_CM, "g-", "LineWidth", 1, "DisplayName", "CM"); hold on;
xlabel("Frequency Ratio(log(dev/std))");
ylabel("Firing Rate(Hz)");
title("ActiveNoResponse");


% Save
save(strcat(getRootDirPath(mfilename("fullpath"), 1), "Figure5_Plot.mat"), "Fig5", "-v7.3");
