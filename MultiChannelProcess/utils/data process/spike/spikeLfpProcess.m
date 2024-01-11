function [trialAll, spikeDataset, lfpDataset, soundFold] = spikeLfpProcess(DATAPATH, params)
% Description: load data from *.mat or TDT block
% Input:
%     DATAPATH: full path of *.mat or TDT block path
%     params:
%         - DATAPATH: the path of TDT data or exported mat file
%         - params: struct that contains behavior processing function handle

% Output:
%     trialAll: n*1 struct of trial information
%     spikeDataset: m*1 struct that contains spiketime, realCh(for lfp) and ch(k*1000+realCh)
%     lfpDataset: TDT dataset of [streams.(posStr(posIndex))]

%% Parameter settings
parseStruct(params);

%% Validation
if isempty(processFcn)
    error("Process function is not specified");
end

%% Loading data
try
    disp("Try loading data from MAT");

    % lfp

    load(fullfile(erase(DATAPATH, "data.mat"), "lfpData.mat"));

    try
        lfpDataset = data.lfp;
    catch
        lfpDataset = data.streams.Llfp;
    end
    epocs = data.epocs;
    trialAll = processFcn(epocs);
    %     chs = size(lfpDataset.data, 1);

    % spike

    load(fullfile(erase(DATAPATH, "data.mat"), "spkData.mat"));

    if ~isempty(data.sortdata)
        if any(data.sortdata(:, 2) == 0)
            data.sortdata(:, 2) = data.sortdata(:, 2) + 1;
        end
        if size(data.sortdata, 2) == 1
            data.sortdata(:, 2) = 1;
        end
        spikeDataset = spikeByCh(sortrows(data.sortdata, 2));
    else
        temp = data.spikeRaw.snips.eNeu;
        spikeDataset = spikeByCh(sortrows([double(temp.ts), double(temp.chan)], 2));
    end

catch e
    disp(e.message);
    disp("Try loading data from TDT BLOCK...");
    temp = TDTbin2mat(DATAPATH, 'TYPE', {'epocs'});
    epocs = temp.epocs;
    trialAll = processFcn(epocs);

    temp = TDTbin2mat(DATAPATH, 'TYPE', {'streams', 'snips'});
    streams = temp.streams;
    spikeDataset = spikeByCh(sortrows([temp.snips.eNeu.ts double(temp.snips.eNeu.chan)], 2));
    lfpDataset = streams.Llfp;
    soundFold = [];
end

return;
end