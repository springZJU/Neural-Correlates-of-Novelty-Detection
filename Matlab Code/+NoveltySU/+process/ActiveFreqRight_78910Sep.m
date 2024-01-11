function ActiveFreqRight_78910Sep(MATPATH, FIGPATH, params)
%% Parameter setting
% try
params.processFcn = @NoveltySU.preprocess.ActiveProcess_7_10Freq;
parseStruct(params);
fd = 1000;
temp = string(strsplit(MATPATH, "\"));
dateStr = temp(end - 1);
protStr = temp(end - 2);
DATAPATH = MATPATH;
FIGPATH = strcat(FIGPATH, "\");
SAVEPATH = getRootDirPath(strrep(DATAPATH, "OriginData", "SeperatedData"), 1);
if exist(fullfile(SAVEPATH, "spkData.mat"), "file")
    load(fullfile(SAVEPATH, "spkData.mat"));
    if all(cell2mat(cellfun(@(x) size(x, 2), {collectRes.DP}', "UniformOutput", false)) == 2)
        return
    end
end


%% load data and click train params
[trialAll, spikeDataset, lfpDataset] = spikeLfpProcess(DATAPATH, params);
if isequal(lfpDataset.fs, fd)
    lfpDataset = ECOGResample(lfpDataset, fd);
end


%% split spike data
trialsSpike = selectSpike(spikeDataset, trialAll, params, "trial onset");
[~, ~, count_Early] =  cellfun(@(x, y) findWithinInterval(x, [y+Win.early(1), y+Win.early(2)] - y(1), 1), {trialsSpike.CH1}', {trialAll.soundOnsetSeq}', "UniformOutput", false);
[~, ~, count_Late] =  cellfun(@(x, y) findWithinInterval(x, [y+Win.late(1), y+Win.late(2)] - y(1), 1),  {trialsSpike.CH1}', {trialAll.soundOnsetSeq}', "UniformOutput", false);
fr_Early = cellfun(@(x) x * 1000 / diff(Win.early), count_Early, "UniformOutput", false);
fr_Late = cellfun(@(x) x * 1000 / diff(Win.late), count_Late, "UniformOutput", false);
trialAll = addFieldToStruct(trialAll, [fr_Early, fr_Late], ["fr_Early"; "fr_Late"]);

%% classify by devTypes, output:spkDev
if min(unique([trialAll.devFreq])') == unique(trialAll(1).freqSeq(1))
    devType = sortrows(unique([trialAll.devFreq])', 1, "ascend");
elseif max(unique([trialAll.devFreq])') == unique(trialAll(1).freqSeq(1))
    devType = sortrows(unique([trialAll.devFreq])', 1, "descend");
end

stdSel = [7, 8, 9, 10];
for sIndex = 1 : length(stdSel)
    spkDev(sIndex).stdNum = stdSel(sIndex);
    trialByStd(sIndex).trialAll = trialAll([trialAll.stdNum]' == stdSel(sIndex));
    trialByStd(sIndex).trialSel = find([trialAll.stdNum]' == stdSel(sIndex));
    for dIndex = 1:length(devType)
        run("NoveltySU.process.spkDevCompute_139.m");
    end

    %% compute behavThreshold
    opt.fitMethod = 'gaussint';
    opt.fitType = 'pFit';
    opt.lanmuda = [spkDev(sIndex).all.devType]' / spkDev(sIndex).all(1).devType;
    behavThrRes{sIndex, 1} = NoveltySU.utils.threshold.calBehavThr(spkDev(sIndex), opt);

    %% compute neuThreshold
    wins = [0, 100; 250, 350];
    opt.fitMethod = 'gaussint';
    opt.fitType = 'pFit';
    opt.lanmuda = [spkDev(sIndex).all.devType]' / spkDev(sIndex).all(1).devType;
    neuThrRes{sIndex, 1} = NoveltySU.utils.threshold.calNeuThr(spkDev(sIndex), wins, opt);
    
    %% DPRes
    wins = [0:50:900; 100:50:1000]';
    iteration = 1000;
    DPRes{sIndex, 1} = NoveltySU.utils.DP.calDP(spkDev(sIndex), wins, iteration);

    %% compute response latency
    [neuLag{sIndex, 1}, pushLag{sIndex, 1}] = NoveltySU.utils.timeLag.calTimeLag(spkDev(sIndex), [200, 600], 0.5);


    %% result collection
    collectRes(sIndex).stdNum = stdSel(sIndex);
    collectRes(sIndex).cellName = char(regexp(char(DATAPATH), 'cell\d*', 'match'));
    collectRes(sIndex).freq = [spkDev(sIndex).all.devType]';
    collectRes(sIndex).behavRes = behavThrRes{sIndex, 1}.behavRes;
    collectRes(sIndex).behavThr = behavThrRes{sIndex, 1}.Threshold;
    collectRes(sIndex).neuThr_Early = neuThrRes{sIndex, 1}(1).Threshold;
    collectRes(sIndex).neuThr_Late = neuThrRes{sIndex, 1}(2).Threshold;
    collectRes(sIndex).DP = [vertcat(DPRes{sIndex, 1}.timePoint), vertcat(DPRes{sIndex, 1}.value)];
    collectRes(sIndex).neuLag = neuLag{sIndex, 1};
    collectRes(sIndex).pushLag = pushLag{sIndex, 1};
end
collectRaw = cell2struct([num2cell(stdSel'), behavThrRes], ["stdNum", "behavThrRes"], 2);


%% save result

SAVEPATH = getRootDirPath(strrep(DATAPATH, "OriginData", "SeperatedData"), 1);
mkdir(SAVEPATH);
save(fullfile(SAVEPATH, "spkData.mat"), "collectRes", "trialAll", "DPRes", "spkDev", "collectRaw", "trialByStd", "-v7.3");
% catch e
%     disp(e.message);
%     xlsxName = fullfile(getRootDirPath(DATAPATH, 2), "errorCell.xlsx");
%     errorCell = table2struct(readtable(xlsxName));
%     idx = find(contains({errorCell.cellName}, erase(FIGPATH, getRootDirPath(FIGPATH, 2))));
%     if isempty(idx)
%         errorCell(end+1).cellName = erase(FIGPATH, getRootDirPath(FIGPATH, 2));
%         errorCell(end+1).message = e.message;
%     else
%         errorCell(idx).cellName = erase(FIGPATH, getRootDirPath(FIGPATH, 2));
%         errorCell(idx).message = e.message;
%     end
%     writetable(struct2table(errorCell), xlsxName);
% end
end




