function [neuLag, pushLag, neuAccumulate] = calTimeLag_ByTrial(spkDev, lagWin, AUCThr,cluster)
narginchk(3, 4);
if nargin < 4
    cluster = "all";
end
% neural time lag
binpara.binsize = 50; binpara.binstep = 5;
for dIndex = 1 : length(spkDev.(cluster))
temp = spkDev.(cluster)(dIndex).spikePlot;
resPsth = cellfun(@(x) calPsth(temp(temp(:, 2) == x, 1), binpara, 1e3, "EDGE", [0, 1000], "NTRIAL", 1), num2cell(unique(temp(:, 2))), "UniformOutput", false);
temp = cellfun(@(x) findWithinInterval(x, lagWin , 1), resPsth, "UniformOutput", false);
t = temp{1}(:, 1);
temp = temp(cell2mat(cellfun(@(x) sum(x(:, 2)) > 0, temp, "UniformOutput", false)));
neuLag(dIndex, 1) = min([lagWin(end); mean(cell2mat(cellfun(@(x) x(find(cumsum(x(:, 2))/sum(x(:, 2)) >= AUCThr, 1, "first"), 1), temp, "uni", false)))]);
if length(temp) > 1
    neuAccumulate{dIndex, 1} = [t, mean(cell2mat(cellfun(@(x) cumsum(x(:, 2))'/sum(x(:, 2)), temp,  "uni", false)))'];
else
    neuAccumulate{dIndex, 1} = [t, cell2mat(cellfun(@(x) cumsum(x(:, 2))'/sum(x(:, 2)), temp,  "uni", false))'];
end
% push time lag
pushLag = [0, cellfun(@mean, {spkDev.correct(2:end).pushLatency})]';

end