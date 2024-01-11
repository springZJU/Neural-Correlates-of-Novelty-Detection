function [Fig, ch] = sFRA_RNP(DATAPATH, FIGPATH)

narginchk(1, 2);
%% Load data
try
    load(DATAPATH);
    sortData.spikeTimeAll = data.sortdata(:,1);
    if size(data.sortdata, 2) == 2
        sortData.channelIdx = data.sortdata(:, 2);
    else
        sortData.channelIdx = ones(size(data.sortdata, 1), 1);
    end
catch
    data = TDTbin2mat(DATAPATH, 'TYPE', [1, 2, 3]);
    sortData.spikeTimeAll = data.snips.eNeu.ts;
    sortData.channelIdx = data.snips.eNeu.chan;
end

%% Parameter Settings
windowParams.window = [0 120]; % ms

%% Process
try
    result.windowParams = windowParams;
    chNum = length(unique(sortData.channelIdx)');
    chN = 0;
    ch = unique(sortData.channelIdx)';
    for cIndex = 1:length(ch)
        chN = chN + 1;
        result.data = NoveltySU.FRA.sFRAProcess(data, windowParams, sortData, ch(cIndex));
        Fig = NoveltySU.FRA.plotTuning(result, "on");
        % save figures
        print(Fig, FIGPATH, "-djpeg", "-r200");
        close(Fig);
    end
catch e
        disp(e.message);
    xlsxName = fullfile(getRootDirPath(DATAPATH, 2), "errorCell.xlsx");
    errorCell = table2struct(readtable(xlsxName));
    idx = find(contains({errorCell.cellName}, erase(FIGPATH, getRootDirPath(FIGPATH, 1))));
    if isempty(idx)
        errorCell(end+1).cellName = erase(FIGPATH, getRootDirPath(FIGPATH, 2));
        errorCell(end+1).message = e.message;
    else
        errorCell(idx).cellName = erase(FIGPATH, getRootDirPath(FIGPATH, 2));
        errorCell(idx).message = e.message;
    end
    writetable(struct2table(errorCell), xlsxName);
end
return;
end
