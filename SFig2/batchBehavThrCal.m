function behavThrRes = batchBehavThrCal(spkDev, yThr)

opt.fitMethod = 'gaussint';
opt.lanmuda = [spkDev.all.devType]' / spkDev.all(1).devType;
opt.yThr = yThr;
behavThrRes = NoveltySU.utils.threshold.calBehavThr(spkDev, opt);

end