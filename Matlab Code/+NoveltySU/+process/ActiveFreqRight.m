function ActiveFreqRight(MATPATH, FIGPATH, params)
%% Parameter setting
% try
    params.processFcn = @NoveltySU.preprocess.ActiveProcess_7_10Freq;
    parseStruct(params);
    fd = 1000;
    temp = string(strsplit(MATPATH, "\"));
    % dateStr = temp(end - 1);
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

    % 78910
    for dIndex = 1:length(devType)
        run("NoveltySU.process.spkDevCompute.m");
    end

%     % 8910
%     for dIndex = 1:length(devType)
%         run("NoveltySU.process.spkDevCompute_8910.m");
%     end

    %% classify by stdTypes, output:spkStd
    stdType = unique([trialAll.stdNum]');
    for sIndex = 1:length(stdType)
        run("NoveltySU.process.spkStdCompute.m");
    end

    %% compute behavThreshold
    opt.fitMethod = 'gaussint';
    opt.fitType = 'pFit';
    % 78910
    opt.lanmuda = [spkDev.all.devType]' / spkDev.all(1).devType;
    behavThrRes = NoveltySU.utils.threshold.calBehavThr(spkDev, opt);
    
%     % 8910
%     opt.lanmuda = [spkDev_8910.all.devType]' / spkDev_8910.all(1).devType;
%     behavThrRes_8910 = NoveltySU.utils.threshold.calBehavThr(spkDev_8910, opt);

    %% compute neuThreshold
    wins = [0, 100; 250, 350];
    opt.fitMethod = 'gaussint';
    opt.fitType = 'pFit';
    % 78910
    opt.lanmuda = [spkDev.all.devType]' / spkDev.all(1).devType;
    neuThrRes = NoveltySU.utils.threshold.calNeuThr(spkDev, wins, opt);

%     % 8910
%     opt.lanmuda = [spkDev_8910.all.devType]' / spkDev_8910.all(1).devType;
%     neuThrRes_8910 = NoveltySU.utils.threshold.calNeuThr(spkDev_8910, wins, opt);

    %% compute response latency
    [neuLag, pushLag, neuAccumulate] = NoveltySU.utils.timeLag.calTimeLag_ByTrial(spkDev, [200, 600], 0.5, "correct");

    %% compute DRP
    wins = [0:50:900; 100:50:1000]';
    iteration = 1000;
    % 78910
    DPRes = NoveltySU.utils.DP.calDP(spkDev, wins, iteration);

%     % 8910
%     DPRes_8910 = NoveltySU.utils.DP.calDP(spkDev_8910, wins, iteration);

    %% push PSTH
    trialsSpike = selectSpike(spikeDataset, trialAll, params, "push onset");
    for dIndex = 1:length(devType)
        run("NoveltySU.process.spkPushCompute.m");
    end

    %% result collection
    collectRes.cellName = char(regexp(char(DATAPATH), 'cell\d*', 'match'));
    collectRes.freq = [spkDev.all.devType]';
    collectRes.neuLag = neuLag;
    collectRes.pushLag = pushLag;
    collectRes.neuAccumulate = neuAccumulate;
    % 78910
    collectRes.behavRes = behavThrRes.behavRes;
    collectRes.behavThr = behavThrRes.Threshold;
    collectRes.neuThr_Early = neuThrRes(1).Threshold;
    collectRes.neuThr_Late = neuThrRes(2).Threshold;
    collectRes.DP = [vertcat(DPRes.timePoint), vertcat(DPRes.value)];
%     % 8910
%     collectRes.behavRes_8910 = behavThrRes_8910.behavRes;
%     collectRes.behavThr_8910 = behavThrRes_8910.Threshold;
%     collectRes.neuThr_Early_8910 = neuThrRes_8910(1).Threshold;
%     collectRes.neuThr_Late_8910 = neuThrRes_8910(2).Threshold;
%     collectRes.DP_8910 = [vertcat(DPRes_8910.timePoint), vertcat(DPRes_8910.value)];
   
    %% save result
    SAVEPATH = getRootDirPath(strrep(DATAPATH, "OriginData", "ProcessData"), 1);
    mkdir(SAVEPATH);
    save(fullfile(SAVEPATH, "spkData.mat"), "collectRes", "trialAll", "spkDev", "spkStd", "spkPush", "DPRes", "behavThrRes", "neuThrRes", "-v7.3");
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




