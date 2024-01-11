function ActiveFreq139(MATPATH, FIGPATH, params)
%% Parameter setting
try
    params.processFcn = @NoveltySU.preprocess.ActiveProcess_7_10Freq;
    parseStruct(params);
    fd = 1000;
    temp = string(strsplit(MATPATH, "\"));
    dateStr = temp(end - 1);
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

    stdSel = [1, 3, 9];
    for sIndex = 1 : length(stdSel)
        spkDev(sIndex).stdNum = stdSel(sIndex);
        trialByStd(sIndex).trialAll = trialAll([trialAll.stdNum]' == stdSel(sIndex));
        trialByStd(sIndex).trialSel = find([trialAll.stdNum]' == stdSel(sIndex));
        for dIndex = 1:length(devType)
            run("NoveltySU.process.spkDevCompute_139.m");
        end

        %% compute behavThreshold
        opt.fitMethod = 'gaussint';
        opt.lanmuda = [spkDev(sIndex).all.devType]' / spkDev(sIndex).all(1).devType;
        behavThrRes{sIndex, 1} = NoveltySU.utils.threshold.calBehavThr(spkDev(sIndex), opt);


        %% result collection
        collectRes(sIndex).stdNum = stdSel(sIndex);
        collectRes(sIndex).cellName = char(regexp(char(DATAPATH), 'cell\d*', 'match'));
        collectRes(sIndex).freq = [spkDev(sIndex).all.devType]';
        collectRes(sIndex).behavRes = behavThrRes{sIndex, 1}.behavRes;

    end
    collectRaw = cell2struct([num2cell(stdSel'), behavThrRes], ["stdNum", "behavThrRes"], 2);
    %% classify by stdTypes, output:spkStd
    stdType = unique([trialAll.stdNum]');
    for sIndex = 1:length(stdType)
        run("NoveltySU.process.spkStdCompute.m");
    end


    %% save result

    SAVEPATH = getRootDirPath(strrep(DATAPATH, "OriginData", "ProcessData"), 1);
    mkdir(SAVEPATH);
    save(fullfile(SAVEPATH, "spkData.mat"), "collectRes", "trialAll", "spkDev", "spkStd", "collectRaw", "trialByStd", "-v7.3");
catch e
    disp(e.message);
    xlsxName = fullfile(getRootDirPath(DATAPATH, 2), "errorCell.xlsx");
    errorCell = table2struct(readtable(xlsxName));
    idx = find(contains({errorCell.cellName}, erase(FIGPATH, getRootDirPath(FIGPATH, 2))));
    if isempty(idx)
        errorCell(end+1).cellName = erase(FIGPATH, getRootDirPath(FIGPATH, 2));
        errorCell(end+1).message = e.message;
    else
        errorCell(idx).cellName = erase(FIGPATH, getRootDirPath(FIGPATH, 2));
        errorCell(idx).message = e.message;
    end
    writetable(struct2table(errorCell), xlsxName);
end
end




