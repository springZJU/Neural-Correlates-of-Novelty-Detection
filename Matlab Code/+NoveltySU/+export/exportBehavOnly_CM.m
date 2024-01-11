ROOTPATH = "\\10.49.14.99\Monkey2\ty";
TANKPATH = dir(ROOTPATH);
TANKPATH(matches({TANKPATH.name}', [".", ".."])) = [];
TANKPATH = cellfun(@(x, y) [x, '\', y], {TANKPATH.folder}', {TANKPATH.name}', "UniformOutput", false);
SAVEPATH = "H:\Neural correlates of novelty detection in the macaque primary auditory cortex\Data\OriginData\BehaviorOnly\CM";
cellfun(@(x) SAVE_EPOCS(x, SAVEPATH), TANKPATH, "UniformOutput", false);


function SAVE_EPOCS(TANKPATH, SAVEPATH)
BLOCKPATH = dir(TANKPATH);
BLOCKPATH(matches({BLOCKPATH.name}', [".", ".."]) | ~contains({BLOCKPATH.name}', "Block")) = [];
DATE = string(regexpi(TANKPATH, "ty20\d*", "match"));
BLOCKPATH = cellfun(@(x, y) [x, '\', y], {BLOCKPATH.folder}', {BLOCKPATH.name}', "UniformOutput", false);
try
    for bIndex = 1 : length(BLOCKPATH)
        BLOCKNAME = string(regexpi(BLOCKPATH{bIndex}, "Block.*", "match"));
        data = TDTbin2mat(char(BLOCKPATH{bIndex}), 'TYPE', 2);
        if ~isfield(data.epocs, "freq") || ~isfield(data.epocs, "push")
            continue
        end
        if data.epocs.freq.data(end) < 600
            continue
        end
        MATPATH = fullfile(SAVEPATH, DATE, BLOCKNAME);
        mkdir(MATPATH);
        save(fullfile(MATPATH, "behavData.mat"), "data", "-v7.3");
    end
catch
end
end