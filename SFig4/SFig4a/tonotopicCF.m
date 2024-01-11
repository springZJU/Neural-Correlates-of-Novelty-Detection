clear
dataBelong = 'spr';
if dataBelong == "spr"
    cellXlsx.Path = 'cells.xlsx';
    cellXlsx.Data = table2cell(readtable(cellXlsx.Path));
    cellXlsx.cfInf = cell2mat(cellXlsx.Data([cellXlsx.Data{:,1}]>0,[1 3 9 10]));
    cellXlsx.cfInf = sortrows(cellXlsx.cfInf,[3 4]); %sort
    [nullRow nullCol] = find(isnan(cellXlsx.cfInf)); % find null element
    cellXlsx.cfInf(nullRow,:) = [];
    cellXlsx.cfInf(cellXlsx.cfInf(:,2)<0,2) = 1;
    for rowN = 1:size(cellXlsx.cfInf,1)-1
        if cellXlsx.cfInf(rowN,4) == cellXlsx.cfInf(rowN+1,4)
            cellXlsx.cfInf(rowN+1,2) = cellXlsx.cfInf(rowN,2);
        end
        cfArray(cellXlsx.cfInf(rowN,3),cellXlsx.cfInf(rowN,4)) = cellXlsx.cfInf(rowN,2);
    end
elseif dataBelong == "gym"
    load('cf.mat');
    cfArray = aa;
    cfArray(:,1) = [];
    cfArray(1,:) = [];
end

cfTopo = cfArray;
cfTopo(:,1) = 1:size(cfTopo,1);
cfTopo(1,:) = 1:size(cfTopo,2);
rowNull = find(sum(cfTopo(2:end,2:end),2)==0)+1;
colNull = find(sum(cfTopo(2:end,2:end),1)==0)+1;
cfTopo(rowNull,:) = [];
cfTopo(:,colNull) = [];




intCfArray = interp2(cfArray,4);
%%
FRAPath = 'data.mat';
load(FRAPath);
cfTone = unique(data.epocs.vair.data);
cfScale = [min(cfTone) max(cfTone)];
cfArray(cfArray == 0) = nan;
intCfArray(intCfArray == 0) = nan;

%%
figure
subplot 221
splitBlock = 100;
filterSize = 90;
[m,n] = size(cfArray);
res = zeros(m*splitBlock,n*splitBlock);
for row = 1:m
    for col = 1:n
        res((row-1)*splitBlock+1:row*splitBlock,(col-1)*splitBlock+1:col*splitBlock) = cfArray(row,col);
    end
end
[resM resN] = size(res);
filterRes = zeros(resM+2*filterSize,resN+2*filterSize)*nan;
filterRes(filterSize+1:filterSize+resM,filterSize+1:filterSize+resN) = res;
filterRes(isnan(filterRes)) = 0.1;

%     k = 1/(filterSize*filterSize)*ones(filterSize);
%     fff = conv2(filterRes,k,'same');
fff = imgaussfilt(filterRes,100,'FilterSize',201);
cfImage = fff;
cfImage = log10(cfImage);
cfScale = abs(log10(cfScale));
% validSpace = ~isnan(cfImage);
validSpace = cfImage>0;
[rowNum colNum] = find(validSpace);
% cfImage(isnan(cfImage)) = -max(max(cfImage));
h = imagesc(cfImage,cfScale);
set(h,'alphadata',cfImage>cfScale(1));
xlim([min(colNum)-1 max(colNum)+1]);
ylim([min(rowNum)-1 max(rowNum)+1]);
cBar=colorbar;
colormap('jet');
cBar.TickLabels = strcat(num2str(floor(10.^cBar.Ticks')));


subplot 222
cfImage = cfArray;
cfImage = abs(log10(cfImage));
validSpace = ~isnan(cfImage);
[rowNum colNum] = find(validSpace);
h = imagesc(cfImage,cfScale);
% set(h,'alphadata',~isnan(cfImage));
xlim([min(colNum)-1 max(colNum)+1]);
ylim([min(rowNum)-1 max(rowNum)+1]);
cBar2=colorbar;
cBar2.TickLabels = strcat(num2str(floor(10.^cBar2.Ticks')));
c = colormap(gca, "jet"); c(1, :) = 1;  colormap(gca, c);

subplot 223
[yVal, xVal] = find(cfArray > 1);
cfVal = abs(log10(cellfun(@(x, y) cfArray(x, y), num2cell(yVal), num2cell(xVal))));
valArray = [xVal, yVal, cfVal];
figure
if dataBelong == "spr"
scatter(xVal*1.2, yVal/2, 100, cfVal, "filled");
scaleAxes("y", [10, 40]);
scaleAxes("x", [11, 26]);
set(gcf, "position", [128,495,946,420])
elseif dataBelong == "gym"
scatter(xVal*1.2, yVal/2, 100, cfVal, "filled");
scaleAxes("y", [-10, 20]);
set(gcf, "position", [128,495,946,420])
end
c = colormap(gca, "jet"); c(1, :) = 1;  colormap(gca, c);
scaleAxes("c", cfScale)
set(gca, 'yDir', 'reverse');


