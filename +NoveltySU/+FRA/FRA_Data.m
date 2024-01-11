function result = FRA_Data(DATAPATH)

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
    result.windowParams = windowParams;
    ch = unique(sortData.channelIdx)';
    for cIndex = 1:length(ch)
        result.data = NoveltySU.FRA.sFRAProcess(data, windowParams, sortData, ch(cIndex));
    end

return;
end
