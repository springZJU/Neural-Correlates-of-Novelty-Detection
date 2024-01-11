function neuThrRes = batchNeuThrCal(spkDev, wins, yThr)

opt.fitMethod = 'gaussint';
opt.lanmuda = [spkDev.all.devType]' / spkDev.all(1).devType;
opt.yThr = yThr;
neuThrRes = NoveltySU.utils.threshold.calNeuThr(spkDev, wins, opt);

end