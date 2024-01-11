function ActiveIntLow(MATPATH, FIGPATH, params)
%% Parameter setting

params.processFcn = @NoveltySU.preprocess.ActiveProcess_7_10Intensity;
parseStruct(params);
fd = 1000;
temp = string(strsplit(MATPATH, "\"));
protStr = temp(end - 2);
DATAPATH = MATPATH;
FIGPATH = strcat(FIGPATH, "\");
SAVEPATH = getRootDirPath(strrep(DATAPATH, "OriginData", "ProcessData"), 1);
if exist(fullfile(SAVEPATH, "spkData.mat"), "file")
    return
end
temp = dir(FIGPATH);
Exist_Single = any(contains(string({temp.name}), "CH"));
if Exist_Single
    return
end
% try
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
    if min(unique([trialAll.devInt])') == unique(trialAll(1).intSeq(1))
        devType = sortrows(unique([trialAll.devInt])', 1, "ascend");
    elseif max(unique([trialAll.devInt])') == unique(trialAll(1).intSeq(1))
        devType = sortrows(unique([trialAll.devInt])', 1, "descend");
    end

    % 78910
    for dIndex = 1:length(devType)
        run("NoveltySU.process.spkDevCompute.m");
    end


    %% classify by stdTypes, output:spkStd
    stdType = unique([trialAll.stdNum]');
    for sIndex = 1:length(stdType)
        run("NoveltySU.process.spkStdCompute.m");
    end

    %% compute behavThreshold
    opt.fitMethod = 'gaussint';
    opt.fitType = 'pFit';
    % 78910
    opt.lanmuda = 1:5;
    behavThrRes = NoveltySU.utils.threshold.calBehavThr(spkDev, opt);
    
    %% compute neuThreshold
    wins = [0, 100; 250, 350];
    opt.fitMethod = 'gaussint';
    opt.fitType = 'pFit';
    % 78910
    opt.lanmuda = 1:5;
    neuThrRes = NoveltySU.utils.threshold.calNeuThr(spkDev, wins, opt);
    %% compute response latency
    [neuLag, pushLag] = NoveltySU.utils.timeLag.calTimeLag(spkDev, [200, 600], 0.5);

    %% compute DRP
    wins = [0:50:900; 100:50:1000]';
    iteration = 1000;
    % 78910
    DPRes = NoveltySU.utils.DP.calDP(spkDev, wins, iteration);

    %% result collection
    collectRes.cellName = char(regexp(char(DATAPATH), 'cell\d*', 'match'));
    collectRes.int = [spkDev.all.devType]';
    collectRes.neuLag = neuLag;
    collectRes.pushLag = pushLag;
    % 78910
    collectRes.behavRes = behavThrRes.behavRes;
    collectRes.behavThr = behavThrRes.Threshold;
    collectRes.neuThr_Early = neuThrRes(1).Threshold;
    collectRes.neuThr_Late = neuThrRes(2).Threshold;
    collectRes.DP = [vertcat(DPRes.timePoint), vertcat(DPRes.value)];

    %% save result
    SAVEPATH = getRootDirPath(strrep(DATAPATH, "OriginData", "ProcessData"), 1);
    mkdir(SAVEPATH);
    save(fullfile(SAVEPATH, "spkData.mat"), "collectRes", "trialAll", "spkDev", "spkStd", "DPRes", "behavThrRes", "neuThrRes", "-v7.3");
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




