function plotUncy(dates,wtr,mmS,fitParams,R2)

% plots uncertainty descending with subsampling
defaultsGLTC;
YYYY = datevec(min(dates));
YYYY = YYYY(1);
[~,meVal] = getStats( dates, wtr, mmS, fitParams, R2); % initial value

useI = ge(dates,datenum(YYYY,mmS(1),1)) & ...
    lt(dates,datenum(YYYY,mmS(3)+1,1));

initNum = sum(useI);

plot(initNum,meVal,'bo');

%% now start removing values and refitting...




end

