ccc
load("Figure2I-J_plot.mat");
Fig = figure;
maximizeFig(Fig);

% Fig 2a
subplot(2, 2, 1)
colors = ["r-", "b-"];
for mIndex = 1 : 2 % 1:Monica 2:CM
  plot(Fig2.i(mIndex).DPPlot(:, 1), Fig2.i(mIndex).DPValue, colors(mIndex)); hold on   
end
xlabel("Time from DevOnset");
ylabel("DRP Value")

% Fig 2b 
subplot(2, 2, 3)
histogram(Fig2.j1.Sig, "BinEdges", 0.1:0.1:1); hold on;
histogram(Fig2.j1.noSig, "BinEdges", 0.1:0.1:1); hold on;
[Fig2.j1.sigBar, Fig2.j1.Edge] = histcounts(Fig2.j1.Sig, 0.1:0.1:1);
[Fig2.j1.noSigBar, Fig2.j1.Edge] = histcounts(Fig2.j1.noSig, 0.1:0.1:1);

title("DRP Value in [0, 100]");
xlabel("DRP Value");
ylabel("Counts")


% Fig 2c 
subplot(2, 2, 4)
histogram(Fig2.j2.Sig, "BinEdges", 0.3:0.1:1); hold on;
histogram(Fig2.j2.noSig, "BinEdges", 0.3:0.1:1); hold on;
[Fig2.j2.sigBar, Fig2.j2.Edge] = histcounts(Fig2.j2.Sig, 0.1:0.1:1);
[Fig2.j2.noSigBar, Fig2.j2.Edge] = histcounts(Fig2.j2.noSig, 0.1:0.1:1);

title("DRP Value in [250, 350]");
xlabel("DRP Value");
ylabel("Counts")

%% ANCOVA
monicaIdx = Fig2.j2.monicaIdx;
cmIdx     = Fig2.j2.cmIdx;
group     = repmat([repmat("Monica", sum(monicaIdx), 1); repmat("CM", sum(cmIdx), 1)],2,1);
DP = [Fig2.j1.DP; Fig2.j2.DP];
window = [zeros(length(Fig2.j1.DP), 1); ones(length(Fig2.j2.DP), 1)];
[p,tbl,stats,terms] = anovan([Fig2.j1.DP; Fig2.j2.DP], {group,  window}, "model", "full", "varnames", ["monkey", "DPWindows"]);
