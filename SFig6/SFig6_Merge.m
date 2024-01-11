ccc
ROOTPATH = strcat(getRootDirPath(mfilename("fullpath"), 4), "Data\ProcessData\");
protStr = "ActiveFreqRight";
temp = dirItem(strcat(ROOTPATH, protStr), "spkData.mat");
popRes_A = cell2mat(cellfun(@(x) NoveltySU.population.loadPopData(x), temp.file, "UniformOutput", false));
popRes_A = addFieldToStruct(popRes_A, repmat(cellstr(protStr), length(popRes_A), 1), "protStr");

popRes_B = [];

protStr = "ActiveNoneFreqRight";
temp = dirItem(strcat(ROOTPATH, protStr), "spkData.mat");
popRes_C = cell2mat(cellfun(@(x) NoveltySU.population.loadPopData(x), temp.file, "UniformOutput", false));
popRes_C = addFieldToStruct(popRes_C, repmat(cellstr(protStr), length(popRes_C), 1), "protStr");

% merge
popRes = [popRes_A; popRes_B; popRes_C];

% select data
matchIdx = NoveltySU.utils.selectData.decideRegion(popRes, "A1");
popSelect = popRes(cell2mat(matchIdx));
MonicaIdx = contains({popSelect.Date}', "Monica");
CMIdx = contains({popSelect.Date}', "CM");
popMonica = popSelect(MonicaIdx);
popCM = popSelect(CMIdx);

%% SFig4
figure
[frTemp, pushTemp] = cellfun(@(x) FR78910(x), {popSelect.trialAll}', "UniformOutput", false);
fr = cell2mat(frTemp);
push = cell2mat(pushTemp);

Axes(1) = subplot(3, 2, 1);
Sfig6.a.pushMean = cell2mat(cellfun(@(x) mean(x, 1), changeCellRowNum({push.pushRatio}'), "UniformOutput", false));
Sfig6.a.pushSE = cell2mat(cellfun(@(x) SE(x, 1), changeCellRowNum({push.pushRatio}'), "UniformOutput", false));

Axes(2) = subplot(3, 2, 3);
Sfig6.b.frMean_Early =  cell2mat(cellfun(@(x) mean(x, 1), changeCellRowNum({fr.Mean_Early}'), "UniformOutput", false));
Sfig6.b.frSE_Early =  cell2mat(cellfun(@(x) SE(x, 1), changeCellRowNum({fr.Mean_Early}'), "UniformOutput", false));

Axes(3) = subplot(3, 2, 5);
Sfig6.c.frMean_Late =  cell2mat(cellfun(@(x) mean(x, 1), changeCellRowNum({fr.Mean_Late}'), "UniformOutput", false));
Sfig6.c.frSE_Late =  cell2mat(cellfun(@(x) SE(x, 1), changeCellRowNum({fr.Mean_Late}'), "UniformOutput", false));
temp = changeCellRowNum({fr.Mean_Late}');
[~, Sfig6.c.ttest] = ttest(temp{1}(:, 5), temp{4}(:, 5));


colors = ["r-", "m-", "b-", "k-"];
for sIndex = 1 : 4
    errorbar(Axes(1), Sfig6.a.pushMean(sIndex, :), Sfig6.a.pushSE(sIndex, :), colors(sIndex)); hold on
    errorbar(Axes(2), Sfig6.b.frMean_Early(sIndex, :), Sfig6.b.frSE_Early(sIndex, :), colors(sIndex)); hold on
    errorbar(Axes(3), Sfig6.c.frMean_Late(sIndex, :), Sfig6.c.frSE_Late(sIndex, :), colors(sIndex)); hold on
end