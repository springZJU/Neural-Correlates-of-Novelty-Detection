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
popMonica = popSelect(MonicaIdx);
popCM = popSelect(CMIdx);

%% compute neuThreshold yThr = 0.7
yThr = 0.7;
neuThrRes(1).yThr = yThr; behavThrRes(1).yThr = yThr;
neuThrRes(1).winEarly.Monica = cell2mat(cellfun(@(x) min([x(1).xFit(find(x(1).yFit >= yThr, 1, "first")), 2.9]), {popMonica.neuThrRes}', "UniformOutput", false));
neuThrRes(1).winLate.Monica = cell2mat(cellfun(@(x) min([x(2).xFit(find(x(2).yFit >= yThr, 1, "first")), 2.9]), {popMonica.neuThrRes}', "UniformOutput", false));
neuThrRes(1).winEarly.CM = cell2mat(cellfun(@(x) min([x(1).xFit(find(x(1).yFit >= yThr, 1, "first")), 2.9]), {popCM.neuThrRes}', "UniformOutput", false));
neuThrRes(1).winLate.CM = cell2mat(cellfun(@(x) min([x(2).xFit(find(x(2).yFit >= yThr, 1, "first")), 2.9]), {popCM.neuThrRes}', "UniformOutput", false));
behavThrRes(1).Monica = cell2mat(cellfun(@(x) x.xFit(find(x.yFit >= yThr, 1, "first")), {popMonica.behavThrRes}', "UniformOutput", false));
behavThrRes(1).CM = cell2mat(cellfun(@(x) x.xFit(find(x.yFit >= yThr, 1, "first")), {popCM.behavThrRes}', "UniformOutput", false));

%% compute neuThreshold yThr = 0.6
yThr = 0.6;
neuThrRes(2).yThr = yThr; behavThrRes(2).yThr = yThr;
neuThrRes(2).winEarly.Monica = cell2mat(cellfun(@(x) min([x(1).xFit(find(x(1).yFit >= yThr, 1, "first")), 2.9]), {popMonica.neuThrRes}', "UniformOutput", false));
neuThrRes(2).winLate.Monica = cell2mat(cellfun(@(x) min([x(2).xFit(find(x(2).yFit >= yThr, 1, "first")), 2.9]), {popMonica.neuThrRes}', "UniformOutput", false));
neuThrRes(2).winEarly.CM = cell2mat(cellfun(@(x) min([x(1).xFit(find(x(1).yFit >= yThr, 1, "first")), 2.9]), {popCM.neuThrRes}', "UniformOutput", false));
neuThrRes(2).winLate.CM = cell2mat(cellfun(@(x) min([x(2).xFit(find(x(2).yFit >= yThr, 1, "first")), 2.9]), {popCM.neuThrRes}', "UniformOutput", false));
behavThrRes(2).Monica = cell2mat(cellfun(@(x) x.xFit(find(x.yFit >= yThr, 1, "first")), {popMonica.behavThrRes}', "UniformOutput", false));
behavThrRes(2).CM = cell2mat(cellfun(@(x) x.xFit(find(x.yFit >= yThr, 1, "first")), {popCM.behavThrRes}', "UniformOutput", false));

%% SFig2
Fig = figure;
set(Fig, "Position", [401.8   41.8  756.8  741.6]);

SFig2.a.behavThr.Monica = behavThrRes(1).Monica;
SFig2.a.behavThr.CM = behavThrRes(1).CM;
SFig2.a.neuThr.Monica_Early = neuThrRes(1).winEarly.Monica;
SFig2.a.neuThr.CM_Early = neuThrRes(1).winEarly.CM;
SFig2.a.neuThr.Monica_Late = neuThrRes(1).winLate.Monica;
SFig2.a.neuThr.CM_Late = neuThrRes(1).winLate.CM;

% SFig2a left
subplot(2, 2, 1)
scatter(SFig2.a.behavThr.Monica, SFig2.a.neuThr.Monica_Early, 20, "green", "square", "LineWidth", 1); hold on;
scatter(SFig2.a.behavThr.CM, SFig2.a.neuThr.CM_Early, 20, "magenta", "^", "LineWidth", 1); hold on;
plot([0, 3], [0, 3], "k--"); hold on;  plot([0, 3], [1, 1], "k--"); hold on;  plot([1, 1], [0, 3], "k--"); hold on;
xlabel("Psychophysical threshold");
ylabel("Neuronal Threshold");
title("0-100ms")

% SFig2a right
subplot(2, 2, 2)
scatter(SFig2.a.behavThr.Monica, SFig2.a.neuThr.Monica_Late, 20, "green", "square", "LineWidth", 1); hold on;
scatter(SFig2.a.behavThr.CM, SFig2.a.neuThr.CM_Late, 20, "magenta", "^", "LineWidth", 1); hold on;
plot([0, 3], [0, 3], "k--"); hold on;  plot([0, 3], [1, 1], "k--"); hold on;  plot([1, 1], [0, 3], "k--"); hold on;
xlabel("Psychophysical threshold");
ylabel("Neuronal Threshold");
title("0-100ms")

SFig2.b.behavThr.Monica = behavThrRes(2).Monica;
SFig2.b.behavThr.CM = behavThrRes(2).CM;
SFig2.b.neuThr.Monica_Early = neuThrRes(2).winEarly.Monica;
SFig2.b.neuThr.CM_Early = neuThrRes(2).winEarly.CM;
SFig2.b.neuThr.Monica_Late = neuThrRes(2).winLate.Monica;
SFig2.b.neuThr.CM_Late = neuThrRes(2).winLate.CM;

% SFig2b left
subplot(2, 2, 3)
scatter(SFig2.b.behavThr.Monica, SFig2.b.neuThr.Monica_Early, 20, "green", "square", "LineWidth", 1); hold on;
scatter(SFig2.b.behavThr.CM, SFig2.b.neuThr.CM_Early, 20, "magenta", "^", "LineWidth", 1); hold on;
plot([0, 3], [0, 3], "k--"); hold on;  plot([0, 3], [1, 1], "k--"); hold on;  plot([1, 1], [0, 3], "k--"); hold on;
xlabel("Psychophysical threshold");
ylabel("Neuronal Threshold");
title("0-100ms")

% SFig2b right
subplot(2, 2, 4)
scatter(SFig2.b.behavThr.Monica, SFig2.b.neuThr.Monica_Late, 20, "green", "square", "LineWidth", 1); hold on;
scatter(SFig2.b.behavThr.CM, SFig2.b.neuThr.CM_Late, 20, "magenta", "^", "LineWidth", 1); hold on;
plot([0, 3], [0, 3], "k--"); hold on;  plot([0, 3], [1, 1], "k--"); hold on;  plot([1, 1], [0, 3], "k--"); hold on;
xlabel("Psychophysical threshold");
ylabel("Neuronal Threshold");
title("0-100ms")

save(strcat(getRootDirPath(mfilename("fullpath"), 1), "SFig2_Plot.mat"), "SFig2", "-v7.3");
