function [normVals] = getUncy(dates,wtr,mmS,fitParams,R2)

% plots uncertainty descending with subsampling
defaultsGLTC;
YYYY = datevec(min(dates));
YYYY = YYYY(1);
strYr = num2str(YYYY);
disp(strYr);
[~,meVal] = getStats( dates, wtr, mmS, fitParams, R2); % initial value

useI = ge(dates,datenum(YYYY,mmS(1),1)) & ...
    lt(dates,datenum(YYYY,mmS(3)+1,1));
lW = 1.5;
initNum = sum(useI);

rngL = (100-confInt)/2;
%% now start removing values and refitting...

indx = 1:length(dates);
indx = indx(useI); % only indices of values that fall within JAS
uncy = NaN(initNum-endValsUncy,4);
xVal = NaN(initNum-endValsUncy,1);
for bs = 1:initNum-endValsUncy
    xVal(bs) = initNum-bs;
    
    yVal = NaN(1,numIter);
    yValL= NaN(length(spans),numIter);
    for n = 1:numIter
        tempI = true(length(dates),1);
        % remove bs# of samples from JAS window
        rPerm = randperm(length(indx));
        rmvI = rPerm(1:bs);
        tempI(rmvI+indx(1)-1) = false;
        [~,yVal(n)] = getStats( dates(tempI), wtr(tempI), mmS, fitParams, R2);
        for i = 1:length(spans)
            [~,yValL(i,n)] = getStatsLowess( dates(tempI), wtr(tempI), mmS,...
                fitParams, R2, spans(i));
        end
    end
    range = prctile(yVal,[rngL 100-rngL]);
    uncy(bs,1) = meVal-range(1);
    uncy(bs,2) = meVal-range(2);
    for i = 1:length(spans)
        range = prctile(yValL(i,:),[rngL 100-rngL]);
        uncy(bs,i*2+1) = meVal-range(1);
        uncy(bs,i*2+2) = meVal-range(2);
    end
end
normVals = uncy;
end

