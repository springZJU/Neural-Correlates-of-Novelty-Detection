function res = spkStdSlope(spkStd)
% early response
temp = num2cell([cell2mat(cellfun(@(x, y) [x, NaN*ones(size(x, 1), spkStd(end).stdNum - y)], {spkStd(1:end-1).frRaw_Early}', {spkStd(1:end-1).stdNum}', "UniformOutput", false)); spkStd(end).frRaw_Early], 1);
res.frRaw_Early = cellfun(@(x) x(~isnan(x)), temp, "UniformOutput", false)';
res.frMean_Early = cell2mat(cellfun(@(x) mean(x), res.frRaw_Early, "UniformOutput", false));
res.frSE_Early = cell2mat(cellfun(@(x) SE(x), res.frRaw_Early, "UniformOutput", false));


% late response
temp = num2cell([cell2mat(cellfun(@(x, y) [x, NaN*ones(size(x, 1), spkStd(end).stdNum - y)], {spkStd(1:end-1).frRaw_Late}', {spkStd(1:end-1).stdNum}', "UniformOutput", false)); spkStd(end).frRaw_Late], 1);
res.frRaw_Late = cellfun(@(x) x(~isnan(x)), temp, "UniformOutput", false)';
res.frMean_Late = cell2mat(cellfun(@(x) mean(x), res.frRaw_Late, "UniformOutput", false));
res.frSE_Late = cell2mat(cellfun(@(x) SE(x), res.frRaw_Late, "UniformOutput", false));


end