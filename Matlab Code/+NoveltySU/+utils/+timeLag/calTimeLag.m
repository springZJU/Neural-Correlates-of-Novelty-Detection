function [neuLag, pushLag, neuAccumulate] = calTimeLag(spkDev, lagWin, AUCThr,cluster)
narginchk(3, 4);
if nargin < 4
    cluster = "all";
end
% neural time lag
t = findWithinInterval(spkDev.(cluster)(1).PSTH(:, 1), lagWin, 1);
temp = cellfun(@(x) findWithinInterval(x, lagWin , 1), {spkDev.(cluster).PSTH}', "UniformOutput", false);

neuLag = cell2mat(cellfun(@(x) x(find(cumsum(x(:, 2))/sum(x(:, 2)) >= AUCThr, 1, "first"), 1), temp, "uni", false));
neuAccumulate = cellfun(@(x) [t, cumsum(x(:, 2))/sum(x(:, 2))], temp, "uni", false);

% push time lag
pushLag = [0, cellfun(@mean, {spkDev.correct(2:end).pushLatency})]';


end