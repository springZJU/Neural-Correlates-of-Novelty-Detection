load("Figure1_Plot.mat");
%% Fig 1
Fig = figure;
set(Fig, "Position", [250   41.8  711  741]);
% Fig1a+b
axes = subplot(3, 2, 1:4);
image(Fig1.a.imageCData);
set(axes, "XTickLabel", "");
set(axes, "YTickLabel", "");

% Fig1.c.goodIdx_Monica = find(cell2mat(cellfun(@(x) x(end) < 3, Fig1.c.xFit_Monica, "UniformOutput", false)));
% Fig1.c.goodIdx_CM = find(cell2mat(cellfun(@(x) x(end) < 3, Fig1.c.xFit_CM, "UniformOutput", false)));
% Fig1.c.yFit_Monica = Fig1.c.yFit_Monica(Fig1.c.goodIdx_Monica);
% Fig1.c.yFit_CM = Fig1.c.yFit_CM(Fig1.c.goodIdx_CM);
% Fig1.c.xFit_Monica = Fig1.c.xFit_Monica(Fig1.c.goodIdx_Monica);
% Fig1.c.xFit_CM = Fig1.c.xFit_CM(Fig1.c.goodIdx_CM);
Fig1.c.fitPlot_Monica = [Fig1.c.xFit_Monica{1}', Fig1.c.yFitMean_Monica', cell2mat(Fig1.c.yFit_Monica)'];
Fig1.c.fitPlot_CM = [Fig1.c.xFit_CM{1}', Fig1.c.yFitMean_CM', cell2mat(Fig1.c.yFit_CM)'];
Fig1.c.yFitGoodMean_Monica = mean(cell2mat(Fig1.c.yFit_Monica)', 2);
Fig1.c.yFitGoodMean_CM = mean(cell2mat(Fig1.c.yFit_CM)', 2);

subplot(3,2,5)
cellfun(@(x, y) NoveltySU.plot.multiPlot(gca, x, y, "#00FFA0"), Fig1.c.xFit_Monica, Fig1.c.yFit_Monica, "UniformOutput", false);
plot(Fig1.c.xFit_Monica{1}, Fig1.c.yFitGoodMean_Monica, "w-", "LineWidth", 4);
xticks(Fig1.c.lanmuda_Monica);
xticklabels(["0", "1", "2", "3", "4"]);
xlim([1, Fig1.c.lanmuda_Monica(end-1)]);
ylim([0, 1]);
xlabel("Frequency Ratio(log(dev/std))");
ylabel("The Ratio of Pressing Button");
title(strcat("Monkey Monica | ", num2str(length(Fig1.c.xFit_Monica))));

subplot(3,2,6)
cellfun(@(x, y) NoveltySU.plot.multiPlot(gca, x, y, "#FF00FF"), Fig1.c.xFit_CM, Fig1.c.yFit_CM, "UniformOutput", false);
plot(Fig1.c.xFit_CM{1}, Fig1.c.yFitGoodMean_CM, "w-", "LineWidth", 4);
xticks(Fig1.c.lanmuda_CM);
xticklabels(["0", "1", "2", "3", "4"]);
xlim([1, Fig1.c.lanmuda_CM(end-1)]);
ylim([0, 1]);
xlabel("Frequency Ratio(log(dev/std))");
ylabel("The Ratio of Pressing Button");
title(strcat("Monkey CM | ", num2str(length(Fig1.c.xFit_CM))));
