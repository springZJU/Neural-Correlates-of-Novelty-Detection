load("SFig3_Plot.mat");

%% SFig3
Fig = figure;
set(Fig, "Position", [401.8   41.8  756.8  741.6]);

% SFig3a 
subplot(2, 2, 1)
scatter(SFig3.a.neuThr_Monica, SFig3.a.DP_Monica, 20, "green", "square", "LineWidth", 1); hold on;
scatter(SFig3.a.neuThr_CM, SFig3.a.DP_CM, 20, "magenta", "^", "LineWidth", 1); hold on;
plot([0, 3], [0.5, 0.5], "k--"); hold on;  
ylim([0.25, 1]);
xlabel("Psychophysical threshold");
ylabel("Neuronal Threshold");
title("0-100ms")

% SFig3b
subplot(2, 2, 2)
scatter(SFig3.b.neuThr_Monica, SFig3.b.DP_Monica, 20, "green", "square", "LineWidth", 1); hold on;
scatter(SFig3.b.neuThr_CM, SFig3.b.DP_CM, 20, "magenta", "^", "LineWidth", 1); hold on;
plot([0, 3], [0.5, 0.5], "k--"); hold on;  
ylim([0.25, 1]);
xlabel("Neuronal Threshold");
ylabel("DP Value");
title("250-350ms")


