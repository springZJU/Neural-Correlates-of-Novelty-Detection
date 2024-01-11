function [fr, push] = FR78910(trialAll)
fr_Early = cell2mat(cellfun(@(x) x(end), {trialAll.fr_Early}', "UniformOutput", false));
fr_Late = cell2mat(cellfun(@(x) x(end), {trialAll.fr_Late}', "UniformOutput", false));
stdNum = unique([trialAll.stdNum]');
devType = unique([trialAll.devFreq]');
for sIndex = 1 : length(stdNum)
    for dIndex = 1 : length(devType)
        push.allTrial(sIndex, dIndex) = sum([trialAll.devFreq]' == devType(dIndex) & [trialAll.stdNum]' == stdNum(sIndex));
        if dIndex == 1
            Idx = [trialAll.devFreq]' == devType(dIndex) & [trialAll.stdNum]' == stdNum(sIndex) & ~[trialAll.correct]';
        else
            Idx = [trialAll.devFreq]' == devType(dIndex) & [trialAll.stdNum]' == stdNum(sIndex) & [trialAll.correct]';
        end
        push.pushTrial(sIndex, dIndex) = sum(Idx);
        push.pushRatio(sIndex, dIndex) = max([0, push.pushTrial(sIndex, dIndex) / push.allTrial(sIndex, dIndex)]);
        frIdx = [trialAll.devFreq]' == devType(dIndex) & [trialAll.stdNum]' == stdNum(sIndex);
        fr.Raw_Early{sIndex, dIndex} = fr_Early(frIdx);
        fr.Mean_Early(sIndex, dIndex) = mean(fr_Early(frIdx));
        fr.SE_Early(sIndex, dIndex) = SE(fr_Early(frIdx));
        fr.Raw_Late{sIndex, dIndex} = fr_Late(frIdx);
        fr.Mean_Late(sIndex, dIndex) = mean(fr_Late(frIdx));
        fr.SE_Late(sIndex, dIndex) = SE(fr_Early(frIdx));
    end
end
end