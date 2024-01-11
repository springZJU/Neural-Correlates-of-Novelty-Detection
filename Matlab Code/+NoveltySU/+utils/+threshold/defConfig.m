
function defOpt = defConfig(Data,Opt)
defOpt.lanmuda = getOr(Opt,'lanmuda', 1:size(Data,1));
defOpt.yThr = getOr(Opt,'yThr', 0.8);
defOpt.xThr = getOr(Opt,'xThr', 2.9);
defOpt.thrMethod = getOr(Opt,'thrMethod', 'Y');
defOpt.fitMethod = getOr(Opt,'fitMethod', 'gaussint');
defOpt.dataType = getOr(Opt,'dataType', 'neural');
defOpt.plotYN = getOr(Opt,'plotYN', false);
end