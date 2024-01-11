load("Figure5_Plot.mat");
%% Fig 5
Fig = figure;
maximizeFig(Fig)

selectRes = popRes(matches({popRes.Date}', "CM_ty20191_A50L17cell5") & matches({popRes.protStr}', "ActiveFreqRight"));
devType = [selectRes.spkDev.all.devType]';
% Fig5a CM cell5
subplot(4, 3, 1);
repeat = Fig5.a.repeat;
scatter(Fig5.a.rasterPlot(:, 1), Fig5.a.rasterPlot(:, 2), 5, "black", "filled"); hold on;
cellfun(@(x) NoveltySU.plot.multiPlot(gca, [0, 100], [x, x], "k", "-", 0.5), num2cell((repeat:repeat:repeat*length(temp)-repeat)+0.5), "UniformOutput", false);
yticks([1, 9, 17, 26]*length(temp{1})-length(temp{1})/2);
yticklabels(mat2cellStr([result.data([1, 9, 17, 26]).freq]));
ylim([0, 26*length(temp{1})]);
xlim([0, 100]);

% Fig5b
subplot(4,3,2)
errorbar(1:length(Fig5.b.tone), Fig5.b.frMean, Fig5.b.frSE, "k-", "LineWidth", 1); hold on
stdFreqPos = find(Fig5.b.tone == roundn(devType(1)/1000, -1));
if stdFreqPos < 26
    xticks([1, stdFreqPos, 26]);
    xticklabels(string(cellfun(@num2str, num2cell([result.data(1).freq, devType(1), result.data(end).freq]), 'UniformOutput', false)));
else
    xticks([1, 26]);
    xticklabels(string(cellfun(@num2str, num2cell([result.data(1).freq, result.data(end).freq]), 'UniformOutput', false)));
end
xlim([0.9, 26.1]);
plot([Fig5.b.stdFreqPos, Fig5.b.stdFreqPos], [0, max(Fig5.b.frMean) + max(Fig5.b.frSE)], "k--"); hold on
xlabel("Frequency(kHz)");
ylabel("Firing Rate(kHz)");
title("std<dev");


% Fig5c
subplot(4,3,3)
Fig5.c.devDiff = [selectRes.spkDev.correct.devType]'./ selectRes.spkDev.correct(1).devType;
Fig5.c.respMean = [selectRes.spkDev.correct.frMean_Late]';
Fig5.c.respSE = [selectRes.spkDev.correct.frSE_Late]';
[Fig5.c.anovaP, Fig5.c.postHoc, Fig5.c.postHoc_H] = mAnovaCell({selectRes.spkDev.correct(2:end).frRaw_Late}', "label", (1:4)');
xticks(Fig5.c.devDiff);
xlabel("Frequency Ratio(dev/std)");
ylabel("Firing Rate(kHz)");
title("250-350ms");
errorbar(Fig5.c.devDiff, Fig5.c.respMean, Fig5.c.respSE, "k-", "LineWidth", 1); hold on;


% Fig5d CM cell1
repeat = Fig5.d.repeat;
selectRes = popRes(matches({popRes.Date}', "CM_ty20191_A50R10cell1") & matches({popRes.protStr}', "ActiveFreqLeft"));
devType = [selectRes.spkDev.all.devType]';
subplot(4, 3, 4);
scatter(Fig5.d.rasterPlot(:, 1), Fig5.d.rasterPlot(:, 2), 5, "black", "filled"); hold on;
cellfun(@(x) NoveltySU.plot.multiPlot(gca, [0, 100], [x, x], "k", "-", 0.5), num2cell((repeat:repeat:repeat*length(temp)-repeat)+0.5), "UniformOutput", false);
yticks([1, 9, 17, 26]*length(temp{1})-length(temp{1})/2);
yticklabels(mat2cellStr([result.data([1, 9, 17, 26]).freq]));
ylim([0, 26*length(temp{1})]);
xlim([0, 100]);


% Fig5e

subplot(4,3,5)
stdFreqPos = find(Fig5.e.tone == roundn(devType(1)/1000, -1));
if stdFreqPos < 26
    xticks([1, stdFreqPos, 26]);
    xticklabels(string(cellfun(@num2str, num2cell([result.data(1).freq, devType(1), result.data(end).freq]), 'UniformOutput', false)));
