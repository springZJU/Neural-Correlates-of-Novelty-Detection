function res = calNeuThr(spkDev, wins, opt)
AUCcal = @NoveltySU.utils.threshold.AUCcal;
Thrcal = @NoveltySU.utils.threshold.Thrcal;
Thrval_pFit = @NoveltySU.utils.threshold.Thrcal_pFit;
diffNum = num2cell(1 : length(spkDev.all))';
opt.fitType = getOr(opt, "fitType", "selfWritten");
for wIndex = 1 : size(wins, 1)
    [~, ~, count] = cellfun(@(x, y) calFR(x, wins(wIndex, :), y), {spkDev.all.spikePlot}', {spkDev.all.trials}', "UniformOutput", false);
    temp = cellfun(@(x, y) [x(:, 1), ones(size(x, 1), 1) * double(y > 1)] , count, diffNum,  "UniformOutput", false);
    zscoreData = cellfun(@(x) [zscore([temp{1}(:, 1); x(:, 1)]), [temp{1}(:, 2); x(:, 2)]], temp, "uni", false);
    AUC = cell2mat(cellfun(@(x, y) AUCcal(x, y), zscoreData, diffNum, "UniformOutput", false));
    if strcmpi(opt.fitType, "selfWritten")
        resThr{wIndex, 1} = Thrcal(AUC,opt);
    elseif strcmpi(opt.fitType, "pFit")
        resThr{wIndex, 1} = Thrval_pFit(AUC, opt, "sigmoidName", opt.fitMethod);
    end
    resThr{wIndex, 1}.AUC = AUC;
    resThr{wIndex, 1}.win = wins(wIndex, :);
    resThr{wIndex, 1}.zscoreData = zscoreData;
end
res = cell2mat(resThr);

end