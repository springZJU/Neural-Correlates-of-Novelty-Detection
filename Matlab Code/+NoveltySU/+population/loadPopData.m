function res = loadPopData(DATAPATH)
load(DATAPATH);
temp = strsplit(DATAPATH, "\");
Date = char(temp(end-1));
clear DATAPATH temp
vars = whos;
varNames = string({vars.name})';
res.Date = Date;
for vIndex = 1 : length(varNames)
    eval(strcat("res.", varNames(vIndex), " = ", varNames(vIndex), ";"));
end
end