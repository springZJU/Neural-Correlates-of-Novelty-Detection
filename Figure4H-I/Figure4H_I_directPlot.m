%% Fig 4H_I
load("Figure4H_I_Plot.mat");
Fig = figure;

% Fig4h
subplot(2, 2, [1, 2]);
cellfun(@(x, y) NoveltySU.plot.multiPlot(gca, x(:, 1), x(:, 2), y, "-", 1.5), Fig4.h.Accum(2:end), Fig4.colors, "UniformOutput", false);

% Fig4i left Monica
subplot(2, 2, 3);
cellfun(@(x, y, z) NoveltySU.plot.multiPlot(gca, x, y, z, ".", 1, 20), Fig4.i.neuLag.Monica(2:end), Fig4.i.pushLag.Monica(2:end), Fig4.colors, "UniformOutput", false);
plot(Fig4.lagWin, Fig4.lagWin, "k--");
xlim([260, 460]); ylim([260, 460]);

% Fig4i right Monica
subplot(2, 2, 4);
cellfun(@(x, y, z) NoveltySU.plot.multiPlot(gca, x, y, z, ".", 1, 20), Fig4.i.neuLag.CM(2:end), Fig4.i.pushLag.CM(2:end), Fig4.colors, "UniformOutput", false);
plot(Fig4.lagWin, Fig4.lagWin, "k--");
xlim([260, 460]); ylim([260, 460]);