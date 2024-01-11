ccc
load("Figure4A_G_Plot.mat");
%% Fig 4
Fig = figure;
set(Fig, "Position", [486.6   41.8  488.8  741.6]);

% Fig 4a
subplot(5, 3, 1)
scatter(Fig4.a.spikePlot(:, 1), Fig4.a.spikePlot(:, 2), 3, 'red', 'filled'); hold on;
plot([0, 1000], repmat(Fig4.a.yLine, 1, 2), "k-", "LineWidth", 1); hold on;
yticks(Fig4.a.yTick);
yticklabels(Fig4.a.yTickLabel);
xlim([0, 600]);
ylim([0, max(Fig4.a.spikePlot(:, 2))]);
title("devOnset Raster Plot");
ylabel("Frequancy Ratio (dev/std)");
xlabel("Time (ms)");

% Fig 4b left
subplot(5, 3, 2)
% spearman correlation
spearmanData = [cell2mat(cellfun(@(x, y) ones(diff(x)+1, 1)*str2double(y), Fig4.b.trialNum, Fig4.b.yTickLabel, "uni", false)), Fig4.b.pushPlot(:, 1)];
[Fig4.b.Spearman, Fig4.b.SpearmanPval] = corr(spearmanData(:, 1), spearmanData(:, 2), "type", "Spearman");

scatter(Fig4.b.pushPlot(:, 1), Fig4.b.pushPlot(:, 2), 3, 'red', 'filled'); hold on;
plot([0, 1000], repmat(Fig4.b.yLine, 1, 2), "k-", "LineWidth", 1); hold on;
cellfun(@(x, y) NoveltySU.plot.multiPlot(gca, [x, x], y, "k"), num2cell(Fig4.b.meanPush), Fig4.b.trialNum, "UniformOutput", false);
yticks(Fig4.b.yTick);
yticklabels(Fig4.b.yTickLabel);
xlim([0, 600]);
ylim([0, max(Fig4.b.pushPlot(:, 2))]);
title("devOnset Push Plot");
ylabel("Frequancy Ratio (dev/std)");
xlabel("Time (ms)");


% Fig 4b right
subplot(5, 3, 3)
scatter(Fig4.b.behavX, Fig4.b.behavY, 30, "black"); hold on
plot(Fig4.b.xFit, Fig4.b.yFit, "k-", "LineWidth", 4); hold on
xlabel("Frequency Ratio(dev/std)");
ylabel("Ratio of Pressing Button");
title("behavior");


% Fig 4c
subplot(5, 2, 3)
cellfun(@(x, y, z) NoveltySU.plot.multiPlot(gca, x(:, 1), x(:, 2), y, "-", 1.5), Fig4.c.PSTH, Fig4.c.colors, Fig4.c.displayName, "UniformOutput", false);
xlim([200, 600]);
xlabel("Time from onset");
ylabel("Foromg Rate(Hz)");

% Fig 4d
subplot(5, 2, 4)
cellfun(@(x, y, z) NoveltySU.plot.multiPlot(gca, x(:, 1), x(:, 2), y, "-", 1.5), Fig4.d.PSTH, Fig4.d.colors, Fig4.d.displayName, "UniformOutput", false);
xlim([200, 600]);
xlabel("Time from onset");
ylabel("Foromg Rate(Hz)");

% Fig 4e left
subplot(5, 2 ,5)
cellfun(@(x, y) NoveltySU.plot.multiPlot(gca, Fig4.eL.t, x, y, "-", 1.5), Fig4.eL.PSTH_Mean(2:end), Fig4.eL.colors, "UniformOutput", false);
xlim([200, 600]);
xlabel("Time from onset");
ylabel("Firing Rate(Hz)");
% plot significance bar
plot(Fig4.eL.t, 50*ones(length(Fig4.eL.t), 1), "k-", "LineWidth", 3); hold on;
sigIdx = logical(Fig4.eL.anovaH);
plot(Fig4.eL.t(sigIdx), 50*ones(sum(sigIdx), 1), "r-", "LineWidth", 3); hold on;


% Fig 4f left
subplot(5, 2 ,7)
cellfun(@(x, y) NoveltySU.plot.multiPlot(gca, Fig4.fL.t, x, y, "-", 1.5), Fig4.fL.PSTH_Mean(2:end), Fig4.fL.colors,  "UniformOutput", false);
xlim([200, 600]);
xlabel("Time from onset");
ylabel("Firing Rate(Hz)");
% plot significance bar
plot(Fig4.fL.t, 10*ones(length(Fig4.fL.t), 1), "k-", "LineWidth", 3); hold on;
sigIdx = logical(Fig4.fL.anovaH);
plot(Fig4.fL.t(sigIdx), 10*ones(sum(sigIdx), 1), "r-", "LineWidth", 3); hold on;

% Fig 4e right
subplot(5, 2 ,6)
cellfun(@(x, y) NoveltySU.plot.multiPlot(gca, Fig4.eR.t, x, y, "-", 1.5), Fig4.eR.PSTH_Mean(2:end), Fig4.eR.colors,  "UniformOutput", false);
xlim([200, 600]);
xlabel("Time from onset");
ylabel("Firing Rate(Hz)");
% plot significance bar
plot(Fig4.eR.t, 80*ones(length(Fig4.eR.t), 1), "k-", "LineWidth", 3); hold on;
sigIdx = logical(Fig4.eR.anovaH);
plot(Fig4.eR.t(sigIdx), 80*ones(sum(sigIdx), 1), "r-", "LineWidth", 3); hold on;


% Fig 4f right
subplot(5, 2 ,8)
cellfun(@(x, y) NoveltySU.plot.multiPlot(gca, Fig4.fR.t, x, y, "-", 1.5), Fig4.fR.PSTH_Mean(2:end), Fig4.fR.colors,  "UniformOutput", false);
xlim([200, 600]);
xlabel("Time from onset");
ylabel("Firing Rate(Hz)");
% plot significance bar
plot(Fig4.fR.t, 12*ones(length(Fig4.fR.t), 1), "k-", "LineWidth", 3); hold on;
sigIdx = logical(Fig4.fR.anovaH);
plot(Fig4.fR.t(sigIdx), 12*ones(sum(sigIdx), 1), "r-", "LineWidth", 3); hold on;

% Fig 4g left
subplot(5, 2 ,9)
cellfun(@(x, y) NoveltySU.plot.multiPlot(gca, Fig4.gL.t, x, y, "-", 1.5), Fig4.gL.PSTH_Mean(2:end), Fig4.gL.colors,  "UniformOutput", false);
plot(gca, [0, 0], [0, 100], "k--"); hold on;
xlim([-400, 400]);
xlabel("Time from onset");
ylabel("Firing Rate(Hz)");


% Fig 4g right
subplot(5, 2 ,10)
cellfun(@(x, y) NoveltySU.plot.multiPlot(gca, Fig4.gR.t, x, y, "-", 1.5), Fig4.gR.PSTH_Mean(2:end), Fig4.gR.colors,  "UniformOutput", false);
plot(gca, [0, 0], [0, 120], "k--"); hold on;
xlim([-400, 400]);
xlabel("Time from onset");
ylabel("Firing Rate(Hz)");