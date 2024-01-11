function res = calBehavThr(spkDev, opt)
Thrcal = @NoveltySU.utils.threshold.Thrcal;
Thrcal_pFit = @NoveltySU.utils.threshold.Thrcal_pFit;
opt.fitType = getOr(opt, "fitType", "selfWritten");
pushRatio = cell2mat(cellfun(@(x, y) x/y, {spkDev.correct.trialNum}', {spkDev.all.trialNum}', "UniformOutput", false));
pushRatio(1) = 1-pushRatio(1);
behavRes = pushRatio;

if strcmpi(opt.fitType, "selfWritten")
    opt.lanmuda = [2-flip(opt.lanmuda(2:end)); opt.lanmuda];
    pushRatio = [-1*flip(pushRatio(2:end))+pushRatio(1, :); pushRatio];
    res = Thrcal(pushRatio,opt);
elseif strcmpi(opt.fitType, "pFit")
    res = Thrcal_pFit(pushRatio ,opt, "sigmoidName", opt.fitMethod);
end
res.behavRes = behavRes;

end