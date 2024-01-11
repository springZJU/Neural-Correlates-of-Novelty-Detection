function resAUC = AUCcal(data,devDiff)
repByVal = @NoveltySU.utils.threshold.repByIdx;
labels = data(:,2);
scores = data(:,1);
if devDiff ==1
    try
        randIdx = cellfun(@(x) randperm(length(x)), repmat({labels}, 1000, 1), "UniformOutput", false);
        labels = cellfun(@(x) repByVal(labels, 1,x(1:floor(length(x)/2))), randIdx, "UniformOutput", false);
        [~,~,~,resAUC]=cellfun(@(x) perfcurve(x, scores, 1), labels, "uni", false);
        resAUC = mean(cell2mat(resAUC));
    catch
        resAUC = 0.5;
    end
else
    try
        [~,~,~,resAUC] = perfcurve(labels, scores, 1) ;

    catch
        resAUC = 0.5;
    end
end
end