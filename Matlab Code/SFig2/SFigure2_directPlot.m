ccc
load("Sfig2_Plot.mat");
Fig = figure;
set(Fig, "Position", [401.8   41.8  756.8  741.6]);


% SFig1a left
subplot(2, 2, 1)
scatter(Sfig2.a.behavThr.Monica, Sfig2.a.neuThr.Monica_Early, 20, "green", "square", "LineWidth", 1); hold on;
scatter(Sfig2.a.behavThr.CM, Sfig2.a.neuThr.CM_Early, 20, "magenta", "^", "LineWidth", 1); hold on;
plot([0, 3], [0, 3], "k--"); hold on;  plot([0, 3], [1, 1], "k--"); hold on;  plot([1, 1], [0, 3], "k--"); hold on;
xlabel("Psychophysical threshold");
ylabel("Neuronal Threshold");
title("0-100ms")

% SFig1a right
subplot(2, 2, 2)
scatter(Sfig2.a.behavThr.Monica, Sfig2.a.neuThr.Monica_Late, 20, "green", "square", "LineWidth", 1); hold on;
scatter(Sfig2.a.behavThr.CM, Sfig2.a.neuThr.CM_Late, 20, "magenta", "^", "LineWidth", 1); hold on;
plot([0, 3], [0, 3], "k--"); hold on;  plot([0, 3], [1, 1], "k--"); hold on;  plot([1, 1], [0, 3], "k--"); hold on;
xlabel("Psychophysical threshold");
ylabel("Neuronal Threshold");
title("250-350ms")


% SFig1b left
subplot(2, 2, 3)
scatter(Sfig2.b.behavThr.Monica, Sfig2.b.neuThr.Monica_Early, 20, "green", "square", "LineWidth", 1); hold on;
scatter(Sfig2.b.behavThr.CM, Sfig2.b.neuThr.CM_Early, 20, "magenta", "^", "LineWidth", 1); hold on;
plot([0, 3], [0, 3], "k--"); hold on;  plot([0, 3], [1, 1], "k--"); hold on;  plot([1, 1], [0, 3], "k--"); hold on;
xlabel("Psychophysical threshold");
ylabel("Neuronal Threshold");
title("0-100ms")

% SFig1b right
subplot(2, 2, 4)
scatter(Sfig2.b.behavThr.Monica, Sfig2.b.neuThr.Monica_Late, 20, "green", "square", "LineWidth", 1); hold on;
scatter(Sfig2.b.behavThr.CM, Sfig2.b.neuThr.CM_Late, 20, "magenta", "^", "LineWidth", 1); hold on;
plot([0, 3], [0, 3], "k--"); hold on;  plot([0, 3], [1, 1], "k--"); hold on;  plot([1, 1], [0, 3], "k--"); hold on;
xlabel("Psychophysical threshold");
ylabel("Neuronal Threshold");
title("250-350ms")
