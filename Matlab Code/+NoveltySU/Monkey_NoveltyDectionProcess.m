clc; close all
clearvars -except protSel
%% TODO: configuration
ROOTPATH = getRootDirPath(mfilename("fullpath"), 4);
dateSel = ""; % blank for all
protSel = "ActiveFreq139"; % blank for all
params.Window = [-1000, 6000];
params.choiceWin = [150, 600];
params.Win.early = [0, 100]; params.Win.late = [250, 350];

%% load protocols
rootPathMat = fullfile(ROOTPATH, "Data\OriginData\");
rootPathFig = fullfile(ROOTPATH, "Figures\protocolFig\");
temp = dir(rootPathMat);
temp(ismember(string({temp.name}'), [".", "..", "rawData"])) = [];
protocols = string({temp.name}');

%% BATCH
for rIndex = 1 : length(protocols)
    protPathMat = strcat(rootPathMat,  protocols(rIndex), "\");
    protocolStr = protocols(rIndex);
    temp = dir(protPathMat);
    temp(ismember(string({temp.name}'), [".", ".."])) = [];

    MATPATH = cellfun(@(x) string([char(protPathMat), x, '\data.mat']), {temp.name}', "UniformOutput", false);
    MATPATH = MATPATH( contains(string(MATPATH), dateSel) & contains(string(MATPATH), protSel) );
    FIGPATH = cellfun(@(x) strcat(rootPathFig, protocolStr, "\", string(x{end-1})), cellfun(@(y) strsplit(y, "\"), MATPATH, "UniformOutput", false), "UniformOutput", false);
    for mIndex = 1 : length(MATPATH)
        try % the function name equals the protocol name
            mFcn = eval(['@NoveltySU.process.', char(protocolStr), ';']);
            mFcn(MATPATH{mIndex}, FIGPATH{mIndex}, params);
        catch % temporal binding protocols
            NoveltySU.process.ActiveFreqRight(MATPATH{mIndex}, FIGPATH{mIndex}, params);
        end
    end
end

