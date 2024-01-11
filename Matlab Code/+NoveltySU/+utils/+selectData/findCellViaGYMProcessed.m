function matchIdx = findCellViaGYMProcessed(popRes)
protStr = cellstr(["ActiveFreqRight", "ActiveFreqLeft", "", "", "ActiveNoneFreqRight"]);
%% Monica
load(strcat(getRootDirPath(mfilename("fullpath"), 6), "Data\ProcessData\Figure11\zp1221.mat"));
gymStr = cellfun(@(x, y) [x, '_', protStr{y}], thresholdchuang(:, 1), thresholdchuang(:, 8), "UniformOutput", false);
popStr = cellfun(@(x, y) [char(regexp(x, '(cell|neu139|neuInt)\d*', 'match')), '_', y], {popRes.Date}', {popRes.protStr}', "UniformOutput", false);
matchIdx.Monica = find(contains({popRes.Date}', "Monica") & contains(popStr, gymStr));

%% CM
load(strcat(getRootDirPath(mfilename("fullpath"), 6), "Data\ProcessData\Figure11\zpush1221.mat"));
sprStr = cellfun(@(x, y) [char(regexp(x, '(cell|neu139|neuInt)\d*', 'match')), '_', protStr{y}], thresholdchuang(:, 1), thresholdchuang(:, 8), "UniformOutput", false);
popStr = cellfun(@(x, y) [char(regexp(x, '(cell|neu139|neuInt)\d*', 'match')), '_', y], {popRes.Date}', {popRes.protStr}', "UniformOutput", false);
matchIdx.CM = find(contains({popRes.Date}', "CM") & contains(popStr, sprStr));
end
