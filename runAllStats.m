function writeAllStats_GLTC( timeRange )

% writes all files for raw data in directory.

rootFolder = 'Raw Data\';
if eq(nargin,0)
    timeRange = 'JAS';
    fitRange = [183 274]; %July 1 to Sept 30th
end



if strcmp(timeRange,'JAS')
    mmS = [7 8 9];
elseif strcmp(timeRange,'JFM')
    mmS = [1 2 3];
end


%% file finder

availfiles = dir(fullfile(rootFolder));
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
[fileN] = startLog_GLTC;
for k = 1:numFiles
    fileName = availfiles(k).name;
    disp('******-------********');
    disp(['working on ' fileName]);
    [dates, wtr, z, lakeNm] = loadLakes_GLTC( fileName );
    % lakeNm can be cell of multiple lakes, single lake, or single string
    if iscell(lakeNm)
        % how many lakes?
        unLakes = unique(lakeNm);
        for lk = 1:length(unLakes);
            useI = strcmp(unLakes{lk},lakeNm);
            datesT = dates(useI);
            wtrT   = wtr(useI);
            zT     = z(useI);
            unZ    = unique(z);
            for zU = 1:length(unZ)
                useI = eq(unZ(zU),zT);
                datesZ = datesT(useI);
                wtrZ   = wtrT(useI);
                [ fitParams, R2 ] = fitDayNum_GLTC( datesZ, wtrZ, fitRange);
                [ years, meVal, mxGap, meGap, nmGap, logMessage ] = ...
                    getStats_GLTC( datesZ, wtrZ, mmS, fitParams, R2);
                appendLog_GLTC(fileN, [unLakes{lk} '_z=' num2str(unZ(zU))], logMessage, years)
                disp(['writing ' unLakes{lk} ' at z=' num2str(unZ(zU))])
                writeStats_GLTC(years,meVal,mxGap,meGap,nmGap,unLakes{lk},unZ(zU),timeRange);
            end
        end
    else
        unZ    = unique(z);
        for zU = 1:length(unZ)
            useI = eq(unZ(zU),z);
            datesZ = dates(useI);
            wtrZ   = wtr(useI);
            if strcmp(lakeNm,'Toolik')
                [ fitParams, R2 ] = fitDayNum_GLTC( datesZ, wtrZ, fitRange);
                [ years, meVal, mxGap, meGap, nmGap, logMessage ] = ...
                        getStats_GLTC( datesZ, wtrZ, [6 7 8], fitParams, R2);
                disp('');
                appendLog_GLTC(fileN, [lakeNm  '_z=' num2str(unZ(zU))], logMessage, years)
                disp(['writing ' lakeNm ' at z=' num2str(unZ(zU)) ' for JJA'])
                writeStats_GLTC(years,meVal,mxGap,meGap,nmGap,lakeNm,unZ(zU),'JJA');
                
            else
                [ fitParams, R2 ] = fitDayNum_GLTC( datesZ, wtrZ, fitRange);
                [ years, meVal, mxGap, meGap, nmGap, logMessage ] = ...
                    getStats_GLTC( datesZ, wtrZ, mmS, fitParams, R2); 
                disp('');
                appendLog_GLTC(fileN, [lakeNm  '_z=' num2str(unZ(zU))], logMessage, years)
                disp(['writing ' lakeNm ' at z=' num2str(unZ(zU))])
                writeStats_GLTC(years,meVal,mxGap,meGap,nmGap,lakeNm,unZ(zU),timeRange);
             end
        end
    end
    
end
closeLog_GLTC(fileN)
end

