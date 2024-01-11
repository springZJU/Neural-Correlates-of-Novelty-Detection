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

threshold.behavThr = cell2mat(cellfun(@(x) x.behavThr, {popSelect.collectRes}', "UniformOutput", false));
threshold.neuThr_Early = cell2mat(cellfun(@(x) x.neuThr_Early, {popSelect.collectRes}', "UniformOutput", false));
threshold.neuThr_Late = cell2mat(cellfun(@(x) x.neuThr_Late, {popSelect.collectRes}', "UniformOutput", false));


%% Fig 3f
Fig = figure;
set(Fig, "Position", [401.8   41.8  756.8  741.6]);
Fig3F_G(1).behavThr = threshold.behavThr(MonicaIdx);
Fig3F_G(1).neuThr_Early = threshold.neuThr_Early(MonicaIdx);
Fig3F_G(1).neuThr_Late = threshold.neuThr_Late(MonicaIdx);
Fig3F_G(2).behavThr = threshold.behavThr(CMIdx);
Fig3F_G(2).neuThr_Early = threshold.neuThr_Early(CMIdx);
Fig3F_G(2).neuThr_Late = threshold.neuThr_Late(CMIdx);
% left
subplot(5, 2, [1, 3])
scatter(Fig3F_G(1).behavThr, Fig3F_G(1).neuThr_Early, 20, "green", "square", "LineWidth", 1); hold on;
scatter(Fig3F_G(2).behavThr, Fig3F_G(2).neuThr_Early, 20, "magenta", "^", "LineWidth", 1); hold on;
plot([0, 3], [0, 3], "k--"); hold on;  plot([0, 3], [1, 1], "k--"); hold on;  plot([1, 1], [0, 3], "k--"); hold on;
xlabel("Psychophysical threshold");
ylabel("Neuronal Threshold");
title("0-100ms")
[~, Fig3F_GTest.p_Early] = ttest(cell2mat({Fig3F_G.behavThr}'), cell2mat({Fig3F_G.neuThr_Early}'));
[~, Fig3F_GTest.p_Late] = ttest(cell2mat({Fig3F_G.behavThr}'), cell2mat({Fig3F_G.neuThr_Late}'));


% right
subplot(5, 2, [2, 4])
scatter(Fig3F_G(1).behavThr, Fig3F_G(1).neuThr_Late, 20, "green", "square", "LineWidth", 1); hold on;
scatter(Fig3F_G(2).behavThr, Fig3F_G(2).neuThr_Late, 20, "magenta", "^", "LineWidth", 1); hold on;
plot([0, 3], [0, 3], "k--"); hold on;  plot([0, 3], [1, 1], "k--"); hold on;  plot([1, 1], [0, 3], "k--"); hold on;
xlabel("Psychophysical threshold");
ylabel("Neuronal Threshold");
title("250-350ms")


% Fig 3g
% 行为阈值
thrStr = ["behavThr", "neuThr_Early", "neuThr_Late"];
titleStr = ["行为阈值分布", "0-100ms 神经元阈值分布", "250-350ms 神经元阈值分布"];
ylabelStr = ["Psychophysical threshold", "Neuronal threshold", "Neuronal threshold"];
for tIndex = 1 : 3
mAxes = subplot(5, 2, [1, 2] + (tIndex+1)*2);
binEdges = 1:0.125:3;
histogram(Fig3F_G(1).(thrStr(tIndex)), "BinEdges", binEdges, "DisplayName", "Monica"); hold on;
histogram(Fig3F_G(2).(thrStr(tIndex)), "BinEdges", binEdges, "DisplayName", "CM"); hold on;
xticks(1:0.25:3);
xlabel("Psychophysical threshold");
ylabel("neuron counts");
legend
end

save(strcat(getRootDirPath(mfilename("fullpath"), 1), "Figure3F_G_Plot.mat"), "Fig3F_G", "Fig3F_GTest", "-v7.3");

