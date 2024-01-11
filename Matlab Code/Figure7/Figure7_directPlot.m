load("Figure7_Plot.mat")
%% Fig7
Fig = figure;
set(Fig, "Position", [0, 235.4, 1528, 358]);

% Fig 7a Left
subplot(2,2, 1)
errorbar(Fig7.stdNum, Fig7.a.Mean_Left, Fig7.a.SE_Left, "r-", "LineWidth", 2);
xlabel("Standard No.");
ylabel("Firing Rate(Hz)");
title("an example with prediction suppression");

% Fig 7a Right
subplot(2, 2, 2)
errorbar(Fig7.stdNum, Fig7.a.Mean_Right, Fig7.a.SE_Right, "r-", "LineWidth", 2);
xlabel("Standard No.");
ylabel("Firing Rate(Hz)");
title("an example without adaptation");

% Fig 7b Monica GYM version
subplot(2, 2, 3)
Fig7.b.noSigBin = histcounts(Fig7.b.noSigSlope, -3.5:0.5:2);
[~, Fig7.b.ttestP] = ttest([Fig7.b.sigSlope; Fig7.b.noSigSlope], 0);
histogram(Fig7.b.sigSlope-0.5, "BinWidth", 1, "BinEdges", -2.5:0.5:2, "DisplayName", "R2>=0.5"); hold on
histogram(Fig7.b.noSigSlope-0.5, "BinWidth", 1, "BinEdges", -2.5:0.5:2, "DisplayName", "R2<0.5"); hold on
legend
title("threshold distribution of Monica");
xlabel("theshold");
ylabel("counts");

Fig7.b.decrease = sum([Fig7.b.sigSlope; Fig7.b.noSigSlope] < 0);
Fig7.b.sigDecrease = sum(Fig7.b.sigSlope < 0 );