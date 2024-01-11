function [Fig, fr] = FR139_DiffTrials(trialAll, visible)
narginchk(1, 2);
if nargin < 2
    visible = "on";
end
%% raw
n = 1;
fr = NoveltySU.utils.FR139.testFR139(trialAll);
fr.selIdx = 1 :length(trialAll);
colors = ["k-", "b-", "r-"];
Fig = figure("Visible", visible);
maximizeFig(Fig);
subplot(3, 5, n)
for sIndex = 1 :3
    errorbar(1:5, fr(n).Mean_Late(sIndex, :), fr(n).SE_Late(sIndex, :), colors(sIndex)); hold on
end
title(['all trials 1- ', num2str(length(trialAll))]);


%% cut according to behavior
consectN = 4;
n = 2;
trialAll_Dev = trialAll([trialAll.oddballType]' == "DEV");
temp = find([trialAll_Dev.correct]' == 0);
[firstIdx, lastIdx, allIdx]= mConsecutive(temp, consectN);
badIdx = temp(allIdx);
firstPos = max([badIdx(find(badIdx < 40, 1, "last"))+consectN, 1]); 
lastPos = min([badIdx(find(badIdx > 170, 1, "first"))-1, length(trialAll)]); 
trialAll_Sel = trialAll(firstPos:lastPos);
frTemp = NoveltySU.utils.FR139.testFR139(trialAll_Sel);
frTemp.selIdx = firstPos : lastPos;
fr = [fr; frTemp];
colors = ["k-", "b-", "r-"];

subplot(3, 5, n)
for sIndex = 1 :3
    errorbar(1:5, fr(n).Mean_Late(sIndex, :), fr(n).SE_Late(sIndex, :), colors(sIndex)); hold on
end

title(['behav', num2str(firstPos), ' - ', num2str(lastPos)]);

%% compute firing rate in different trials

if diff([firstPos, lastPos]) >= 180
    lastTemp = firstPos+180;
while lastTemp <= lastPos
    n=n+1;
trialAll_Sel = trialAll(firstPos : lastTemp);  
frTemp = NoveltySU.utils.FR139.testFR139(trialAll_Sel);
frTemp.selIdx = firstPos : lastTemp;
fr = [fr; frTemp];
subplot(3, 5, n)
for sIndex = 1 :3
    errorbar(1:5, fr(n).Mean_Late(sIndex, :), fr(n).SE_Late(sIndex, :), colors(sIndex)); hold on
end
title(['trial', num2str(firstPos), ' - ', num2str(lastTemp)]);
lastTemp = lastTemp + 20;
end

end
