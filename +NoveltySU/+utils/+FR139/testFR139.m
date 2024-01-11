function fr = testFR139(trialAll)
fr_Early = cell2mat(cellfun(@(x) x(end), {trialAll.fr_Early}', "UniformOutput", false));
fr_Late = cell2mat(cellfun(@(x) x(end), {trialAll.fr_Late}', "UniformOutput", false));
stdNum = [1, 3, 9];
devType = unique([trialAll.devFreq]');
for sIndex = 1 : length(stdNum)
    for dIndex = 1 : length(devType)
        Idx = find([trialAll.devFreq]' == devType(dIndex) & [trialAll.stdNum]' == stdNum(sIndex));
        fr.Raw_Early{sIndex, dIndex} = fr_Early(Idx);
        fr.Mean_Early(sIndex, dIndex) = mean(fr_Early(Idx));
        fr.SE_Early(sIndex, dIndex) = SE(fr_Early(Idx));
        fr.Raw_Late{sIndex, dIndex} = fr_Late(Idx);
        fr.Mean_Late(sIndex, dIndex) = mean(fr_Late(Idx));
        fr.SE_Late(sIndex, dIndex) = SE(fr_Early(Idx));
    end
end
end