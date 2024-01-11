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

%% select data CM_ty20200_A52L18cell35_ActiveFreqRight
matchIdx = NoveltySU.utils.selectData.decideRegion(popRes, "A1");
popSelect = popRes(cell2mat(matchIdx));

% v1：CM_ty20200_A52L18cell35_ActiveFreqRight
% v2: Monica_20190905_A20R23cell67_ActiveFreqRight
selectRes = popSelect(matches({popSelect.Date}', "Monica_20190905_A20R23cell67") & matches({popSelect.protStr}', "ActiveFreqRight"));
spkDev = selectRes.spkDev;
spkPush = selectRes.spkPush;
devType = [spkDev.all.devType]' / spkDev.all(1).devType;
devStr = cellfun(@(x) num2str(roundn(x, -2)), num2cell(devType(2:5)), "UniformOutput", false);

MonkeyIdx = contains({popSelect.Date}', "Monica");
CMIdx = contains({popSelect.Date}', "CM");
popMonica = popSelect(MonkeyIdx);
popCM = popSelect(CMIdx);
%% Fig 4
Fig = figure;
set(Fig, "Position", [486.6   41.8  488.8  741.6]);

% Fig 4a
subplot(5, 3, 1)
temp = num2cell([0; cumsum([spkDev.correct(2:end-1).trialNum]')]);
Fig4.a.spikePlot = cell2mat(cellfun(@(x, y) [x(:, 1), x(:, 2)+y ], {spkDev.correct(2:5).spikePlotOrdered}', temp, "UniformOutput", false));
Fig4.a.yLine = [0; cumsum([spkDev.correct(2:end-1).trialNum]')];
temp = [0; cumsum([spkDev.correct(2:end).trialNum]')];
Fig4.a.yTick = mean([temp(1:end-1), temp(2:end)], 2);
Fig4.a.yTickLabel = string(devStr);
Fig4.a.cdrSPKPlot = cellfun(@(x, y) findWithinInterval(Fig4.a.spikePlot, [x, y], 2), num2cell(Fig4.a.yLine), num2cell([Fig4.a.yLine(2:end); max(Fig4.a.spikePlot(:, 2))]), "UniformOutput", false);

scatter(Fig4.a.spikePlot(:, 1), Fig4.a.spikePlot(:, 2), 3, 'red', 'filled'); hold on;
plot([0, 1000], repmat(Fig4.a.yLine, 1, 2), "k-", "LineWidth", 1); hold on;
yticks(Fig4.a.yTick);
yticklabels(Fig4.a.yTickLabel);
xlim([0, 600]);
ylim([0, max(Fig4.a.spikePlot(:, 2))]);
title("devOnset Raster Plot");
ylabel("Frequancy Ratio (dev/std)");
xlabel("Time (ms)");

% Fig 4b left
subplot(5, 3, 2)
Fig4.b.trialNum = num2cell([[0; cumsum([spkDev.correct(2:end-1).trialNum]')]+1, cumsum([spkDev.correct(2:end).trialNum]')], 2);
Fig4.b.meanPush = cell2mat(cellfun(@(x) mean(x), {spkDev.correct(2:end).pushLatency}', "UniformOutput", false));
Fig4.b.pushPlot = cell2mat(cellfun(@(x, y) [x, (y(1):y(2))'], {spkDev.correct(2:end).pushLatency}', Fig4.b.trialNum, "UniformOutput", false));
Fig4.b.yLine = [0; cumsum([spkDev.correct(2:end-1).trialNum]')];
temp = [0; cumsum([spkDev.correct(2:end).trialNum]')];
Fig4.b.yTick = mean([temp(1:end-1), temp(2:end)], 2);
Fig4.b.yTickLabel = string(devStr);
scatter(Fig4.b.pushPlot(:, 1), Fig4.b.pushPlot(:, 2), 3, 'red', 'filled'); hold on;
plot([0, 1000], repmat(Fig4.b.yLine, 1, 2), "k-", "LineWidth", 1); hold on;
cellfun(@(x, y) NoveltySU.plot.multiPlot(gca, [x, x], y, "k"), num2cell(Fig4.b.meanPush), Fig4.b.trialNum, "UniformOutput", false);
yticks(Fig4.b.yTick);
yticklabels(Fig4.b.yTickLabel);
xlim([0, 600]);
ylim([0, max(Fig4.b.pushPlot(:, 2))]);
title("devOnset Push Plot");
ylabel("Frequancy Ratio (dev/std)");
xlabel("Time (ms)");

% Fig 4b right
subplot(5, 3, 3)

behavFit = mPFit([devType, selectRes.behavThrRes.behavRes]);
Fig4.b.behavX = devType;  Fig4.b.behavY = selectRes.behavThrRes.behavRes;
Fig4.b.xFit = behavFit.xFit;  Fig4.b.yFit = behavFit.yFit;
scatter(Fig4.b.behavX, Fig4.b.behavY, 30, "black"); hold on
plot(Fig4.b.xFit, Fig4.b.yFit, "k-", "LineWidth", 4); hold on
xlim([devType(1), devType(end)])
xlabel("Frequency Ratio(dev/std)");
ylabel("Ratio of Pressing Button");
title("behavior");


% Fig 4c
subplot(5, 2, 3)
Fig4.c.PSTH = {spkDev.correct(2:end).PSTH}';
Fig4.c.colors = ["#0000FF", "#FF00A5", "#FFA500", "#FF0000"]';
Fig4.c.displayName = devStr;
cellfun(@(x, y, z) NoveltySU.plot.multiPlot(gca, x(:, 1), x(:, 2), y, "-", 1.5), Fig4.c.PSTH, Fig4.c.colors, Fig4.c.displayName, "UniformOutput", false);
xlim([200, 600]);
xlabel("Time from onset");
ylabel("Firing Rate(Hz)");

% Fig 4d
subplot(5, 2, 4)
psthPushPara.binsize = 50; psthPushPara.binstep = 5; % ms
temp = cellfun(@(x) calPsth(x, psthPushPara, 1e3, 'EDGE', [100, 700], 'NTRIAL', length(x)), {spkDev.correct(2:end).pushLatency}', "UniformOutput", false);
Fig4.d.PSTH = temp;
Fig4.d.colors = ["#0000FF", "#FF00A5", "#FFA500", "#FF0000"]';
Fig4.d.displayName = devStr;
cellfun(@(x, y, z) NoveltySU.plot.multiPlot(gca, x(:, 1), x(:, 2), y, "-", 1.5), Fig4.d.PSTH, Fig4.d.colors, Fig4.d.displayName, "UniformOutput", false);
xlim([200, 600]);
xlabel("Time from onset");
ylabel("Push Rate(Hz)");

% Fig 4e left
subplot(5, 2 ,5)
Fig4.eL.colors = ["#0000FF", "#FF00A5", "#FFA500", "#FF0000"]';
Fig4.eL.displayName = devStr;
Fig4.eL.t = popMonica(1).spkDev.correct(5).PSTH(:, 1);
for dIndex = 1 : length(devType)
    Fig4.eL.PSTH_Raw{dIndex, 1} = cell2mat(cellfun(@(x) x.correct(dIndex).PSTH(:, 2) , {popMonica.spkDev}', "UniformOutput", false)');
    Fig4.eL.PSTH_Mean{dIndex, 1} = mean(Fig4.eL.PSTH_Raw{dIndex, 1}, 2);
end

temp = cellfun(@(x) num2cell(x', 1), changeCellRowNum(Fig4.eL.PSTH_Raw(2:end)), "UniformOutput", false);
[p, ~, ~, postHocH] = cellfun(@(x) mAnovaCell(x'), temp, "UniformOutput", false);
Fig4.eL.AnovaData = cellfun(@(x) [reshape(x, [], 1), reshape(repmat((2:5)', 1, size(x, 2)), [], 1)], changeCellRowNum(Fig4.eL.PSTH_Raw(2:end)), "UniformOutput", false);
Fig4.eL.anovaP = cell2mat(p);
Fig4.eL.anovaH = double(Fig4.eL.anovaP < 0.05);
Fig4.eL.anovaPostHoc = cell2mat(postHocH);
Fig4.eL.anovaRes = [Fig4.eL.t, Fig4.eL.anovaP, Fig4.eL.anovaH, Fig4.eL.anovaPostHoc];
Fig4.eL.displayName = devStr;
cellfun(@(x, y) NoveltySU.plot.multiPlot(gca, Fig4.eL.t, x, y, "-", 1.5), Fig4.eL.PSTH_Mean(2:end), Fig4.eL.colors, "UniformOutput", false);
xlim([200, 600]);
xlabel("Time from onset");
ylabel("Firing Rate(Hz)");
% plot significance bar
plot(Fig4.eL.t, 50*ones(length(Fig4.eL.t), 1), "k-", "LineWidth", 3); hold on;
sigIdx = logical(Fig4.eL.anovaH);
plot(Fig4.eL.t(sigIdx), 50*ones(sum(sigIdx), 1), "r-", "LineWidth", 3); hold on;


% Fig 4f left
subplot(5, 2 ,7)
Fig4.fL.colors = ["#0000FF", "#FF00A5", "#FFA500", "#FF0000"]';
Fig4.fL.displayName = devStr;
psthPushPara.binsize = 50; psthPushPara.binstep = 5; % ms
for pIndex = 1 : length(popMonica)
temp = cellfun(@(x) calPsth(x, psthPushPara, 1e3, 'EDGE', [100, 700], 'NTRIAL', length(x)), {popMonica(pIndex).spkDev.correct.pushLatency}', "UniformOutput", false);
pushPSTH{pIndex, 1} = cell2mat(cellfun(@(x) x(:, 2)', temp, "uni", false));
end
Fig4.fL.t = temp{1}(:, 1);
pushPSTH = changeCellRowNum(pushPSTH);
for dIndex = 1 : length(devType)
    Fig4.fL.PSTH_Raw{dIndex, 1} = pushPSTH{dIndex, 1}';
    Fig4.fL.PSTH_Mean{dIndex, 1} = mean(Fig4.fL.PSTH_Raw{dIndex, 1}, 2);
end
temp = cellfun(@(x) num2cell(x', 1), changeCellRowNum(Fig4.fL.PSTH_Raw(2:end)), "UniformOutput", false);
[p, postHoc, h, postHocH] = cellfun(@(x) mAnovaCell(x'), temp, "UniformOutput", false);
Fig4.fL.anovaP = cell2mat(p);
Fig4.fL.anovaH = double(Fig4.fL.anovaP < 0.05);
Fig4.fL.anovaPostHoc = cell2mat(postHocH);
Fig4.fL.anovaRes = [Fig4.fL.t, Fig4.fL.anovaP, Fig4.fL.anovaH, Fig4.fL.anovaPostHoc];

Fig4.fL.displayName = devStr;
cellfun(@(x, y) NoveltySU.plot.multiPlot(gca, Fig4.fL.t, x, y, "-", 1.5), Fig4.fL.PSTH_Mean(2:end), Fig4.fL.colors,  "UniformOutput", false);
xlim([200, 600]);
xlabel("Time from onset");
ylabel("Firing Rate(Hz)");
% plot significance bar
plot(Fig4.fL.t, 10*ones(length(Fig4.fL.t), 1), "k-", "LineWidth", 3); hold on;
sigIdx = logical(Fig4.fL.anovaH);
plot(Fig4.fL.t(sigIdx), 10*ones(sum(sigIdx), 1), "r-", "LineWidth", 3); hold on;

% Fig 4e right
subplot(5, 2 ,6)
Fig4.eR.colors = ["#0000FF", "#FF00A5", "#FFA500", "#FF0000"]';
Fig4.eR.displayName = devStr;
Fig4.eR.t = popCM(1).spkDev.correct(5).PSTH(:, 1);
for dIndex = 1 : length(devType)
    Fig4.eR.PSTH_Raw{dIndex, 1} = cell2mat(cellfun(@(x) x.correct(dIndex).PSTH(:, 2) , {popCM.spkDev}', "UniformOutput", false)');
    Fig4.eR.PSTH_Mean{dIndex, 1} = mean(Fig4.eR.PSTH_Raw{dIndex, 1}, 2);
end
temp = cellfun(@(x) num2cell(x', 1), changeCellRowNum(Fig4.eR.PSTH_Raw(2:end)), "UniformOutput", false);
[p, postHoc, h, postHocH] = cellfun(@(x) mAnovaCell(x'), temp, "UniformOutput", false);
Fig4.eR.anovaP = cell2mat(p);
Fig4.eR.anovaH = double(Fig4.eR.anovaP < 0.05);
Fig4.eR.anovaPostHoc = cell2mat(postHocH);
Fig4.eR.anovaRes = [Fig4.eR.t, Fig4.eR.anovaP, Fig4.eR.anovaH, Fig4.eR.anovaPostHoc];
Fig4.eR.displayName = devStr;
cellfun(@(x, y) NoveltySU.plot.multiPlot(gca, Fig4.eR.t, x, y, "-", 1.5), Fig4.eR.PSTH_Mean(2:end), Fig4.eR.colors,  "UniformOutput", false);
xlim([200, 600]);
xlabel("Time from onset");
ylabel("Firing Rate(Hz)");
% plot significance bar
plot(Fig4.eR.t, 80*ones(length(Fig4.eR.t), 1), "k-", "LineWidth", 3); hold on;
sigIdx = logical(Fig4.eR.anovaH);
plot(Fig4.eR.t(sigIdx), 80*ones(sum(sigIdx), 1), "r-", "LineWidth", 3); hold on;


% Fig 4f right
subplot(5, 2 ,8)
Fig4.fR.colors = ["#0000FF", "#FF00A5", "#FFA500", "#FF0000"]';
Fig4.fR.displayName = devStr;
psthPushPara.binsize = 50; psthPushPara.binstep = 5; % ms
for pIndex = 1 : length(popCM)
temp = cellfun(@(x) calPsth(x, psthPushPara, 1e3, 'EDGE', [100, 700], 'NTRIAL', length(x)), {popCM(pIndex).spkDev.correct.pushLatency}', "UniformOutput", false);
pushPSTH{pIndex, 1} = cell2mat(cellfun(@(x) x(:, 2)', temp, "uni", false));
end
pushPSTH = changeCellRowNum(pushPSTH);
for dIndex = 1 : length(devType)
    Fig4.fR.PSTH_Raw{dIndex, 1} = pushPSTH{dIndex, 1}';
    Fig4.fR.PSTH_Mean{dIndex, 1} = mean(Fig4.fR.PSTH_Raw{dIndex, 1}, 2);
end
Fig4.fR.t = temp{1}(:, 1);
temp = cellfun(@(x) num2cell(x', 1), changeCellRowNum(Fig4.fR.PSTH_Raw(2:end)), "UniformOutput", false);
[p, postHoc, h, postHocH] = cellfun(@(x) mAnovaCell(x'), temp, "UniformOutput", false);
Fig4.fR.anovaP = cell2mat(p);
Fig4.fR.anovaH = double(Fig4.fR.anovaP < 0.05);
Fig4.fR.anovaPostHoc = cell2mat(postHocH);
Fig4.fR.anovaRes = [Fig4.fR.t, Fig4.fR.anovaP, Fig4.fR.anovaH, Fig4.fR.anovaPostHoc];
Fig4.fR.displayName = devStr;
cellfun(@(x, y) NoveltySU.plot.multiPlot(gca, Fig4.fR.t, x, y, "-", 1.5), Fig4.fR.PSTH_Mean(2:end), Fig4.fR.colors,  "UniformOutput", false);
xlim([200, 600]);
xlabel("Time from onset");
ylabel("Firing Rate(Hz)");
% plot significance bar
plot(Fig4.fR.t, 12*ones(length(Fig4.fR.t), 1), "k-", "LineWidth", 3); hold on;
sigIdx = logical(Fig4.fR.anovaH);
plot(Fig4.fR.t(sigIdx), 12*ones(sum(sigIdx), 1), "r-", "LineWidth", 3); hold on;

% Fig 4g left
subplot(5, 2 ,9)
Fig4.gL.colors = ["#0000FF", "#FF00A5", "#FFA500", "#FF0000"]';
Fig4.gL.displayName = devStr;
Fig4.gL.t = popMonica(1).spkPush.correct(5).PSTH(:, 1);
for dIndex = 1 : length(devType)
    Fig4.gL.PSTH_Raw{dIndex, 1} = cell2mat(cellfun(@(x) x.correct(dIndex).PSTH(:, 2) , {popMonica.spkPush}', "UniformOutput", false)');
    Fig4.gL.PSTH_Mean{dIndex, 1} = mean(Fig4.gL.PSTH_Raw{dIndex, 1}, 2);
end
Fig4.gL.AnovaData = cellfun(@(x) [reshape(x, [], 1), reshape(repmat((2:5)', 1, size(x, 2)), [], 1)], changeCellRowNum(Fig4.gL.PSTH_Raw(2:end)), "UniformOutput", false);
Fig4.gL.anovaP = cell2mat(cellfun(@(x) anova1(x(:, 1), x(:, 2), "off"), Fig4.gL.AnovaData, "UniformOutput", false));
Fig4.gL.anovaH = double(Fig4.gL.anovaP < 0.05);
Fig4.gL.anovaRes = [Fig4.gL.t, Fig4.gL.anovaP, Fig4.gL.anovaH];
Fig4.gL.displayName = devStr;

cellfun(@(x, y) NoveltySU.plot.multiPlot(gca, Fig4.gL.t, x, y, "-", 1.5), Fig4.gL.PSTH_Mean(2:end), Fig4.gL.colors,  "UniformOutput", false);
plot(gca, [0, 0], [0, 100], "k--"); hold on;
xlim([-400, 400]);
xlabel("Time from onset");
ylabel("Firing Rate(Hz)");
[~, maxIdx] = max([Fig4.gL.PSTH_Mean{:}], [], 1);
Fig4.gL.peakT = Fig4.gL.t(maxIdx(2:end));

% Fig 4g right
subplot(5, 2 ,10)
Fig4.gR.colors = ["#0000FF", "#FF00A5", "#FFA500", "#FF0000"]';
Fig4.gR.displayName = devStr;
Fig4.gR.t = popCM(1).spkPush.correct(5).PSTH(:, 1);

for dIndex = 1 : length(devType)
    Fig4.gR.PSTH_Raw{dIndex, 1} = cell2mat(cellfun(@(x) x.correct(dIndex).PSTH(:, 2) , {popCM.spkPush}', "UniformOutput", false)');
    Fig4.gR.PSTH_Mean{dIndex, 1} = mean(Fig4.gR.PSTH_Raw{dIndex, 1}, 2);
end
Fig4.gR.AnovaData = cellfun(@(x) [reshape(x, [], 1), reshape(repmat((2:5)', 1, size(x, 2)), [], 1)], changeCellRowNum(Fig4.gR.PSTH_Raw(2:end)), "UniformOutput", false);
Fig4.gR.anovaP = cell2mat(cellfun(@(x) anova1(x(:, 1), x(:, 2), "off"), Fig4.gR.AnovaData, "UniformOutput", false));
Fig4.gR.anovaH = double(Fig4.gR.anovaP < 0.05);
Fig4.gR.anovaRes = [Fig4.gR.t, Fig4.gR.anovaP, Fig4.gR.anovaH];
Fig4.gR.displayName = devStr;
[~, maxIdx] = max([Fig4.gR.PSTH_Mean{:}], [], 1);
Fig4.gR.peakT = Fig4.gR.t(maxIdx(2:end));
cellfun(@(x, y) NoveltySU.plot.multiPlot(gca, Fig4.gR.t, x, y, "-", 1.5), Fig4.gR.PSTH_Mean(2:end), Fig4.gR.colors,  "UniformOutput", false);
plot(gca, [0, 0], [0, 120], "k--"); hold on;
xlim([-400, 400]);
xlabel("Time from onset");
ylabel("Firing Rate(Hz)");

%% save data
save(strcat(getRootDirPath(mfilename("fullpath"), 1), "Figure4A_G_Plot.mat"), "Fig4", "-v7.3");
