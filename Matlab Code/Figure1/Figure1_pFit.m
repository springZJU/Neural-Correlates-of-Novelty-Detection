% ccc
ROOTPATH = strcat(getRootDirPath(mfilename("fullpath"), 4), "Data\OriginData\BehaviorOnly\78910\");
temp = dirItem(ROOTPATH, "behavData.mat");
popRes = cell2mat(cellfun(@(x) NoveltySU.population.loadPopData(x), temp.file, "UniformOutput", false));
popMonica = popRes(contains({popRes.Date}', "Monica"));
popCM = popRes(contains({popRes.Date}', "CM"));
pushRatio_Monica = [popMonica.pushRatio];
pushRatio_CM = [popCM.pushRatio];
pushRatio_Monica = [zeros(1, size(pushRatio_Monica, 2)); pushRatio_Monica; ones(1, size(pushRatio_Monica, 2))];
pushRatio_CM = [zeros(1, size(pushRatio_CM, 2)); pushRatio_CM; ones(1, size(pushRatio_CM, 2))];

% opt.lanmuda = log10(logspace(1, 1.1^4, 5));
opt.lanmuda = log10(logspace(1.1^-1, 1.1^5, 7));
opt.fitMethod = 'gaussint';
opt.fitType = "pFit";
behavior1Fit = cell2mat(cellfun(@(x) NoveltySU.utils.threshold.Thrcal_pFit(x, opt, "sigmoidName", "norm"), num2cell(pushRatio_Monica, 1), "uni", false)');
Fig1.c.xFit_Monica = {behavior1Fit.xFit}';
Fig1.c.yFit_Monica = {behavior1Fit.yFit}';
selIdx_Monica = find(cell2mat(cellfun(@(x) length(x) == 1000, Fig1.c.xFit_Monica, "UniformOutput", false)));
Fig1.c.xFit_Monica = Fig1.c.xFit_Monica(selIdx_Monica);
Fig1.c.yFit_Monica = Fig1.c.yFit_Monica(selIdx_Monica);
Fig1.c.yFitMean_Monica = mean(cell2mat(Fig1.c.yFit_Monica), 1);
Fig1.c.lanmuda_Monica = opt.lanmuda;

% opt.lanmuda = log10(logspace(1, 1.03^4, 5));
opt.lanmuda = log10(logspace(1.03^-1, 1.03^5, 7));
opt.fitMethod = 'gaussint';
opt.fitType = "pFit";
behavior2Fit = cell2mat(cellfun(@(x) NoveltySU.utils.threshold.Thrcal_pFit(x, opt, "sigmoidName", "norm"), num2cell(pushRatio_CM, 1), "uni", false)');
Fig1.c.xFit_CM = {behavior2Fit.xFit}';
Fig1.c.yFit_CM = {behavior2Fit.yFit}';
selIdx_CM = find(cell2mat(cellfun(@(x) length(x) == 1000, Fig1.c.xFit_CM, "UniformOutput", false)));
Fig1.c.xFit_CM = Fig1.c.xFit_CM(selIdx_CM);
Fig1.c.yFit_CM = Fig1.c.yFit_CM(selIdx_CM);
Fig1.c.yFitMean_CM = mean(cell2mat(Fig1.c.yFit_CM), 1);
Fig1.c.lanmuda_CM = opt.lanmuda;

%% Fig 1
Fig = figure;
set(Fig, "Position", [250   41.8  711  741]);
% Fig1a+b
axes = subplot(3, 2, 1:4);
Fig1.a.imageCData = imread("Fig1a_b.png");
image(Fig1.a.imageCData);
set(axes, "XTickLabel", "");
set(axes, "YTickLabel", "");


% Fig1c
subplot(3,2,5)
cellfun(@(x, y) NoveltySU.plot.multiPlot(gca, x, y, "#00FFA0"), Fig1.c.xFit_Monica, Fig1.c.yFit_Monica, "UniformOutput", false);
plot(Fig1.c.xFit_Monica{1}, Fig1.c.yFitMean_Monica, "w-", "LineWidth", 4);
xticks(Fig1.c.lanmuda_Monica);
xticklabels(["0", "1", "2", "3", "4"]);
xlim([1, Fig1.c.lanmuda_Monica(end-1)]);
ylim([0, 1]);
xlabel("Frequency Ratio(log(dev/std))");
ylabel("The Ratio of Pressing Button");
title(strcat("Monkey Monica | ", num2str(length(Fig1.c.xFit_Monica))));

subplot(3,2,6)
cellfun(@(x, y) NoveltySU.plot.multiPlot(gca, x, y, "#FF00FF"), Fig1.c.xFit_CM, Fig1.c.yFit_CM, "UniformOutput", false);
plot(Fig1.c.xFit_CM{1}, Fig1.c.yFitMean_CM, "w-", "LineWidth", 4);
xticks(Fig1.c.lanmuda_CM);
xticklabels(["0", "1", "2", "3", "4"]);
xlim([1, Fig1.c.lanmuda_CM(end-1)]);
ylim([0, 1]);
xlabel("Frequency Ratio(log(dev/std))");
ylabel("The Ratio of Pressing Button");
title(strcat("Monkey CM | ", num2str(length(Fig1.c.xFit_CM))));

%% Fig4e
opt.fitType = "pFit"; opt.fitMethod = 'gaussint';
lanmudas = cellfun(@(x) [x(1)/x(2); x/x(1); x(end)^2/x(end-1)/x(1)], {popMonica.devType}', "UniformOutput", false);
realFit_Monica = cell2mat(cellfun(@(x, y) NoveltySU.utils.threshold.Thrcal_pFit(x, opt, 'lanmuda', y), num2cell(pushRatio_Monica, 1)', lanmudas, "uni", false)');

lanmudas = cellfun(@(x) [x(1)/x(2); x/x(1); x(end)^2/x(end-1)/x(1)], {popCM.devType}', "UniformOutput", false);
realFitCM = cell2mat(cellfun(@(x, y) NoveltySU.utils.threshold.Thrcal_pFit(x, opt, 'lanmuda', y), num2cell(pushRatio_CM, 1)', lanmudas, "uni", false)');

Fig = figure;
Fig4e.stdFreq_Monica = cell2mat(cellfun(@(x) x(1), {popMonica(selIdx_Monica).devType}', "UniformOutput", false));
Fig4e.threshold_Monica = [behavior1Fit.Threshold]';
Fig4e.diffThr_Monica = Fig4e.stdFreq_Monica.*(Fig4e.threshold_Monica - 1);

Fig4e.stdFreq_CM = cell2mat(cellfun(@(x) x(1), {popCM(selIdx_CM).devType}', "UniformOutput", false));
Fig4e.threshold_CM = [realFitCM(selIdx_CM).Threshold]';
Fig4e.diffThr_CM = Fig4e.stdFreq_CM.*(Fig4e.threshold_CM - 1);

subplot(2,1,1)
thrSel_Monica = find(Fig4e.threshold_Monica < 1.6);
thrSel_CM = find(Fig4e.threshold_CM < 1.6);

scatter(Fig4e.stdFreq_Monica(thrSel_Monica), Fig4e.threshold_Monica(thrSel_Monica), 20, "green", "square", "LineWidth", 1); hold on;
scatter(Fig4e.stdFreq_CM(thrSel_CM), Fig4e.threshold_CM(thrSel_CM), 20, "magenta", "^", "LineWidth", 1); hold on;
set(gca, "XScale", "log");
xlabel("Standard frequency");
ylabel("Behavior Threshold");

subplot(2,1,2)
scatter(Fig4e.stdFreq_Monica(thrSel_Monica), Fig4e.diffThr_Monica(thrSel_Monica), 20, "green", "square", "LineWidth", 1); hold on;
scatter(Fig4e.stdFreq_CM(thrSel_CM), Fig4e.diffThr_CM(thrSel_CM), 20, "magenta", "^", "LineWidth", 1); hold on;
set(gca, "XScale", "log");
xlabel("Standard frequency");
ylabel("Behavior Threshold");

%% Table1
Table1(1).monkeyInfo = "Monica";
Table1(1).pushRateMean = mean(pushRatio_Monica, 2)';
Table1(1).pushRateSE = SE(pushRatio_Monica, 2)';
Table1(1).noPushRateSE = mean((1-pushRatio_Monica), 2)';
Table1(1).noPushRateMean = SE((1-pushRatio_Monica), 2)';
Table1(2).monkeyInfo = "CM";
Table1(2).pushRateMean = mean(pushRatio_CM, 2)';
Table1(2).pushRateSE = SE(pushRatio_CM, 2)';
Table1(2).noPushRateSE = mean((1-pushRatio_CM), 2)';
Table1(2).noPushRateMean = SE((1-pushRatio_CM), 2)';


% save
save(strcat(getRootDirPath(mfilename("fullpath"), 1), "Figure1_Plot.mat"), "Fig1", "-v7.3");
save(strcat(getRootDirPath(mfilename("fullpath"), 2), "Figure3A-E\Figure3e_Plot.mat"), "Fig3e", "-v7.3");
save(strcat(getRootDirPath(mfilename("fullpath"), 2), "Table1\Table1.mat"), "Table1", "-v7.3");