function  matchIdx = decideRegion_139(popRes)
loadRes(1) = load(strcat(getRootDirPath(mfilename("fullpath"), 6), "Data\ProcessData\Figure10\z139allchuangdevright.mat"));
loadRes(2) = load(strcat(getRootDirPath(mfilename("fullpath"), 6), "Data\ProcessData\Figure10\zdevall.mat"));
devcellall = [loadRes(1).devcellall; loadRes(2).devcellall];
deleteIdx = [1 4 9 10 13 14 16 26 30 31 32 33 34 37 39 44 49 58 38];
devcellall(deleteIdx, :) = [];
gymCell = devcellall(1:24, 1);
sprCell = devcellall(25:end, 1);

popStr = cellfun(@(x) char(regexp(x, '(cell|neu139|neuInt)\d*', 'match')), {popRes.Date}', "UniformOutput", false);

%% Monica
gymStr = gymCell(:, 1);
matchIdx{1, 1} = find(contains({popRes.Date}', "Monica") & matches(popStr, gymStr));

%% CM
sprStr = sprCell(:, 1);
matchIdx{2, 1} = find(contains({popRes.Date}', "CM") & matches(popStr, sprStr));
end