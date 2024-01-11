ccc
ROOTPATH = strcat(getRootDirPath(mfilename("fullpath"), 4), "Data\ProcessData\");
protStr = "ActiveFreq139";
temp = dirItem(strcat(ROOTPATH, protStr), "spkData.mat");
popRes = cell2mat(cellfun(@(x) NoveltySU.population.loadPopData(x), temp.file, "UniformOutput", false));
popRes = addFieldToStruct(popRes, repmat(cellstr(protStr), length(popRes), 1), "protStr");

%% select data
[matchIdx, firstTrial, lastTrial] = NoveltySU.utils.selectData.select139;
popRes = popRes(matchIdx);

selectRes = popRes(matches({popRes.Date}', "CM_ty20200_A48L19cell29"));
Fig6.devFreq = [selectRes.spkDev(1).all.devType]' / selectRes.spkDev(1).all(1).devType;
%% Fig 6
Fig = figure;
set(Fig, "Position", [488.   41.8  416.2  741.6])
Fig6.colors = ["#0000FF", "#FFA500", "#FF0000"]';

% Fig6a
axes = subplot(4, 2, [1, 2]);
Fig6.a.imageCData = imread("Fig6a.png");
image(Fig6.a.imageCData);
set(axes, "XTickLabel", "");
set(axes, "YTickLabel", "");


% Fig6b 
subplot(4, 2, 3)
xChi = cell2mat(cellfun(@(x, y) [x(3).trialNum, y(3).trialNum], {selectRes.spkDev.correct}', {selectRes.spkDev.wrong}', "UniformOutput", false));
Fig6.b.chitestP = chi2test(xChi);
Fig6.b.behavRes = {selectRes.collectRes.behavRes}';
cellfun(@(x, y) NoveltySU.plot.multiPlot(gca, Fig6.devFreq, x, y), Fig6.b.behavRes, Fig6.colors, "UniformOutput", false);
xlabel("Frequency Ratio(dev/std)");
ylabel("The Ratio of Pressing Button");

% Fig6d
subplot(4, 2, 4)
for sIndex = 1 : 3
Fig6.d.respRaw{sIndex, 1} = cell2mat(cellfun(@(x) x(sIndex).behavRes, {popRes.collectRes}', "UniformOutput", false)');
Fig6.d.respMean{sIndex, 1} = mean(cell2mat(cellfun(@(x) x(sIndex).behavRes, {popRes.collectRes}', "UniformOutput", false)'), 2);
Fig6.d.respSE{sIndex, 1} = SE(cell2mat(cellfun(@(x) x(sIndex).behavRes, {popRes.collectRes}', "UniformOutput", false)'), 2);
errorbar(0:4, Fig6.d.respMean{sIndex, 1}, Fig6.d.respSE{sIndex, 1}, "color", Fig6.colors(sIndex), "LineWidth", 2); hold on;
end
for dIndex = 1 : 5
    respRaw = cellfun(@(x) reshape(x(dIndex, :), 1, [])', Fig6.d(1).respRaw, "UniformOutput", false);
[Fig6.d(dIndex).anovaP, Fig6.d(dIndex).postHoc] = mAnovaCell(respRaw, "label", [1;3;9]);
[~, Fig6.d(dIndex).ttestP] = ttest(respRaw{1}, respRaw{3});
end
ylim([0, 1])
xlabel("Frequency Ratio(log((dev/std))");
ylabel("Firing Rate(Hz)");


% Fig6c top
subplot(4, 2, 5)
fr = NoveltySU.utils.FR139.testFR139(selectRes.trialAll(firstTrial:lastTrial));
Fig6.c.frMean_Early = fr.Mean_Early;
Fig6.c.frSE_Early = fr.SE_Early;
for sIndex = 1 : 3
errorbar(Fig6.devFreq, Fig6.c.frMean_Early(sIndex, :), Fig6.c.frSE_Early(sIndex, :), "color", Fig6.colors(sIndex)); hold on;
end
ylim([0, 165]);
xlabel("Frequency Ratio(dev/std)");
ylabel("Firing Rate(Hz)");

%  Fig6c bottom
subplot(4, 2, 7)
Fig6.c.frMean_Late = fr.Mean_Late;
Fig6.c.frSE_Late = fr.SE_Late;
for dIndex = 1 : 5
[Fig6.c(dIndex).anovaP, Fig6.c(dIndex).postHoc] = mAnovaCell(fr.Raw_Late(:, dIndex), "label", [1;3;9]);
end
for sIndex = 1 : 3
errorbar(Fig6.devFreq, Fig6.c(1).frMean_Late(sIndex, :), Fig6.c(1).frSE_Late(sIndex, :), "color", Fig6.colors(sIndex)); hold on;
end
ylim([0, 150]);
xlabel("Frequency Ratio(dev/std)");
ylabel("Firing Rate(Hz)");

% Fig6e top
subplot(4, 2, 6)
fr = cellfun(@(x, y) NoveltySU.utils.FR139.testFR139(x(y(1):y(2))), {popRes.trialAll}', num2cell([firstTrial, lastTrial], 2), "UniformOutput", false);
for sIndex = 1 : 3
Fig6.e.respMean_Early{sIndex, 1} = meanExcludeNaN(cell2mat(changeCellRowNum(cellfun(@(x) x.Mean_Early(sIndex, :)', fr, "UniformOutput", false))'), 1);
Fig6.e.respSE_Early{sIndex, 1} = SEExcludeNaN(cell2mat(changeCellRowNum(cellfun(@(x) x.Mean_Early(sIndex, :)', fr, "UniformOutput", false))'), 1);
errorbar(0:4, Fig6.e.respMean_Early{sIndex, 1}, Fig6.e.respSE_Early{sIndex, 1}, "color", Fig6.colors(sIndex), "LineWidth", 2); hold on;
end
ylim([15, 75]);
xlabel("Frequency Ratio(log((dev/std))");
ylabel("Firing Rate(Hz)");

% Fig6e bottom
subplot(4, 2, 8)
for sIndex = 1 : 3
Fig6.e.respRaw_Late{sIndex, 1} = cell2mat(changeCellRowNum(cellfun(@(x) x.Mean_Late(sIndex, :)', fr, "UniformOutput", false))');
Fig6.e.respMean_Late{sIndex, 1} = meanExcludeNaN(cell2mat(changeCellRowNum(cellfun(@(x) x.Mean_Late(sIndex, :)', fr, "UniformOutput", false))'), 1);
Fig6.e.respSE_Late{sIndex, 1} = SEExcludeNaN(cell2mat(changeCellRowNum(cellfun(@(x) x.Mean_Late(sIndex, :)', fr, "UniformOutput", false))'), 1);
errorbar(0:4, Fig6.e.respMean_Late{sIndex, 1}, Fig6.e.respSE_Late{sIndex, 1}, "color", Fig6.colors(sIndex), "LineWidth", 2); hold on;
end
temp = cellfun(@(x) x(:, 3), Fig6.e.respRaw_Late, "UniformOutput", false);
[Fig6.e.anovaP, Fig6.e.postHoc] = mAnovaCell(temp, "label", [1;3;9]);
[~, Fig6.e.ttestP_3_9] = ttest(temp{2}, temp{3});
[~, Fig6.e.ttestP_1_9] = ttest(temp{1}, temp{3});
[~, Fig6.e.ttestP_1_3] = ttest(temp{1}, temp{2});

ylim([15, 75]);
xlabel("Frequency Ratio(log((dev/std))");
ylabel("Firing Rate(Hz)");

save(strcat(getRootDirPath(mfilename("fullpath"), 1), "Figure6_Plot.mat"), "Fig6", "-v7.3");

