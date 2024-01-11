function resStruct = addFieldToStruct(struct,fieldVal,fieldName)
% Example: struct = addFieldToStruct(struct, [a, b], ["a", "b"]);

if ~iscell(fieldName)
    fieldName = cellstr(fieldName);
end
%% get length of struct and field names
structLength = length(struct);
oldFields = string(fields(struct));
fieldName = string(fieldName);
fieldName = reshape(fieldName, [], 1);
%% convert struct to cell
if length(struct) > 1
    oldCell = table2cell(struct2table(struct));
else
    oldCell = struct2cell(struct);
end

%% check if oldCell is column director, otherwise ,invert
[m, n] = size(oldCell);
if n == structLength
    oldCell = oldCell';
end

if ~isCellByCol(oldCell)
    oldCell = oldCell';
end
%% check if new cell to add is the same length with structure
[mm, nn] = size(fieldVal);
if mm ~= structLength
    error('the length of new cell is not suitable with the structrue');
end

%% merge old and new cells and creat new sutruct
resCell = [oldCell fieldVal];
resField = [oldFields; fieldName];
resStruct = easyStruct(resField,resCell);
end
