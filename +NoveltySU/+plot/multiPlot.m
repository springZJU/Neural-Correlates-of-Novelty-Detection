function multiPlot(Axes, x, y, color, lineStyle, lineWidth,  mkr, displayName)
narginchk(3, 8);
if nargin < 4
    color = "red";
end
if nargin < 5
    lineStyle = "-";
end
if nargin < 6
    lineWidth = 1;
end
if nargin < 7
    mkr = 20;
end
if nargin < 8
    displayName = "";
end
if matches(lineStyle, ["-", "--", ":", "-.", "none"])
    plot(Axes, x, y, "color", color, "LineStyle", lineStyle, "LineWidth", lineWidth, "MarkerSize", mkr, "DisplayName", displayName); hold on;
else
    plot(Axes, x, y, "color", color, "Marker", lineStyle, "LineWidth", lineWidth, "LineStyle", "none", "MarkerSize", mkr, "DisplayName", displayName); hold on;
end