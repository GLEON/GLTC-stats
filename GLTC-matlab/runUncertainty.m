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
            uncyVals = NaN(sum(numPlt),92-endValsUncy,numIter,length(spans)+1);
            close all
            cnt = 1;
            for j = 1:3% ***** length(years)
                if numPlt(j)
                    tic
                    useI = ge(datesZ,datenum(years(j),1,1)) & ...
                        le(datesZ,datenum(years(j)+1,0,0));
                    [normVals] = getUncy(datesZ(useI),wtrZ(useI),mmS,fitParams,R2);
                    fillI = size(normVals);
                    uncyVals(cnt,1:fillI,:,:) = normVals;
                    cnt= cnt+1;
                    toc
                end
            end
            [~,~,titl] = createUncyFigure(...
                unLakes{lk},['n=' num2str(sum(numPlt)) ' years']);
            prc = [100-(100-confInt)/2 (100-confInt)/2];
            clrs = distinguishable_colors(length(spans)+1);
            lwr  = NaN(length(92-endValsUncy),length(spans)+1);
            upr  = NaN(length(92-endValsUncy),length(spans)+1);
            for n = 1:92-endValsUncy
                for sp = 1:length(spans)+1
                    vals = uncyVals(:,n,:,sp);
                    vals = reshape(vals,sum(numPlt)*numIter,1);
                    vals = vals(~isnan(vals));
                    lwr(n,sp)  = prctile(vals,prc(1));
                    upr(n,sp)  = prctile(vals,prc(2));
                end
            end
            xPlz = 91:-1:3;
            legStr = cell(1,length(spans)+1);
            legStr{1} = 'linear';
            for sp = 1:length(spans)+1
                plot([xPlz wrev(xPlz)],[lwr(:,sp)' wrev(upr(:,sp))'],'k-','Color',clrs(sp,:),...
                    'LineWidth',1.5)
                if ne(sp,1)
                    legStr{sp} = ['lowess_{' num2str(spans(sp-1)),'}'];
                end
            end
            set(gca,'XLim',[endValsUncy 93]);
            xL = get(gca,'XLim');
            leg = legend(legStr);
            set(leg,'EdgeColor','w','Location','best')
            plot(xL,[0 0],'k--','LineWidth',.75)
            plotTitle = regexprep(titl,' ','_');
            plotTitle = regexprep(plotTitle,'=','-');
            disp(['exporting ' plotTitle ' Uncertainty figure']);
            export_fig([plotDir plotTitle '_lowess_Uncertainty_iter' num2str(numIter)],figType,figRes,'-nocrop')
        end
    end
end
end

