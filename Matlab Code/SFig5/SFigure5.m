ccc
ROOTPATH = strcat(getRootDirPath(mfilename("fullpath"), 4), "Data\ProcessData\");
protStr = "ActiveFreq139";
temp = dirItem(strcat(ROOTPATH, protStr), "spkData.mat");
popRes = cell2mat(cellfun(@(x) NoveltySU.population.loadPopData(x), temp.file, "UniformOutput", false));
popRes = addFieldToStruct(popRes, repmat(cellstr(protStr), length(popRes), 1), "protStr");
% select data
[matchIdx, firstTrial, lastTrial] = NoveltySU.utils.selectData.select139;
popRes = popRes(matchIdx);

%% 
figure
binEdges = 200:20:600;
% SFig1a
RTs = changeCellRowNum(cellfun(@(x) changeCellRowNum(cellfun(@(y) {y(2:end).pushLatency}', {x.correct}', "UniformOutput", false)), {popRes.spkDev}', "UniformOutput", false));
RTCell = cellfun(@(x) cellfun(@cell2mat, changeCellRowNum(x), "UniformOutput", false), RTs, "UniformOutput", false);
for diff = 1 : length(RTs)
subplot(4, 1, diff)
histogram(RTCell{diff}{1}, "BinEdges", binEdges, "DisplayName", ['stdNum=1, mean=', num2str(mean(RTCell{diff}{1}))]); hold on;
histogram(RTCell{diff}{2}, "BinEdges", binEdges, "DisplayName", ['stdNum=3, mean=', num2str(mean(RTCell{diff}{2}))]); hold on;
histogram(RTCell{diff}{3}, "BinEdges", binEdges, "DisplayName", ['stdNum=9, mean=', num2str(mean(RTCell{diff}{3}))]); hold on;
xticks(binEdges);
ylabel("Counts");
xlabel("Reaction time (ms)");
title(['diffLevel = ', num2str(diff)]);
legend("FontSize", 10)
end
RTMean = cellfun(@(x) cellfun(@mean, x, "UniformOutput", false), RTCell, "UniformOutput", false);
RTStruct = cell2struct([cellstr(["1"; "3"; "9"]), RTCell{:}], ["stdNum","diffLevel1", "diffLevel2", "diffLevel3", "diffLevel4"], 2);
RTMeanStruct = cell2struct([cellstr(["1"; "3"; "9"]), RTMean{:}], ["stdNum","diffLevel1", "diffLevel2", "diffLevel3", "diffLevel4"], 2);

[p,tbl,stats] = anova1(vertcat(RTStruct.diffLevel4), [repmat("1", length(RTStruct(1).diffLevel4),1 ); repmat("3", length(RTStruct(2).diffLevel4), 1); repmat("9", length(RTStruct(3).diffLevel4), 1)], "off");
% [comparison,means,h,gnames] = multcompare(stats);