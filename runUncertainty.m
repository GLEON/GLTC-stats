function runUncertainty
% writes all files for raw data in directory.
% ** does not include Toolik **

defaultsGLTC

%% file finder
availfiles = dir(fullfile(rootDir));
numFiles = length(availfiles);
rmvFile = false(numFiles,1);
for k = 1:numFiles
    if availfiles(k).isdir
        rmvFile(k) = true;  % remove directories from this structure
    else
        disp(availfiles(k).name);
    end
end
availfiles = availfiles(~rmvFile);      % now only files
%% loop through files, read out, parse and write stats
numFiles = length(availfiles);
for k = 1:numFiles
    fileName = availfiles(k).name;
    disp('******-------********');
    disp(['working on ' fileName]);
    [dates, wtr, z, lakeNm] = loadLakes( fileName );
    lakeT = {''};
    if ~iscell(lakeNm) % lakeNm can be cell of 1 or more lakes 
        lakeT{1} = lakeNm;
        lakeNm = lakeT;
    end
    unLakes = unique(lakeNm);
    for lk = 1:length(unLakes);
        useI = strcmp(unLakes{lk},lakeNm);
        datesT = dates(useI);
        wtrT   = wtr(useI);
        zT     = z(useI);
        zBest = getBestDepth(datesT,zT);    % only use best
        useI = eq(zBest,zT);
        datesZ = datesT(useI);
        wtrZ   = wtrT(useI);
        [ fitParams, R2 ] = fitDayNum( datesZ, wtrZ, fitRange,timeRange);
        [ years ] = ... % get number of years once
            getStats( datesZ, wtrZ, mmS, fitParams, R2);
        % each year
    end
end
end