else
    xticks([1, 26]);
    xticklabels(string(cellfun(@num2str, num2cell([result.data(1).freq, result.data(end).freq]), 'UniformOutput', false)));
end
xlim([0.9, 26.1]);
plot([Fig5.e.stdFreqPos, Fig5.e.stdFreqPos], [0, max(Fig5.e.frMean) + max(Fig5.e.frSE)], "k--"); hold on
xlabel("Frequency(kHz)");
ylabel("Firing Rate(kHz)");
title("std>dev");

% Fig5f
subplot(4,3,6)
errorbar(Fig5.f.devDiff, Fig5.f.respMean, Fig5.f.respSE, "k-", "LineWidth", 1); hold on;
xlabel("Frequency Ratio(dev/std)");
ylabel("Firing Rate(kHz)");
title("250-350ms");


% Fig5g
repeat = Fig5.g.repeat;
subplot(4, 3, 7);
scatter(gca, Fig5.g.rasterPlot(:, 1), Fig5.g.rasterPlot(:, 2), 5, "black", "filled"); hold on;
cellfun(@(x) NoveltySU.plot.multiPlot(gca, [0, 100], [x, x], "k", "-", 0.5), num2cell((repeat:repeat:repeat*length(temp)-repeat)+0.5), "UniformOutput", false);
yticks([1, 9, 17, 26]*length(temp{1})-length(temp{1})/2);
yticklabels(mat2cellStr([result.data([1, 9, 17, 26]).freq]));
ylim([0, 26*length(temp{1})]);
xlim([0, 100]);


% Fig5h
subplot(4,3,8)
errorbar(1:length(Fig5.h.tone), Fig5.g.frMean, Fig5.g.frSE, "k-", "LineWidth", 1); hold on
stdFreqPos = find(Fig5.h.tone == roundn(devType(1)/1000, -1));
xticks([1, stdFreqPos, 26]);
xticklabels(string(cellfun(@num2str, num2cell([result.data(1).freq, devType(1), result.data(end).freq]), 'UniformOutput', false)));
xlim([0.9, 26.1]);
plot([Fig5.h.stdFreqPos, Fig5.h.stdFreqPos], [0, max(Fig5.g.frMean) + max(Fig5.g.frSE)], "k--"); hold on
xlabel("Frequency(kHz)");
ylabel("Firing Rate(kHz)");
title("std<dev");

% Fig5i
subplot(4,3,9)
errorbar(Fig5.i.devDiff, Fig5.i.respMean, Fig5.i.respSE, "k-", "LineWidth", 1); hold on;
xlabel("Frequency Ratio(dev/std)");
ylabel("Firing Rate(kHz)");


% Fig5j
subplot(4,3, 10);
errorbar(Fig5.j.devType, Fig5.j.respMean_Monica, Fig5.j.respSE_Monica, "m-", "LineWidth", 1, "DisplayName", "Monica"); hold on;
errorbar(Fig5.j.devType, Fig5.j.respMean_CM, Fig5.j.respSE_CM, "g-", "LineWidth", 1, "DisplayName", "CM"); hold on;
xlabel("Frequency Ratio(log(dev/std))");
ylabel("Firing Rate(Hz)");
title("ActiveFreqRight");

% Fig5k
subplot(4,3, 11);
errorbar(Fig5.k.devType, Fig5.k.respMean_Monica, Fig5.k.respSE_Monica, "m-", "LineWidth", 1, "DisplayName", "Monica"); hold on;
errorbar(Fig5.k.devType, Fig5.k.respMean_CM, Fig5.k.respSE_CM, "g-", "LineWidth", 1, "DisplayName", "CM"); hold on;
xlabel("Frequency Ratio(log(dev/std))");
ylabel("Firing Rate(Hz)");
title("ActiveFreqLeft");

% Fig5l
subplot(4,3, 12);
errorbar(Fig5.l.devType, Fig5.l.respMean_Monica, Fig5.l.respSE_Monica, "m-", "LineWidth", 1, "DisplayName", "Monica"); hold on;
errorbar(Fig5.l.devType, Fig5.l.respMean_CM, Fig5.l.respSE_CM, "g-", "LineWidth", 1, "DisplayName", "CM"); hold on;
xlabel("Frequency Ratio(log(dev/std))");
ylabel("Firing Rate(Hz)");
title("ActiveNoResponse");
