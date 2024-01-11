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

%% Fig2 I-J
Fig = figure;
maximizeFig(Fig);
% Fig 2
subplot(2, 2, 1)
colors = ["r-", "b-"];
for mIndex = 1 : 2 % 1:Monica 2:CM
Fig2.i(mIndex).DPValue = cell2mat(cellfun(@(x) x.DP(:, 2), {popRes(matchIdx{mIndex}).collectRes}', "UniformOutput", false)');
Fig2.i(mIndex).DPPlot = [popRes(1).collectRes.DP(:, 1), Fig2.i(mIndex).DPValue];
Fig2.i(mIndex).DPpvalue = cell2mat(cellfun(@(x) [x.p]', {popRes(matchIdx{mIndex}).DPRes}', "UniformOutput", false)');
plot(Fig2.i(mIndex).DPPlot(:, 1), Fig2.i(mIndex).DPValue, colors(mIndex)); hold on 
end

xlabel("Time from DevOnset");
ylabel("DRP Value")

% Fig 2b 
subplot(2, 2, 3)
temp = cell2mat(cellfun(@(x, y) [x.DP(1, 2), double(y(1).p < 0.05)], {popSelect.collectRes}', {popSelect.DPRes}', "UniformOutput", false));
Fig2.j1.DP = temp(:, 1);
Fig2.j1.Sig = temp(temp(:, 2) == 1);
Fig2.j1.noSig = temp(temp(:, 2) == 0);
Fig2.j1.mean = mean(temp(:, 1));
[~, Fig2.j1.ttest] = ttest(temp(:, 1), 0.5);
histogram(Fig2.j1.Sig, "BinEdges", 0.1:0.1:1); hold on;
histogram(Fig2.j1.noSig, "BinEdges", 0.1:0.1:1); hold on;
[Fig2.j1.sigBar, Fig2.j1.Edge] = histcounts(Fig2.j1.Sig, 0.1:0.1:1);
[Fig2.j1.noSigBar, Fig2.j1.Edge] = histcounts(Fig2.j1.noSig, 0.1:0.1:1);

title("DRP Value in [0, 100]");
xlabel("DRP Value");
ylabel("Counts")


% Fig 2c 
subplot(2, 2, 4)
temp = cell2mat(cellfun(@(x, y) [x.DP(6, 2), double(y(6).p < 0.05)], {popSelect.collectRes}', {popSelect.DPRes}', "UniformOutput", false));
Fig2.j2.DP = temp(:, 1);
Fig2.j2.Sig = temp(temp(:, 2) == 1);
Fig2.j2.noSig = temp(temp(:, 2) == 0);
Fig2.j2.mean = mean(temp(:, 1));
[~, Fig2.j2.ttest] = ttest(temp(:, 1), 0.5);
histogram(Fig2.j2.Sig, "BinEdges", 0.3:0.1:1); hold on;
histogram(Fig2.j2.noSig, "BinEdges", 0.3:0.1:1); hold on;
[Fig2.j2.sigBar, Fig2.j2.Edge] = histcounts(Fig2.j2.Sig, 0.1:0.1:1);
[Fig2.j2.noSigBar, Fig2.j2.Edge] = histcounts(Fig2.j2.noSig, 0.1:0.1:1);

title("DRP Value in [250, 350]");
xlabel("DRP Value");
ylabel("Counts")

monicaIdx = contains({popSelect.Date}', "Monica");
cmIdx     = contains({popSelect.Date}', "CM");
Fig2.j2.monicaIdx = monicaIdx;
Fig2.j2.cmIdx = cmIdx;
save(strcat(getRootDirPath(mfilename("fullpath"), 1), "Figure2I-J_Plot.mat"), "Fig2", "-v7.3");

