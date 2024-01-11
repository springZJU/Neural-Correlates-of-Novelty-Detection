ROOTPATH = strcat(getRootDirPath(mfilename("fullpath"), 5), "Data\OriginData\BehaviorOnly");
MATPATH = dirItem(ROOTPATH, "behavData.mat", "folderOrFile", "file");
cellfun(@(x) sortBehavior(x), MATPATH, "UniformOutput", false);

function sortBehavior(MATPATH)
warning("off");
choiceWin = [150, 600];
load(MATPATH);
if isfield(data.epocs, "Durr")
    return
end
try
    Fcn = @NoveltySU.preprocess.ActiveProcess_7_10Freq;
    trialAll = Fcn(data.epocs, choiceWin);
    devType = unique([trialAll.devFreq]');
    stdFreq = trialAll(1).freqSeq(1);
    if length(devType) == 5 && stdFreq == min(devType) && isequal(unique([trialAll.stdNum]'), [7;8;9;10])
        trialTimes = cell2mat(cellfun(@(x) sum([trialAll.devFreq]' == x), num2cell(devType), "UniformOutput", false));
        correctTimes = cell2mat(cellfun(@(x) sum([trialAll.devFreq]' == x & [trialAll.correct]'), num2cell(devType), "UniformOutput", false));
        pushTimes = [trialTimes(1)-correctTimes(1); correctTimes(2:end)];
        pushRatio = pushTimes./trialTimes;

        if all(pushRatio(end-1 : end) < 0.75)
            consectN = 4;
            trialAll_LargeDiff = trialAll([trialAll.devFreq]' == devType(end));
            temp = find([trialAll_LargeDiff.correct]' == 0);
            [~, ~, allIdx]= mConsecutive(temp, consectN);
            badIdx = temp(allIdx);
            headIdx = badIdx(find(diff(allIdx, 2) > 0, 1, "first")+1) + consectN;
            headTrialNum = trialAll_LargeDiff(headIdx).trialNum;
            tailIdx = badIdx(find(diff(allIdx, 2) > 0, 1, "first")+2) - 1;
            tailTrialNum = trialAll_LargeDiff(tailIdx).trialNum;

            trialAll_Temp = trialAll(headTrialNum:tailTrialNum);
            trialTimes = cell2mat(cellfun(@(x) sum([trialAll_Temp.devFreq]' == x), num2cell(devType), "UniformOutput", false));
            correctTimes = cell2mat(cellfun(@(x) sum([trialAll_Temp.devFreq]' == x & [trialAll_Temp.correct]'), num2cell(devType), "UniformOutput", false));
            pushTimes = [trialTimes(1)-correctTimes(1); correctTimes(2:end)];
            pushRatio = pushTimes./trialTimes;
        end




        if  all(pushRatio(end-1 : end) < 0.75) || any(pushRatio(3:4) < 0.3) || pushRatio(1)> 0.15 || any(isnan(pushRatio)) || pushRatio(end) < 0.6
            return
        end
        if contains(MATPATH, "CM")
            SAVEPATH = strrep(strrep(MATPATH, "\CM\ty", "\78910\CM_ty"), "\Block", "_Block");
        elseif contains(MATPATH, "Monica")
            SAVEPATH = strrep(strrep(MATPATH, "\Monica\20", "\78910\Monica_20"), "\Block", "_Block");
        end
        mkdir(erase(SAVEPATH, "behavData.mat"));
        save(SAVEPATH, "trialAll", "devType", "trialTimes", "pushRatio", "pushTimes", "-v7.3");

    end
catch
    return
end
return

end
