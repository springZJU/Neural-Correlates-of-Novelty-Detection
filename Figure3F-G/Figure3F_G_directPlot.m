load("Figure3F_G_Plot.mat");
Fig = figure;
set(Fig, "Position", [401.8   41.8  756.8  741.6]);

%% Fig 5a
% left
subplot(5, 2, [1, 3])

scatter(Fig3F_G(1).behavThr, Fig3F_G(1).neuThr_Early, 20, "green", "square", "LineWidth", 1); hold on;
scatter(Fig3F_G(2).behavThr, Fig3F_G(2).neuThr_Early, 20, "magenta", "^", "LineWidth", 1); hold on;
plot([0, 3], [0, 3], "k--"); hold on;  plot([0, 3], [1, 1], "k--"); hold on;  plot([1, 1], [0, 3], "k--"); hold on;
xlabel("Psychophysical threshold");
ylabel("Neuronal Threshold");
title("0-100ms")

% right
subplot(5, 2, [2, 4])
scatter(Fig3F_G(1).behavThr, Fig3F_G(1).neuThr_Late, 20, "green", "square", "LineWidth", 1); hold on;
scatter(Fig3F_G(2).behavThr, Fig3F_G(2).neuThr_Late, 20, "magenta", "^", "LineWidth", 1); hold on;
plot([0, 3], [0, 3], "k--"); hold on;  plot([0, 3], [1, 1], "k--"); hold on;  plot([1, 1], [0, 3], "k--"); hold on;
xlabel("Psychophysical threshold");
ylabel("Neuronal Threshold");
title("250-350ms")


% Fig 5b
thrStr = ["behavThr", "neuThr_Early", "neuThr_Late"];
titleStr = ["行为阈值分布", "0-100ms 神经元阈值分布", "250-350ms 神经元阈值分布"];
ylabelStr = ["Psychophysical threshold", "Neuronal threshold", "Neuronal threshold"];
for tIndex = 1 : 3
mAxes = subplot(5, 2, [1, 2] + (tIndex+1)*2);
binEdges = 1:0.125:3;
Fig3F_G(3).(thrStr(tIndex)) = vertcat(Fig3F_G.(thrStr(tIndex)));
Fig3F_G(4).(thrStr(tIndex)) = mean(vertcat(Fig3F_G.(thrStr(tIndex))));
histogram(Fig3F_G(3).(thrStr(tIndex)), "BinEdges", binEdges, "DisplayName", "Monica+CM"); hold on;
% histogram(Fig3F_G(2).(thrStr(tIndex)), "BinEdges", binEdges, "DisplayName", "CM"); hold on;
xticks(1:0.25:3);
xlabel("Psychophysical threshold");
ylabel("neuron counts");
legend
end


%% ANCOVA
group = repmat([repmat("Monica", length(Fig3F_G(1).behavThr), 1); repmat("CM", length(Fig3F_G(2).behavThr), 1)],2,1);
thresholds = [vertcat(Fig3F_G(1:2).neuThr_Early); vertcat(Fig3F_G(1:2).neuThr_Late)];
window = [zeros(length(vertcat(Fig3F_G(1:2).neuThr_Early)), 1); ones(length(vertcat(Fig3F_G(1:2).neuThr_Late)), 1)];
[p,tbl,stats,terms] = anovan(thresholds, {group,  window}, "model","full",  "varnames", ["monkey", "Windows"]);

