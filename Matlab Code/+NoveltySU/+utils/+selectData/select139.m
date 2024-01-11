function  [matchIdx, firstTrial, lastTrial]= select139
tableSel = table2struct(readtable(strcat(getRootDirPath(mfilename("fullpath"), 1), "139Select.xlsx")));
matchIdx = [tableSel.selIdx]';
firstTrial = [tableSel.firstTrial]';
lastTrial = [tableSel.lastTrial]';
end