function  matchIdx = decideRegion(popRes, region)
protStr = cellstr(["ActiveFreqRight", "ActiveFreqLeft", "", "", "ActiveNoneFreqRight"]);

switch region
    case "A1"
        %% Monica
        load(strcat(getRootDirPath(mfilename("fullpath"), 6), "Data\ProcessData\Figure11\zp1221.mat"));
        temp=cell2mat(thresholdchuang(:,[2:3 8]));
        A1Idx=find(temp(:,1)>16&temp(:,1)<=27&temp(:,2)>22&temp(:,2)<=28);
        gymStr = cellfun(@(x, y) [x, '_', protStr{y}], thresholdchuang(A1Idx, 1), thresholdchuang(A1Idx, 8), "UniformOutput", false);
        popStr = cellfun(@(x, y) [char(regexp(x, '(cell|neu139|neuInt)\d*', 'match')), '_', y], {popRes.Date}', {popRes.protStr}', "UniformOutput", false);
        matchIdx{1, 1} = find(contains({popRes.Date}', "Monica") & contains(popStr, gymStr));

        %% CM
        load(strcat(getRootDirPath(mfilename("fullpath"), 6), "Data\ProcessData\Figure11\zpush1221.mat"));
        sprStr = cellfun(@(x, y) [char(regexp(x, '(cell|neu139|neuInt)\d*', 'match')), '_', protStr{y}], thresholdchuang(1:61, 1), thresholdchuang(1:61, 8), "UniformOutput", false);
        popStr = cellfun(@(x, y) [char(regexp(x, '(cell|neu139|neuInt)\d*', 'match')), '_', y], {popRes.Date}', {popRes.protStr}', "UniformOutput", false);
        if isstruct(popRes)
        matchIdx{2, 1} = find(contains({popRes.Date}', "CM") & contains(popStr, sprStr));
        elseif iscell(popRes)
        matchIdx{2, 1} = find(contains(popRes, "CM") & contains(popStr, sprStr));
        end
end
end