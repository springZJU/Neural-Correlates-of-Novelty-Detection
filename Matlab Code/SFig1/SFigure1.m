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

protStr = "ActiveNoneFreqRight";
temp = dirItem(strcat(ROOTPATH, protStr), "spkData.mat");
popRes_C = cell2mat(cellfun(@(x) NoveltySU.population.loadPopData(x), temp.file, "UniformOutput", false));
popRes_C = addFieldToStruct(popRes_C, repmat(cellstr(protStr), length(popRes_C), 1), "protStr");
% popRes_C = rmfield(popRes_C, ["behavThrRes_8910", "DPRes_8910", "neuThrRes_8910", "spkDev_8910"]);

% merge 
popRes = [popRes_A; popRes_B; popRes_C];

%% select data
selectRes = popRes(matches({popRes.Date}', "CM_20200706_A49L19cell32") & matches({popRes.protStr}', "ActiveFreqRight"));
spkDev = selectRes.spkDev;
devType = [selectRes.spkDev.all.devType]';
devStr = cellfun(@(x) num2str(roundn(x, -2)), num2cell(devType(2:5)/devType(1)), "UniformOutput", false);
pushRatio = selectRes.behavThrRes.behavRes;
lanmuda = devType / devType(1);
diffSel = 2;

%% Fig2
Fig = figure;
set(Fig, "Position", [486.6   41.8  488.8  741.6]);
% Fig2epush
Window = [-1000, 6000];  
psthpara.binsize = 100; psthpara.binstep = 5;
subplot(2, 2, 1)
correctPSTH = calPsth(spkDev.correct(diffSel).spikePlot(:, 1), psthpara, 1e3, "EDGE", Window-5000, "NTRIAL", spkDev.correct(diffSel).trialNum);
SFig1.a.x = correctPSTH(:, 1); SFig1.a.correctPSTH = correctPSTH(:, 2);
plot(SFig1.a.x, SFig1.a.correctPSTH, "r-", "DisplayName", "pressing button"); hold on;
plot([-500, -500], [0, 60], "k--"); hold on
plot([0, 0], [0, 60], "k--"); hold on
xlim([-600, 600]);
xlabel("Time (ms)");
ylabel("Firing Rate(Hz)");
title("Example Neuron | correct trials");

subplot(2, 2, 2)
allPSTH = calPsth(spkDev.all(diffSel).spikePlot(:, 1), psthpara, 1e3, "EDGE", Window-5000, "NTRIAL", spkDev.all(diffSel).trialNum);
SFig1.a.x = allPSTH(:, 1); SFig1.a.allPSTH = allPSTH(:, 2);
plot(SFig1.a.x, SFig1.a.allPSTH, "r-", "DisplayName", "pressing button"); hold on;
xlim([-600, 600]);
xlabel("Time (ms)");
ylabel("Firing Rate(Hz)");
plot([-500, -500], [0, 60], "k--"); hold on
plot([0, 0], [0, 60], "k--"); hold on
title("Example Neuron | all trials");


% Fig 4e left
baseWin = [-500, 0]; % to std

subplot(2, 2 ,3)
SFig1.bCorrect.colors = ["#0000FF", "#FF00A5", "#FFA500", "#FF0000"]';
SFig1.bCorrect.displayName = devStr;
SFig1.bCorrect.t = popRes(1).spkDev.correct(5).PSTH(:, 1);
% baseIdx = tSTD >= baseWin(1) & tSTD <= baseWin(2);
for dIndex = 1 : length(devType)
    SFig1.bCorrect.PSTH_Raw{dIndex, 1} = cell2mat(cellfun(@(x, y) x.correct(dIndex).PSTH(:, 2), {popRes.spkDev}', {popRes.spkStd}', "UniformOutput", false)');
    SFig1.bCorrect.PSTH_Mean{dIndex, 1} = mean(SFig1.bCorrect.PSTH_Raw{dIndex, 1}, 2);
end
cellfun(@(x, y) NoveltySU.plot.multiPlot(gca, SFig1.bCorrect.t, x, y, "-", 1.5), SFig1.bCorrect.PSTH_Mean(end), SFig1.bCorrect.colors(end), "UniformOutput", false);
xlim([-600, 600]);
xlabel("Time from onset");
ylabel("Firing Rate(Hz)");
plot([-500, -500], [0, 60], "k--"); hold on
plot([0, 0], [0, 60], "k--"); hold on
title("Population Data | correct trials");

% Fig 4e left
subplot(2, 2 ,4)
SFig1.bAll.colors = ["#0000FF", "#FF00A5", "#FFA500", "#FF0000"]';
SFig1.bAll.displayName = devStr;
SFig1.bAll.t = popRes(1).spkDev.all(5).PSTH(:, 1);
for dIndex = 1 : length(devType)
    SFig1.bAll.PSTH_Raw{dIndex, 1} = cell2mat(cellfun(@(x) x.all(dIndex).PSTH(:, 2) , {popRes.spkDev}', "UniformOutput", false)');
    SFig1.bAll.PSTH_Mean{dIndex, 1} = mean(SFig1.bAll.PSTH_Raw{dIndex, 1}, 2);
end
cellfun(@(x, y) NoveltySU.plot.multiPlot(gca, SFig1.bAll.t, x, y, "-", 1.5), SFig1.bAll.PSTH_Mean(end), SFig1.bAll.colors(end), "UniformOutput", false);
xlim([-3000, 1000]);
ylim([15, 60]);
xlabel("Time from onset");
ylabel("Firing Rate(Hz)");
plot([-500, -500], [0, 60], "k--"); hold on
plot([0, 0], [0, 60], "k--"); hold on
title("Population Data | all trials");
% save(strcat(getRootDirPath(mfilename("fullpath"), 1), "Figure2A_H_Plot.mat"), "Fig2", "-v7.3");