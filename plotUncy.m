function plotUncy(dates,wtr,mmS,fitParams,R2,clr)

% plots uncertainty descending with subsampling
defaultsGLTC;
YYYY = datevec(min(dates));
YYYY = YYYY(1);
% [~,meVal] = getStats( dates, wtr, mmS, fitParams, R2); % initial value

useI = ge(dates,datenum(YYYY,mmS(1),1)) & ...
    lt(dates,datenum(YYYY,mmS(3)+1,1));
lW = 1.5;
initNum = sum(useI);

rngL = (100-confInt)/2;
%% now start removing values and refitting...

indx = 1:length(dates);
indx = indx(useI); % only indices of values that fall within JAS
uncy = NaN(initNum-endValsUncy,1);
xVal = uncy;
for bs = 1:initNum-endValsUncy
    xVal(bs) = initNum-bs;
    
    yVal = NaN(1,numIter);
    
    for n = 1:numIter
        tempI = true(length(dates),1);
        % remove bs# of samples from JAS window
        rPerm = randperm(length(indx));
        rmvI = rPerm(1:bs);
        tempI(rmvI+indx(1)-1) = false;
        [~,yVal(n)] = getStats( dates(tempI), wtr(tempI), mmS, fitParams, R2);
    end
    range = prctile(yVal,[rngL 100-rngL]);
    uncy(bs) = (range(2)-range(1))*0.5;
    
end
plot([initNum; xVal],[0; uncy],'b-','Color',clr,'LineWidth',lW);  

end

