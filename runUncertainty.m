function runUncertainty
% writes all files for raw data in directory.
% ** does not include Toolik **
% ** does not support JFM **

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
    if ~iscell(lakeNm) % lakeNm can be cell of 1 or more lakes 
        lakeT = cell(1,length(dates));
        for j = 1:length(dates)
            lakeT{j} = lakeNm;
        end
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
        numPlt = false(length(years),1);
        for j = 1:length(years)
            useI = ge(datesZ,datenum(years(j),mmS(1),1)) & ...
                lt(datesZ,datenum(years(j),mmS(3)+1,1));
            if ge(sum(useI),minValsUncy)
                numPlt(j) = true;
            end
        end
        if any(numPlt);
            clrs = distinguishable_colors(sum(numPlt));
            close all
            [~,~,titl] = createUncyFigure(...
                unLakes{lk},['n=' num2str(sum(numPlt)) ' years']);
            clrCnt = 1;
            for j = 1:length(years)
                if numPlt(j)
                    useI = ge(datesZ,datenum(years(j),1,1)) & ...
                        le(datesZ,datenum(years(j)+1,0,0));
                    plotUncy(datesZ(useI),wtrZ(useI),mmS,fitParams,R2,clrs(clrCnt,:));
                    clrCnt = clrCnt+1;
                    pause(0.1);
                end
            end
            xL = get(gca,'XLim');
            set(gca,'XLim',[endValsUncy xL(2)+1]);
            xL = get(gca,'XLim');
            plot(xL,[0 0],'k--','LineWidth',.75)
            plotTitle = regexprep(titl,' ','_');
            plotTitle = regexprep(plotTitle,'=','-');
            disp(['exporting ' plotTitle ' Uncertainty figure']);
            export_fig([plotDir plotTitle '_Uncertainty'],figType,figRes,'-nocrop')
        end
    end
end
end

