function res = spkStdTest(spkStd, varargin)
% Description: process standard response
% Input:
%       spkStd: struct of standard result
%       slopeEdge: the standard number chosen to compute slope

mIp = inputParser;
mIp.addRequired("spkStd", @isstruct);
mIp.addParameter("slopeEdge", [4, 7], @(x) isnumeric(x));
mIp.parse(spkStd, varargin{:});

slopeEdge = mIp.Results.slopeEdge;
numScale = slopeEdge(1) : slopeEdge(end);
% early response
temp = num2cell([cell2mat(cellfun(@(x, y) [x, NaN*ones(size(x, 1), spkStd(end).stdNum - y)], {spkStd(1:end-1).frRaw_Early}', {spkStd(1:end-1).stdNum}', "UniformOutput", false)); spkStd(end).frRaw_Early], 1);
res.frRaw_Early = cellfun(@(x, y) [x(~isnan(x)), y*ones(length(x(~isnan(x))), 1)], temp, num2cell(1:length(temp)), "UniformOutput", false)';
res.frMean_Early = cell2mat(cellfun(@(x) mean(x(:, 1)), res.frRaw_Early, "UniformOutput", false));
res.frSE_Early = cell2mat(cellfun(@(x) SE(x(:, 1)), res.frRaw_Early, "UniformOutput", false));
p = polyfit(numScale, res.frMean_Early(numScale), 1);
res.slope_Early = p(1);
res.p_Early = p;
res.R2_Early = rsquare(res.frMean_Early(numScale), polyval(p, numScale)');
% try
%     [res.b_Early, res.a_Early, ~, ~, ~, res.regressP_Early] = regress_perp(numScale', res.frMean_Early(numScale));
% catch
%     res.b_Early = 0;  res.a_Early = 0;  res.regressP_Early = 1;
% end
% temp = cell2mat(res.frRaw_Early(numScale));
% [res.b_Early, res.a_Early, ~, ~, ~, res.regressP_Early] = regress_perp(temp(:, 2), temp(:, 1));

% late response
temp = num2cell([cell2mat(cellfun(@(x, y) [x, NaN*ones(size(x, 1), spkStd(end).stdNum - y)], {spkStd(1:end-1).frRaw_Late}', {spkStd(1:end-1).stdNum}', "UniformOutput", false)); spkStd(end).frRaw_Late], 1);
res.frRaw_Late = cellfun(@(x, y) [x(~isnan(x)), y*ones(length(x(~isnan(x))), 1)], temp, num2cell(1:length(temp)), "UniformOutput", false)';
res.frMean_Late = cell2mat(cellfun(@(x) mean(x(:, 1)), res.frRaw_Late, "UniformOutput", false));
res.frSE_Late = cell2mat(cellfun(@(x) SE(x(:, 1)), res.frRaw_Late, "UniformOutput", false));
p = polyfit(numScale, res.frMean_Late(numScale), 1);
res.slope_Late = p(1);
res.p_Late = p;
res.R2_Late = rsquare(res.frMean_Late(numScale), polyval(p, numScale)');
% try
%     [res.b_Late, res.a_Late, ~, ~, ~, res.regressP_Late] = regress_perp(numScale', res.frMean_Late(numScale));
% catch
%     res.b_Late = 0;  res.a_Late = 0;  res.regressP_Late = 1;
% end
% temp = cell2mat(res.frRaw_Late(numScale));
% [res.b_Late, res.a_Late, ~, ~, ~, res.regressP_Late] = regress_perp(temp(:, 2), temp(:, 1));

res.ttestRes_Early = tTestCertainCell(cellfun(@(x) [x, (1:length(x))'], res.frRaw_Early, "UniformOutput", false), "Tail", "right");
res.ttestRes_Late = tTestCertainCell(cellfun(@(x) [x, (1:length(x))'], res.frRaw_Late, "UniformOutput", false), "Tail", "right");

for sIndex = [spkStd(1:end-1).stdNum]
    temp = cellfun(@(x) find([x(sIndex).H]' == 1 & (1:length(x)) < find(isnan([x(sIndex).H]')), 1, "last")+1, {res.ttestRes_Early}', "UniformOutput", false);
    res.thr_Early_All{sIndex,1} = cell2mat(cellfun(@(x) max([x, 0]), temp, "UniformOutput", false))';
    temp = cellfun(@(x) find([x(sIndex).H]' == 1 & (1:length(x)) < find(isnan([x(sIndex).H]')), 1, "last")+1, {res.ttestRes_Late}', "UniformOutput", false);
    res.thr_Late_All{sIndex,1} = cell2mat(cellfun(@(x) max([x, 0]), temp, "UniformOutput", false))';
end
res.thrIdx_Early = max([spkStd(1).stdNum; cell2mat(cellfun(@(x, y) y*find(all([x(y:spkStd(end).stdNum); 0])), {res.ttestRes_Early([spkStd.stdNum]).H}', {spkStd.stdNum}', "UniformOutput", false))]);
res.thrIdx_Late = max([spkStd(1).stdNum; cell2mat(cellfun(@(x, y) y*find(all([x(y:spkStd(end).stdNum); 0])), {res.ttestRes_Late([spkStd.stdNum]).H}', {spkStd.stdNum}', "UniformOutput", false))]);

res.thr_Early = cell2mat(res.thr_Early_All(res.thrIdx_Early));
res.thr_Late = cell2mat(res.thr_Late_All(res.thrIdx_Late));
end
