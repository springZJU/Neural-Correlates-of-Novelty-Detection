function [Res,ThrRes] = Thrcal(data,opt,varargin)
% opt.lanmuda
% opt.xThr : the maximum of x obtained from fit curve
% opt.yThr
% opt.thrMethod
% opt.plotYN
% varargin: fitMethod:
%           fitRes: if fitted previous, use this function as:
%           Thrcal(data,opt,'fitRes',fitRes);
warning('off')
plotYN = false;
for i = 1:2:length(varargin)
    eval([ varargin{i} '=varargin{i+1};']);
end

if exist("lanmuda", "var")
    opt.lanmuda = lanmuda;
end
defopt = NoveltySU.utils.threshold.defConfig(data,opt);
parseStruct(defopt);

%% fit curve according to input (lanmuda & data)


if ~exist('fitRes','var')
norx = lanmuda;
nory = data;
[Res.R2,Res.yFit,Res.fitRes,Res.Threshold,Res.norx, Res.xFit] = NoveltySU.utils.threshold.psychometricFit(nory,plotYN,defopt); 
end
ThrRes = Res.Threshold;
warning('on')
end



