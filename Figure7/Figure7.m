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

% select data
matchIdx = NoveltySU.utils.selectData.decideRegion(popRes, "A1");
popSelect = popRes(cell2mat(matchIdx));
slopeEdge = [4, 10];

%% spkStd Process
spkStd = {popSelect.spkStd}';
stdTest = cell2mat(cellfun(@(x) NoveltySU.utils.spkStdProcess.spkStdTest(x, "slopeEdge", slopeEdge), spkStd, "uni", false));
stdTest = addFieldToStruct(stdTest, [{popSelect.Date}', {popSelect.protStr}'], ["Date"; "protStr"]);

%% Fig7
Fig = figure;
set(Fig, "Position", [0, 235.4, 1528, 358]);

% Fig 7a Left 
% v1:CM_20191230_A51L19cell24 ActiveFreqRight ID:59
% v2:Monica_20191016_A21R24cell78 ActiveFreqLeft ID:43
subplot(2, 2, 1)
Fig7.stdNum = 1 : 10;
Fig7.a.Mean_Left = stdTest(59).frMean_Early;
Fig7.a.SE_Left = stdTest(59).frSE_Early;
Fig7.a.xFit_Left = slopeEdge(1) : slopeEdge(end);
Fig7.a.yFit_Left = polyval(stdTest(59).p_Early, Fig7.a.xFit_Left);
Fig7.a. R2_Left = stdTest(59).R2_Early;

errorbar(Fig7.stdNum, Fig7.a.Mean_Left, Fig7.a.SE_Left, "r-", "LineWidth", 2); hold on
plot(Fig7.a.xFit_Left, Fig7.a.yFit_Left, "b-");
xlabel("Standard No.");
ylabel("Firing Rate(Hz)");
title("an example with prediction suppression");

% Fig 7a Right 
% CM_20191226_A51L20cell23 ActiveFreqRight ID:58
% Monica_20190728_A23R26cell59  ID:9/31
subplot(2, 2, 2)
Fig7.a.Mean_Right = stdTest(58).frMean_Early;
Fig7.a.SE_Right = stdTest(58).frSE_Early;
Fig7.a.xFit_Right = slopeEdge(1) : slopeEdge(end);
Fig7.a.yFit_Right = polyval(stdTest(58).p_Early, Fig7.a.xFit_Right);
errorbar(Fig7.stdNum, Fig7.a.Mean_Right, Fig7.a.SE_Right, "r-", "LineWidth", 2); hold on
plot(Fig7.a.xFit_Right, Fig7.a.yFit_Right, "b-");
Fig7.a. R2_Right = stdTest(58).R2_Late;
xlabel("Standard No.");
ylabel("Firing Rate(Hz)");
title("an example without adaptation");

% Fig 7b Monica GYM version
subplot(2, 2, 3)
Fig7.b.sigSlope = [stdTest([stdTest.R2_Early]' > 0.5 ).slope_Early]';
Fig7.b.noSigSlope = [stdTest([stdTest.R2_Early]' <= 0.5 ).slope_Early]';
Fig7.b.SlopeMean = mean([Fig7.b.sigSlope; Fig7.b.noSigSlope]);
[Fig7.b.sigBin, Fig7.b.binEdge] = histcounts(Fig7.b.sigSlope, -3.5:0.5:2);
Fig7.b.binEdge = Fig7.b.binEdge+0.25;
Fig7.b.noSigBin = histcounts(Fig7.b.noSigSlope, -3.5:0.5:2);
[~, Fig7.b.ttestP] = ttest([Fig7.b.sigSlope; Fig7.b.noSigSlope], 0);
histogram(Fig7.b.sigSlope-0.5, "BinWidth", 1, "BinEdges", -2.5:0.5:2, "DisplayName", "R2>=0.5"); hold on
histogram(Fig7.b.noSigSlope-0.5, "BinWidth", 1, "BinEdges", -2.5:0.5:2, "DisplayName", "R2<0.5"); hold on
legend
title("threshold distribution of Monica");
xlabel("theshold");
ylabel("counts");


% save
save(strcat(getRootDirPath(mfilename("fullpath"), 1), "Figure7_Plot.mat"), "Fig7", "-v7.3");