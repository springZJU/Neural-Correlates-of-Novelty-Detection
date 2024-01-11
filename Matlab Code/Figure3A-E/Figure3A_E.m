ccc
ROOTPATH = strcat(getRootDirPath(mfilename("fullpath"), 4), "Data\ProcessData\");
protStr = "ActiveFreqRight";
temp = dirItem(strcat(ROOTPATH, protStr), "spkData.mat");
popRes_A = cell2mat(cellfun(@(x) NoveltySU.population.loadPopData(x), temp.file, "UniformOutput", false));
popRes_A = addFieldToStruct(popRes_A, repmat(cellstr(protStr), length(popRes_A), 1), "protStr");

popRes_B = [];

popRes_C = [];

% merge
popRes = [popRes_A; popRes_B; popRes_C];

% select data CM_20191125_A51L15cell9
matchIdx = NoveltySU.utils.selectData.decideRegion(popRes, "A1");
popSelect = popRes(cell2mat(matchIdx));
selectRes = popSelect(matches({popSelect.Date}', "CM_20191125_A51L15cell9") & matches({popSelect.protStr}', "ActiveFreqRight"));

%% Fig3
Fig = figure;
maximizeFig(Fig);
% Fig 4a

binEdges = 0:2:20;
countStd = selectRes.spkDev.all(1).frRaw_Late / 10;
stdBarVal = histcounts(countStd, binEdges);
devType = [selectRes.spkDev.all.devType]' / selectRes.spkDev.all(1).devType;
for dIndex = 1 : 3
    mAxe(dIndex) = subplot(3, 3, dIndex);
    countDev{dIndex, 1} = selectRes.spkDev.all(dIndex + 1).frRaw_Late / 10;
    devBarVal = histcounts(countDev{dIndex, 1}, binEdges);
    b = bar(mAxe(dIndex), [binEdges(1:end-1); binEdges(1:end-1)+0.8]', [stdBarVal; devBarVal]', 2);
    b(1).FaceColor = [0 0 0]; b(1).BarWidth = 4;
    b(2).FaceColor = [1 0 0]; b(2).BarWidth = 4;
end

% Fig 4b
% 250-350ms
subplot(3, 3, 4)
win250_350 = selectRes.neuThrRes(2);
scatter(devType, win250_350.AUC, 20, "black", "filled", "diamond"); hold on
plot(win250_350.xFit, win250_350.yFit, "k-", "LineWidth", 4); hold on
plot([1, win250_350.Threshold], [0.8, 0.8], "k--"); hold on;
plot([win250_350.Threshold, win250_350.Threshold], [0, 0.8], "k--"); hold on;
xlim([1, 1.5]);
ylim([0.4, 1]);
xlabel("Frequency Ratio(dev/std)");
ylabel("AUC");
title("250-350ms");

% 0-100ms
subplot(3, 3, 5)
win0_100 = selectRes.neuThrRes(1);
scatter(devType, win0_100.AUC, 20, "black", "filled", "diamond"); hold on
plot(win0_100.xFit, win0_100.yFit, "k-", "LineWidth", 4); hold on
plot([1, win0_100.Threshold], [0.8, 0.8], "k--"); hold on;
plot([win0_100.Threshold, win0_100.Threshold], [0, 0.8], "k--"); hold on;
xlim([1, 1.5]);
ylim([0.4, 1]);
xlabel("Frequency Ratio(dev/std)");
ylabel("AUC");
title("0-100ms");

% behavFit
subplot(3, 3, 6)
behavFit = selectRes.behavThrRes;
scatter(devType, behavFit.behavRes, 20, "black", "filled", "diamond"); hold on
plot(behavFit.xFit, behavFit.yFit, "k-", "LineWidth", 4); hold on
plot([1, behavFit.Threshold], [0.8, 0.8], "k--"); hold on;
plot([behavFit.Threshold, behavFit.Threshold], [0, 0.8], "k--"); hold on;
xlim([1, 1.5]);
ylim([0, 1]);
xlabel("Frequency Ratio(dev/std)");
ylabel("Ratio of Pressing Button");
title("behavior");

% Fig3e
load("Figure3e_Plot.mat")
thrSel_Monica = find(Fig3e.threshold_Monica < 1.8);
thrSel_CM = find(Fig3e.threshold_CM < 1.8);
subplot(3,2,5)
scatter(Fig3e.stdFreq_Monica(thrSel_Monica), Fig3e.threshold_Monica(thrSel_Monica), 20, "green", "square", "LineWidth", 1); hold on;
scatter(Fig3e.stdFreq_CM(thrSel_CM), Fig3e.threshold_CM(thrSel_CM), 20, "magenta", "^", "LineWidth", 1); hold on;
set(gca, "XScale", "log");
xlabel("Standard frequency");
ylabel("Behavior Threshold");

subplot(3,2,6)
scatter(Fig3e.stdFreq_Monica(thrSel_Monica), Fig3e.diffThr_Monica(thrSel_Monica), 20, "green", "square", "LineWidth", 1); hold on;
scatter(Fig3e.stdFreq_CM(thrSel_CM), Fig3e.diffThr_CM(thrSel_CM), 20, "magenta", "^", "LineWidth", 1); hold on;
set(gca, "XScale", "log");
xlabel("Standard frequency");
ylabel("Behavior Threshold");

save(strcat(getRootDirPath(mfilename("fullpath"), 1), "Figure3A_E_Plot.mat"), "selectRes", "-v7.3");