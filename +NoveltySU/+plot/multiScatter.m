function multiScatter(Axes, x, y, sz, mkr, color, fill, displayName)
narginchk(3, 7);
if nargin < 4
sz = 10;
end

if nargin < 5
    mkr = "o";
end
if nargin < 7
    fill = [];
end
if nargin < 8
    displayName = "";
end
if isempty(fill)
scatter(Axes, x, y, sz, "color", color, mkr, "DisplayName", displayName); hold on;
else
scatter(Axes, x, y, sz, "color", color, mkr, "filled", "DisplayName", displayName); hold on;
end
end