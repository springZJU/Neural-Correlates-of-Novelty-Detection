function res = calDP(spkDev, wins, iteration)
    for wIndex = 1 : size(wins, 1)
        [~, ~, count_Correct] = cellfun(@(x, y) calFR(x, wins(wIndex, :), y), {spkDev.correct(2:end).spikePlot}', {spkDev.correct(2:end).trials}', "UniformOutput", false);
        [~, ~, count_Wrong] = cellfun(@(x, y) calFR(x, wins(wIndex, :), y), {spkDev.wrong(2:end).spikePlot}', {spkDev.wrong(2:end).trials}', "UniformOutput", false);
        temp = cellfun(@(x, y) [x, ones(size(x, 1), 1) ; y, zeros(size(y, 1), 1)], count_Correct, count_Wrong,  "UniformOutput", false);
        zscoreData = cell2mat(cellfun(@(x) [zscore(x(:, 1)), x(:, 3)], temp, "uni", false));
        resDP{wIndex, 1} = DPcal(zscoreData, iteration);
        resDP{wIndex, 1}.timePoint = mean(wins(wIndex, :));
    end
    res = cell2mat(resDP);
end