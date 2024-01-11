function [Res,ThrRes] = Thrcal_pFit(data,opt,varargin)
% opt.lanmuda
% opt.xThr : the maximum of x obtained from fit curve
% opt.yThr
% opt.thrMethod
% opt.plotYN
% varargin: fitMethod:
%           fitRes: if fitted previous, use this function as:
%           Thrcal(data,opt,'fitRes',fitRes);

mIp = inputParser;
mIp.addRequired("data", @(x) ismatrix(x) & ismember(size(x, 2), [1, 2, 3]));
mIp.addRequired("opt", @(x) isstruct(x));
mIp.addParameter("xFit", [], @isnumeric);
mIp.addParameter("yThr", 0.8, @isnumeric);
mIp.addParameter("sigmoidName", 'norm', @(x) any(validatestring(x, {'norm', 'gauss', 'gaussint', 'logistic', 'logn', 'weibull', 'gumbel', 'rgumbel', 'tdist'})));
mIp.addParameter("lanmuda", [], @isnumeric);

mIp.parse(data, opt, varargin{:});
xFit = mIp.Results.xFit;
yThr = mIp.Results.yThr;
sigmoidName = mIp.Results.sigmoidName;
lanmuda = mIp.Results.lanmuda;


warning('off')
if exist("lanmuda", "var")
    if ~isempty(lanmuda)
        opt.lanmuda = lanmuda;
    end
end
% data validation
if length(data) == numel(data)
    if ~isfield(opt, "lanmuda")
        error("Invalid input 'data' !");
    else
        opt.lanmuda = reshape(opt.lanmuda, [], 1);
        data = reshape(data, [], 1);
        data = [opt.lanmuda, fix(data*1000), ones(size(data, 1), 1) * 1000];
    end
end
if isempty(xFit)
    xFit = linspace(data(1, 1), data(end, 1), 1000);
end
Res = mPFit(data, "expType", "YesNo", "plotFitRes", 0, "sigmoidName", sigmoidName, "xFit", xFit);
ThrRes = Res.xFit(find(Res.yFit >= yThr, 1, "first"));

if isempty(ThrRes)
    if xFit(end) < 3,  data = [data ; 3, 1000, 1000]; end
    if xFit(end) >=3 && xFit(end) < 5, data = [data ; 5, 1000, 1000]; end
    if xFit(end) > 5, data = [data ; 8, 1000, 1000]; end
    xFit = linspace(data(1, 1), data(end, 1), 1000);
    Res = mPFit(data, "expType", "YesNo", "plotFitRes", 0, "sigmoidName", sigmoidName, "xFit", xFit);
    ThrRes = Res.xFit(find(Res.yFit >= yThr, 1, "first"));
end
Res.Threshold = ThrRes;
warning('on')
end



