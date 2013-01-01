function runUncertainty

% writes all files for raw data in directory.
% ** does not include Toolik **

defaultsGLTC


%% file finder

availfiles = dir(fullfile(rootDir));
% remove directories from this structure
numFiles = length(availfiles);
rmvFile = false(numFiles,1);
for k = 1:numFiles
    if availfiles(k).isdir
        rmvFile(k) = true;
    else
        disp(availfiles(k).name);
    end
end

availfiles = availfiles(~rmvFile);      % now only files

%% loop through files, read out, parse and write stats

numFiles = length(availfiles);
[fileN] = startLog;
for k = 1:numFiles
    fileName = availfiles(k).name;
    disp('******-------********');
    disp(['working on ' fileName]);
    [dates, wtr, z, lakeNm] = loadLakes( fileName );
    % lakeNm can be cell of multiple lakes, single lake, or single string
    if iscell(lakeNm)
        % how many lakes?
        unLakes = unique(lakeNm);
        for lk = 1:length(unLakes);
            useI = strcmp(unLakes{lk},lakeNm);
            datesT = dates(useI);
            wtrT   = wtr(useI);
            zT     = z(useI);
            % find depth with most years, tiebreaker: shallowest depth
            zBest = getBestDepth(datesT,zT);
            
            useI = eq(zBest,zT);
            datesZ = datesT(useI);
            wtrZ   = wtrT(useI);
            [ fitParams, R2 ] = fitDayNum( datesZ, wtrZ, fitRange,timeRange);
            [ years, meVal, mxGap, meGap, nmGap, logMessage ] = ...
                getStats( datesZ, wtrZ, mmS, fitParams, R2);

                plotSummaryFig(fitParams,R2,years,meVal,logMessage,...
                    datesZ,wtrZ,unLakes{lk},zBest); pause(0.5);

        end
    else
        zBest = getBestDepth(dates,z);
        useI = eq(zBest,zT);
        datesZ = dates(useI);
        wtrZ   = wtr(useI);
        % find depth with most years, tiebreaker: shallowest depth
        
        [ fitParams, R2 ] = fitDayNum( datesZ, wtrZ, fitRange,timeRange);
        [ years, meVal, mxGap, meGap, nmGap, logMessage ] = ...
            getStats( datesZ, wtrZ, mmS, fitParams, R2);
        plotSummaryFig(fitParams,R2,years,meVal,logMessage,...
            datesZ,wtrZ,lakeNm,zBest); pause(0.5);
        
    end
    
end
closeLog(fileN)
end

