function [colorOutput, colorGrad] = generateColorGrad(n,method,varargin)
% if only one input n and method, the colorOutput will include all color types, for
% each color type, the color gradation if continuous.
% for example: res = generateColorGrad(16).
% method: 'rgb' or 'hex'

% you can give more input, varargin can be 'blue','red', etc, followed by index,
% for example: generateColorGrad(16,'orange',[1:5]),
% the 1 to 5 of colorOutput will be orange gradation.
% Be careful, the length of num must less than 6

% For more info of color gradation, go to this website:
% https://blog.csdn.net/qq_38882446/article/details/100886087

% to test, run following code:
% res = generateColorGrad(16,'rgb');
% res2 = generateColorGrad(16,'rgb','blue',[1:6],'red',[7:10],'black',[11:16]);
% figure
% subplot(1,2,1)
% for i = 1:16
%     plot([1:10],i+[1:10],'color',res{i},'linestyle','-','linewidth',3); hold on
% end
% subplot(1,2,2)
% for i = 1:16
%     plot([1:10],i+[1:10],'color',res2{i},'linestyle','-','linewidth',3); hold on
% end
%% set color pool
redGrad = {'#FF0000','#FF69B4','#FF1493','#FFC0CB','#DB7093','#B03060'};
orangeGrad = {'#FFA500','#FF7F50','#FF6347','#A52A2A','#D2691E','#D2B48C'};
greenGrad = {'#00FF00','#32CD32','#9ACD32','#228B22','#006400','#556B2F'};
blueGrad = {'#0000FF','#1E90FF','#87CEEB','#4682B4','#6A5ACD','#40E0D0'};
blackGrad = {'#000000','#444444','#888888','#AAAAAA','#CCCCCC','#EEEEEE'};
brownGrad = {'#FFCC99', '#CC9966', '#CC9933', '#996633', '#663300', '#996600'};

colorBuffer = [redGrad; orangeGrad; greenGrad ;blueGrad; blackGrad; brownGrad];
if ~any(strcmp(method,{'rgb','hex'}))
    error('error method input! Please use ''rgb'' or ''hex''');
end

if strcmp(method,'rgb')
    % convert hex style to rgb style
    colorBuffer = cellfun(@(x) roundn([hex2dec(x(1:2)) hex2dec(x(3:4)) hex2dec(x(5:6))]/255, -2), cellfun(@(x) erase(x,'#'),colorBuffer,'UniformOutput',false),'UniformOutput',false);
end

colorGrad = easyStruct({'redGrad','orangeGrad','greenGrad','blueGrad','blackGrad', 'brownGrad'},colorBuffer');

[colorType colorNum] = size(colorBuffer);

%%
if mod(nargin,2) == 1
    error('the number of input is incorrect!');
elseif n > numel(colorBuffer)
    error(['the input exceeds color pool size!']);
elseif nargin < 3
    sz = size(colorBuffer);
    Idx = [];
    for N = 1:colorType
        Idx = [Idx N:colorType:n];
    end
    colorOutput = colorBuffer(Idx);
else
    calN = sum(cellfun(@length,varargin(2:2:length(varargin))));
    if n~= calN
        error(['the sum of color index do not equal to n!']);
    end
    for ii = 1:2:length(varargin)
        Idx = varargin{ii+1};
        if length(Idx) > length(colorGrad)
            error(['the index length of ' varargin{ii} ' exceeds color pool size!']);
        end
        colorOutput(Idx) = {colorGrad(1:length(Idx)).([varargin{ii} 'Grad'])};
    end
end



%% easyStruct
    function res = easyStruct(fieldName,fieldVal)
    evalstr=['res=struct('];
    %% if certain field is double defined, delete the old one
    deleteIdx= [];
    fieldN = unique(fieldName);
    if length(fieldN) ~= length(fieldName)
        for i = 1:length(fieldN)
            if sum(strcmp(fieldName,fieldN{i})) > 1
                idx = find(strcmp(fieldName,fieldN{i}));
                reserveIdx = max(find(strcmp(fieldName,fieldN{i})));
                deleteIdx = [deleteIdx ; idx(idx~=reserveIdx)]'
            end
        end
    end
    fieldName(deleteIdx) = [];
    fieldVal(:,deleteIdx) = [];

    for Paranum=1:length(fieldName)
        evalstr=[ evalstr '''' fieldName{Paranum} ''',' 'fieldVal(:,' num2str(Paranum) '),'];
    end
    evalstr(end)=[')'];
    evalstr=[evalstr ';'];
    eval(evalstr);
    end
end