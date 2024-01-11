ccc
ROOTPATH = strcat(getRootDirPath(mfilename("fullpath"), 4), "Data\ProcessData\");
cd(getRootDirPath(mfilename("fullpath"), 2))
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

threshold.neuThr_Early = cell2mat(cellfun(@(x) x.neuThr_Early, {popSelect.collectRes}', "UniformOutput", false));
threshold.neuThr_Late = cell2mat(cellfun(@(x) x.neuThr_Late, {popSelect.collectRes}', "UniformOutput", false));

popMonica = popSelect(MonicaIdx);
popCM = popSelect(CMIdx);

%% SFig3
Fig = figure;
set(Fig, "Position", [401.8   41.8  756.8  741.6]);
SFig3.a.neuThr_Monica = cell2mat(cellfun(@(x) x.neuThr_Early, {popMonica.collectRes}', "UniformOutput", false));
SFig3.a.neuThr_CM = cell2mat(cellfun(@(x) x.neuThr_Early, {popCM.collectRes}', "UniformOutput", false));
SFig3.a.DP_Monica = cell2mat(cellfun(@(x) x(1).value, {popMonica.DPRes}', "UniformOutput", false));
SFig3.a.DP_CM = cell2mat(cellfun(@(x) x(1).value, {popCM.DPRes}', "UniformOutput", false));
[SFig3.a.slope, SFig3.a.intercept, ~, ~, SFig3.a.r, SFig3.a.p] = regress_perp([SFig3.a.neuThr_Monica; SFig3.a.neuThr_CM], [SFig3.a.DP_Monica; SFig3.a.DP_CM]);
SFig3.a.xFit = 0:0.01:3; SFig3.a.yFit = SFig3.a.slope*SFig3.a.xFit + SFig3.a.intercept;



SFig3.b.neuThr_Monica = cell2mat(cellfun(@(x) x.neuThr_Late, {popMonica.collectRes}', "UniformOutput", false));
SFig3.b.neuThr_CM = cell2mat(cellfun(@(x) x.neuThr_Late, {popCM.collectRes}', "UniformOutput", false));
SFig3.b.DP_Monica = cell2mat(cellfun(@(x) x(6).value, {popMonica.DPRes}', "UniformOutput", false));
SFig3.b.DP_CM = cell2mat(cellfun(@(x) x(6).value, {popCM.DPRes}', "UniformOutput", false));
[SFig3.b.slope, SFig3.b.intercept, ~, ~, SFig3.b.r, SFig3.b.p] = regress_perp([SFig3.b.neuThr_Monica; SFig3.b.neuThr_CM], [SFig3.b.DP_Monica; SFig3.b.DP_CM]);
SFig3.b.xFit = 0:0.01:3; SFig3.b.yFit = SFig3.b.slope*SFig3.b.xFit + SFig3.b.intercept;


% SFig3a 
subplot(2, 2, 1)
scatter(SFig3.a.neuThr_Monica, SFig3.a.DP_Monica, 20, "green", "square", "LineWidth", 1); hold on;
scatter(SFig3.a.neuThr_CM, SFig3.a.DP_CM, 20, "magenta", "^", "LineWidth", 1); hold on;
plot([0, 3], [0.5, 0.5], "k--"); hold on;  
ylim([0.25, 1]);
xlabel("Psychophysical threshold");
ylabel("Neuronal Threshold");
title("0-100ms")

% SFig3b
subplot(2, 2, 2)
scatter(SFig3.b.neuThr_Monica, SFig3.b.DP_Monica, 20, "green", "square", "LineWidth", 1); hold on;
scatter(SFig3.b.neuThr_CM, SFig3.b.DP_CM, 20, "magenta", "^", "LineWidth", 1); hold on;
plot([0, 3], [0.5, 0.5], "k--"); hold on;  
ylim([0.25, 1]);
xlabel("Psychophysical threshold");
ylabel("Neuronal Threshold");
title("250-350ms")


save(strcat(getRootDirPath(mfilename("fullpath"), 1), "SFig3_Plot.mat"), "SFig3", "-v7.3");
