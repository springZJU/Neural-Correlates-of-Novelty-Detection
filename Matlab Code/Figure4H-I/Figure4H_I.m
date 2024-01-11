ccc
ROOTPATH = strcat(getRootDirPath(mfilename("fullpath"), 4), "Data\ProcessData\");
cd(getRootDirPath(mfilename("fullpath"), 2))
protStr = "ActiveFreqRight";
temp = dirItem(strcat(ROOTPATH, protStr), "spkData.mat");
popRes_A = cell2mat(cellfun(@(x) NoveltySU.population.loadPopData(x), temp.file, "UniformOutput", false));
popRes_A = addFieldToStruct(popRes_A, repmat(cellstr(protStr), length(popRes_A), 1), "protStr");

protStr = "ActiveFreqLeft";
temp = dirItem(strcat(ROOTPATH, protStr), "spkData.mat");
popRes_B = cell2mat(cellfun(@(x) NoveltySU.population.loadPopData(x), temp.file, "UniformOutput", false));
popRes_B = addFieldToStruct(popRes_B, repmat(cellstr(protStr), length(popRes_B), 1), "protStr");

protStr = "ActiveNoneFreqRight";
temp = dirItem(strcat(ROOTPATH, protStr), "spkData.mat");
popRes_C = cell2mat(cellfun(@(x) NoveltySU.population.loadPopData(x), temp.file, "UniformOutput", false));
popRes_C = addFieldToStruct(popRes_C, repmat(cellstr(protStr), length(popRes_C), 1), "protStr");

% merge
popRes = [popRes_A; popRes_B; popRes_C];

%% select data
matchIdx = NoveltySU.utils.selectData.decideRegion(popRes, "A1");
popSelect = popRes(cell2mat(matchIdx));
selectRes = popSelect(matches({popSelect.Date}', "Monica_20190905_A20R23cell67") & matches({popSelect.protStr}', "ActiveFreqRight"));
spkDev = selectRes.spkDev;
devType = [spkDev.all.devType]' / spkDev.all(1).devType;
devStr = cellfun(@(x) num2str(roundn(x, -2)), num2cell(devType(2:5)), "UniformOutput", false);

MonkeyIdx = contains({popSelect.Date}', "Monica");
CMIdx = contains({popSelect.Date}', "CM");
popMonica = popSelect(MonkeyIdx);
popCM = popSelect(CMIdx);

%% Fig 7
Fig = figure;
% Fig4H
subplot(3, 2, [1, 2]);
lagWin = [200, 600];
Fig4.lagWin = lagWin;
Fig4.colors = ["#0000FF", "#FF00A5", "#FFA500", "#FF0000"]';
[Fig4.h.neuLag, Fig4.h.pushLag, neuAccumulate] = NoveltySU.utils.timeLag.calTimeLag(spkDev, lagWin, 0.5, "correct");
Fig4.h.Accum = neuAccumulate;
cellfun(@(x, y) NoveltySU.plot.multiPlot(gca, x(:, 1), x(:, 2), y, "-", 1.5), Fig4.h.Accum(2:end), Fig4.colors, "UniformOutput", false);

% Fig4I left Monica
subplot(3, 2, 3);
[neuLag, pushLag] = cellfun(@(x) NoveltySU.utils.timeLag.calTimeLag_ByTrial(x, lagWin, 0.5, "correct"), {popMonica.spkDev}', "UniformOutput", false);
Fig4.i.pushLag.Monica = changeCellRowNum(pushLag);
Fig4.i.neuLag.Monica = changeCellRowNum(neuLag);
[Fig4.i.slope_Monica, Fig4.i.intercept_Monica, ~, ~, Fig4.i.r_Monica, Fig4.i.p_Monica] = regress_perp(cell2mat(Fig4.i.neuLag.Monica(2:end)), cell2mat(Fig4.i.pushLag.Monica(2:end)));
xFit = [300; 510];
Fig4.i.dashline_Monica = [xFit, Fig4.i.slope_Monica*(xFit)+Fig4.i.intercept_Monica];
[~, Fig4.i.ttestP_Monica] = ttest(cell2mat(Fig4.i.neuLag.Monica(2:end)), cell2mat(Fig4.i.pushLag.Monica(2:end)), "Tail", "right");
% Fig4.i.pushLag.Monica = changeCellRowNum(cellfun(@(x) [0, cellfun(@mean, {x.correct(2:end).pushLatency})]', {popMonica.spkDev}, "UniformOutput", false)');
% Fig4.i.neuLag.Monica = num2cell(cell2mat(cellfun(@(x) x.neuLag, {popMonica.collectRes}, "UniformOutput", false)'), 1)';
cellfun(@(x, y, z) NoveltySU.plot.multiPlot(gca, x, y, z, ".", 1, 20), Fig4.i.neuLag.Monica(2:end), Fig4.i.pushLag.Monica(2:end), Fig4.colors, "UniformOutput", false);
plot(Fig4.lagWin, Fig4.lagWin, "k--");
xlim([260, 460]); ylim([260, 460]);

% Fig4I right CM
subplot(3, 2, 4);
[neuLag, pushLag] = cellfun(@(x) NoveltySU.utils.timeLag.calTimeLag_ByTrial(x, lagWin, 0.5, "correct"), {popCM.spkDev}', "UniformOutput", false);
Fig4.i.pushLag.CM = changeCellRowNum(pushLag);
Fig4.i.neuLag.CM = changeCellRowNum(neuLag);
[Fig4.i.slope_CM, Fig4.i.intercept_CM, ~, ~, Fig4.i.r_CM, Fig4.i.p_CM] = regress_perp(cell2mat(Fig4.i.neuLag.CM(2:end)), cell2mat(Fig4.i.pushLag.CM(2:end)));
xFit = [370; 448];
Fig4.i.dashline_CM = [xFit, Fig4.i.slope_CM*(xFit)+Fig4.i.intercept_CM];
[~, Fig4.i.ttestP_CM] = ttest(cell2mat(Fig4.i.neuLag.CM(2:end)), mean(cell2mat(Fig4.i.pushLag.CM(2:end))), "Tail", "right");


% Fig4.i.pushLag.CM = changeCellRowNum(cellfun(@(x) [0, cellfun(@mean, {x.correct(2:end).pushLatency})]', {popCM.spkDev}, "UniformOutput", false)');
% Fig4.i.neuLag.CM = num2cell(cell2mat(cellfun(@(x) x.neuLag, {popCM.collectRes}, "UniformOutput", false)'), 1)';
cellfun(@(x, y, z) NoveltySU.plot.multiPlot(gca, x, y, z, ".", 1, 20), Fig4.i.neuLag.CM(2:end), Fig4.i.pushLag.CM(2:end), Fig4.colors, "UniformOutput", false);
plot(Fig4.lagWin, Fig4.lagWin, "k--");
xlim([260, 460]); ylim([260, 460]);

% Figb Monica push/neural distribution
binpara.binsize = 100; binpara.binstep = 10;
temp = Fig4.i.pushLag.Monica;
psthTemp = cellfun(@(x) calPsth(x, binpara, binpara.binsize*10 , "NTRIAL", length(x), "EDGE", [0, 600]), temp, "uni", false);
Fig4.i.pushDistribution_t = psthTemp{1}(:, 1);  
Fig4.i.pushDistribution_Monica =  cell2mat(cellfun(@(x) x(:, 2), psthTemp(2:end)', "uni", false));

temp = Fig4.i.neuLag.Monica;
psthTemp = cellfun(@(x) calPsth(x, binpara, binpara.binsize*10 , "NTRIAL", length(x), "EDGE", [0, 600]), temp, "uni", false);
Fig4.i.neuralDistribution_Monica =  cell2mat(cellfun(@(x) x(:, 2), psthTemp(2:end)', "uni", false));

% Figb CM push/neural distribution
binpara.binsize = 100; binpara.binstep = 10;
temp = Fig4.i.pushLag.CM;
psthTemp = cellfun(@(x) calPsth(x, binpara, binpara.binsize*10 , "NTRIAL", length(x), "EDGE", [0, 600]), temp, "uni", false);
Fig4.i.pushDistribution_CM =  cell2mat(cellfun(@(x) x(:, 2), psthTemp(2:end)', "uni", false));

temp = Fig4.i.neuLag.CM;
psthTemp = cellfun(@(x) calPsth(x, binpara, binpara.binsize*10 , "NTRIAL", length(x), "EDGE", [0, 600]), temp, "uni", false);
Fig4.i.neuralDistribution_CM =  cell2mat(cellfun(@(x) x(:, 2), psthTemp(2:end)', "uni", false));

%%
save(strcat(getRootDirPath(mfilename("fullpath"), 1), "Figure4H_I_Plot.mat"), "Fig4", "-v7.3");

