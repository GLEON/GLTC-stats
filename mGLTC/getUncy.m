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
initNum = sum(useI);

%% now start removing values and refitting...

indx = 1:length(dates);
indx = indx(useI); % only indices of values that fall within JAS
xVal = NaN(initNum-endValsUncy,1);
numNs = length(1:initNum-endValsUncy);
uncy = NaN(numNs,numIter,length(spans)+1);
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
        [~,uncy(bs,n,1)] = getStats( dates(tempI), wtr(tempI), mmS, fitParams, R2);
        for i = 1:length(spans)
            [~,uncy(bs,n,i+1)] = getStatsLowess( dates(tempI), wtr(tempI), mmS,...
                fitParams, R2, spans(i));
        end
    end
end
normVals = uncy-meVal;
end

