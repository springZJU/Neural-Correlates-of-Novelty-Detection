% function SplitThenSmooth(data,splitBlock,filterSize)
data = cfArray;
    [m,n] = size(data);
    res = zeros(m*splitBlock,n*splitBlock);
    for row = 1:m
        for col = 1:n
            res((row-1)*splitBlock+1:row*splitBlock,(col-1)*splitBlock+1:col*splitBlock) = data(row,col);
        end
    end
    [resM resN] = size(res);
    filterRes = zeros(resM+2*filterSize,resN+2*filterSize)*nan;
    filterRes(filterSize+1:filterSize+resM,filterSize+1:filterSize+resN) = res;
    filterRes(isnan(filterRes)) = 0.1;

    k = 1/(80*80)*ones(80);
    
    fff = conv2(filterRes,k,'same');

    cfImage = fff;
 cfImage = log10(cfImage);
% validSpace = ~isnan(cfImage);
validSpace = cfImage>0;
[rowNum colNum] = find(validSpace);
% cfImage(isnan(cfImage)) = -max(max(cfImage));
h = imagesc(cfImage,cfScale);
set(h,'alphadata',cfImage>cfScale(1));
xlim([min(colNum)-1 max(colNum)+1]);
ylim([min(rowNum)-1 max(rowNum)+1]);
cBar2=colorbar;
cBar2.TickLabels = strcat(num2str(floor(10.^cBar2.Ticks')));