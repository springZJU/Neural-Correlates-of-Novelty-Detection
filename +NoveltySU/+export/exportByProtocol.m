clear;clc;
%% settings
monkeyNames = ["Monica", "CM"];
fd_lfp = 2000;
%%
for mkIndex = 1
    monkeyName = monkeyNames(mkIndex);

    ROOTPATH = getRootDirPath(mfilename("fullpath"), 5);
    if monkeyName == "Monica"
        DATAPATH = fullfile(ROOTPATH, "Data\OriginData\rawData\Monica\139");
    elseif monkeyName == "CM"
        DATAPATH = fullfile(ROOTPATH, "Data\OriginData\rawData\CM\intensity");
    end
    MATFILE = dir(DATAPATH);
    MATFILE([MATFILE.isdir]') = [];
    %%
    for mIndex = 1 : length(MATFILE)
        MATPATH = fullfile(MATFILE(mIndex).folder, MATFILE(mIndex).name);
        varName = whos("-file", MATPATH);
        load(MATPATH);
        eval(['cell = ', varName.name, ';']);
        eval(['clear ', varName.name]);
        fieldStr = string(fields(cell));
        fieldStr(matches(fieldStr, ["info", "behavior"])) = [];
        for fIndex = 1 : length(fieldStr)
            try
                behavType = fieldStr(fIndex);
                protName = NoveltySU.export.protNameTable(behavType, MATPATH);
                try
                    DATE = string(cell.info.date);
                    sitePos = string(cell.info.location);
                catch
                    DATE = strcat("Day", num2str(mIndex));
                    sitePos = strcat("Site", num2str(mIndex));
                end

                % save spike data

                data = rmfield(cell.(behavType).data, ["info", "snips", "scalars", "streams"]);

                if isfield(cell.(behavType), "dat")
                    data.sortdata = cell.(behavType).dat.spike;
                else
                    data.sortdata = cell.(behavType).data.snips.eNeu.ts;
                end
                SAVEPATH = strcat(ROOTPATH, "Data\OriginData\", protName, "\", strcat(monkeyName, "_", erase(DATE, "\"), "_", sitePos, erase(string(MATFILE(mIndex).name), ".mat")));
                %                 if ~exist(fullfile(SAVEPATH, "spkData.mat"), "file")
                mkdir(SAVEPATH);
                save(fullfile(SAVEPATH, "spkData.mat"), "data", "-v7.3");
                %                 end

                % save lfp data
                data = rmfield(cell.(behavType).data, ["info", "snips", "scalars"]);
                if ~isfield(data.streams.Llfp, "channels") && isfield(data.streams.Llfp, "channel")
                    data.streams.Llfp.channels = data.streams.Llfp.channel;
                end
                data.lfp = ECOGResample(data.streams.Llfp, fd_lfp);

                data = rmfield(data, "streams");
                %                 if ~exist(fullfile(SAVEPATH, "lfpData.mat"), "file")
                save(fullfile(SAVEPATH, "lfpData.mat"), "data", "-v7.3");
%             end
            catch e
                disp(e.message);
            continue
        end
    end
end
end