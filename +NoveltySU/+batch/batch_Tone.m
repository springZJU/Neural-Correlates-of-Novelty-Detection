temp = dirItem(strcat(getRootDirPath(mfilename("fullpath"), 5), "Data\OriginData\ToneCF"), "spkData.mat");
TONEPATH = temp.file;
DATE = string(regexp(TONEPATH, "(CM|Monica)\w*(cell|neu139)\d*", 'match'));
FIGPATH = cellfun(@(x) strcat(getRootDirPath(mfilename("fullpath"), 4), "Figures\protocolFig\ToneCF\", x), DATE, "uni", false);
cellfun(@(x, y) NoveltySU.FRA.sFRA_RNP(x, y), TONEPATH, FIGPATH, "UniformOutput", false);
