ccc
load("Figure2A_H_Plot.mat");

%% Fig2
Fig = figure;
set(Fig, "Position", [486.6   41.8  488.8  741.6]);
%Fig2a
subplot(5, 2, 1)
plot(Fig2.a.behavFit.xFit, Fig2.a.behavFit.yFit, "k-", "LineWidth", 2); hold on
scatter(Fig2.a.devType ./ Fig2.a.devType(1) , Fig2.a.pushRatio, 40, "black"); hold on
xlim([1, 1.5]);
ylim([0, 1]);
xlabel("Frequency Ratio(dev/std)");
ylabel("Ratio of Pressing Button");
title("behavior");

% Fig2b
subplot(5, 2, 2)
% spearman correlation 
spearmanData = [cell2mat(cellfun(@(x, y) ones(diff(x)+1, 1)*str2double(y), Fig2.b.trialNum, Fig2.b.yTickLabel, "uni", false)), Fig2.b.pushPlot(:, 1)];
[Fig2.b.Spearman, Fig2.b.SpearmanPval] = corr(spearmanData(:, 1), spearmanData(:, 2), "type", "Spearman");
scatter(Fig2.b.pushPlot(:, 1), Fig2.b.pushPlot(:, 2), 3, 'red', 'filled'); hold on;
plot([0, 1000], repmat(Fig2.b.yLine, 1, 2), "k-", "LineWidth", 1); hold on;
cellfun(@(x, y) NoveltySU.plot.multiPlot(gca, [x, x], y, "k"), num2cell(Fig2.b.meanPush), Fig2.b.trialNum, "UniformOutput", false);
yticks(Fig2.b.yTick);
yticklabels(Fig2.b.yTickLabel);
xlim([0, 600]);
ylim([0, max(Fig2.b.pushPlot(:, 2))]);
title("devOnset Push Plot");
ylabel("Frequancy Ratio (dev/std)");
xlabel("Time (ms)");

% Fig2c
subplot(5, 2, [3 4])
image(Fig2.c.FR, 'CDataMapping', 'scaled');
yticks(10:10:70);
yticklabels(cellfun(@(x) num2str(x), num2cell(10:10:70), "uni", false));
xticks(1:2:25);
freq = roundn(log10(logspace(0.200, 19.079, 13)), -1);
xticklabels(cellfun(@(x) num2str(x), num2cell(freq), "UniformOutput", false));
ylabel("SPL(dB)");
colorbar;

% Fig2d
subplot(5, 2, [5, 6])
scatter(Fig2.d.spikePlotStd(:, 1), Fig2.d.spikePlotStd(:, 2), 3, 'black', 'filled'); hold on;
scatter(Fig2.d.spikePlotDev(:, 1), Fig2.d.spikePlotDev(:, 2), 3, 'red', 'filled'); hold on;
xlim([-3600, 1000]);
xticks(-3500:500:1000);
xticklabels(cellfun(@(x) num2str(x), num2cell([0:500:3000, 0:500:1000]), "UniformOutput", false));
title("dev/std = 1.21");
ylabel("Frequancy Ratio (dev/std)");
xlabel("Time (ms)");

% Fig2e
subplot(5, 2, 7)
b = bar(gca, Fig2.e.binEdges, Fig2.e.barVal, 2);
b(1).FaceColor = [1 0 0]; b(1).BarWidth = 1;
b(2).FaceColor = [0 0 0]; b(2).BarWidth = 1;
xlabel("zscore value");
ylabel("counts");
title("250-350ms");

% Fig2f
subplot(5, 2, 8)
plot(Fig2.f.x, Fig2.f.push, "r-", "DisplayName", "pressing button"); hold on;
plot(Fig2.f.x, Fig2.f.noPush, "k-", "DisplayName", "no-pressing button"); hold on;
xlim([0, 1000]);
xlabel("Time (ms)");
ylabel("Firing Rate(Hz)");

% Fig2g
subplot(5, 2, 9)
plot(Fig2.g.falseAlarm, Fig2.g.Hit, "r-"); hold on
plot([0, 0], [1, 1], "k--"); hold on
xlabel("False-alarm rate");
ylabel("Hit Rate");
title(['DP = ', num2str(roundn(Fig2.g.DP, -2))]);

% Fig2h
subplot(5, 2, 10)
plot(Fig2.h.time, Fig2.h.DP, "k-", "LineWidth", 2); hold on;
scatter(Fig2.h.sigT, Fig2.h.sigDP, 30, "black", "filled"); hold on;
scatter(Fig2.h.noSigT, Fig2.h.noSigDP, 30, "black"); hold on;
plot([0, 1000], [0.5, 0.5], "k--");
ylim([0, 1]);
xlabel("Time (ms)");
ylabel("DRP");

