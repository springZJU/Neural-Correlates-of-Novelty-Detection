ccc
ROOTPATH = strcat(getRootDirPath(mfilename("fullpath"), 4), "Data\ProcessData\");
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

protStr = "ActiveFreqNoResponse";
temp = dirItem(strcat(ROOTPATH, protStr), "spkData.mat");
popRes_D = cell2mat(cellfun(@(x) NoveltySU.population.loadPopData(x), temp.file, "UniformOutput", false));
popRes_D = addFieldToStruct(popRes_D, repmat(cellstr(protStr), length(popRes_D), 1), "protStr");

popResDRP = [popRes_A; popRes_C; popRes_D; popRes_B];
[~, uniqueIdx] = unique(string({popResDRP.Date}));
popResDRP = popResDRP(uniqueIdx);
clear popRes_A popRes_B popRes_C popRes_D

%% select data
popMonica = popResDRP(contains({popResDRP.Date}', "Monica"));
temp = regexpi(string({popMonica.Date})', "A\d*R\d*");
MonicaSel = cell2mat(cellfun(@(x) logical(max([0, x])), temp, "UniformOutput", false));
popMonica = popMonica(MonicaSel);

popCM = popResDRP(contains({popResDRP.Date}', "CM"));
temp = regexpi(string({popCM.Date})', "A\d*L\d*");
CMSel = cell2mat(cellfun(@(x) logical(max([0, x])), temp, "UniformOutput", false));
popCM = popCM(CMSel);


%% Monica
APpos = str2double(erase(string(regexp({popMonica.Date}', "A\d*", "match")), "A"));
LRPos = str2double(erase(string(regexp({popMonica.Date}', "R\d*", "match")), "R"));
popMonica = addFieldToStruct(popMonica, [num2cell(APpos), num2cell(LRPos)], ["APPos"; "LRPos"]);
thrIdx_Monica = ~matches({popMonica.protStr}', "ActiveFreqLeft");
DRPDist.DRP_Monica = generateDistribution(popMonica, "DRP");
Sfig4.b.DRP_Monica = [DRPDist.DRP_Monica; zeros(2, size(DRPDist.DRP_Monica, 2))];
thrDist.thr_Monica = generateDistribution(popMonica(thrIdx_Monica), "thr");
Sfig4.c.thr_Monica = [thrDist.thr_Monica; zeros(5, size(thrDist.thr_Monica, 2))];
%% CM
APpos = str2double(erase(string(regexp({popCM.Date}', "A\d*", "match")), "A"));
LRPos = str2double(erase(string(regexp({popCM.Date}', "L\d*", "match")), "L"));
popCM = addFieldToStruct(popCM, [num2cell(APpos), num2cell(LRPos)], ["APPos"; "LRPos"]);
thrIdx_CM = find(~matches({popCM.protStr}', "ActiveFreqLeft"));
DRPDist.DRP_CM = generateDistribution(popCM, "DRP");
Sfig4.b.DRP_CM = DRPDist.DRP_CM;
thrDist.thr_CM = generateDistribution(popCM(thrIdx_CM), "thr");
Sfig4.c.thr_CM = [thrDist.thr_CM; zeros(5, size(thrDist.thr_CM, 2))];

%% SFig 3
figure
% Sfig4b DRP_CM
subplot(3, 2, 3)
imagesc(Sfig4.b.DRP_CM, [0.4, 0.9]);
c = colormap(gca, "jet"); c(1, :) = 1;  colormap(gca, c);
xlim([9.5, 21.5]);
ylim([43.5, 57.5])
set(gca, "XTickLabel", ""); set(gca, "YTickLabel", "");

% Sfig4b DRP_Monica
subplot(3, 2, 4)
imagesc(Sfig4.b.DRP_Monica, [0.4, 0.9]);
c = colormap(gca, "jet"); c(1, :) = 1;  colormap(gca, c);
xlim([18.5, 31.5]);
ylim([9.5, 30.5])
set(gca, "XTickLabel", ""); set(gca, "YTickLabel", "");

% Sfig4c thr_CM
subplot(3, 2, 5)
imagesc(Sfig4.c.thr_CM, [1, 2]);
c = colormap(gca, "jet"); c(1, :) = 1;  colormap(gca, c);
xlim([9.5, 21.5]);
ylim([45.5, 58.5])
set(gca, "XTickLabel", ""); set(gca, "YTickLabel", "");

% Sfig4b thr_Monica
subplot(3, 2, 6)
imagesc(Sfig4.c.thr_Monica, [1, 2]);
c = colormap(gca, "jet"); c(1, :) = 1;  colormap(gca, c);
xlim([19.5, 31.5]);
ylim([9.5, 28.5])
set(gca, "XTickLabel", ""); set(gca, "YTickLabel", "");



