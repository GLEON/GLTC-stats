function [ years, meVal, mxGap, meGap, nmGap logMessage ] = ...
    getStats( dates, wtr, mmS, fitParams, R2)
% returns stats as according to John Lenters' GLTC calculation methods
% 2012-10-20 added ability to calculate without two adjacent months


% sort dates;
[dates,srtI] = sort(dates);
wtr = wtr(srtI);
dVec  = datevec(dates);
yyyy  = dVec(:,1);
mm    = dVec(:,2);

years = sort(unique(yyyy));
numY  = length(years);

meVal = NaN(numY,1);
mxGap = NaN(numY,1);
meGap = NaN(numY,1);
nmGap = NaN(numY,1);

logMessage = cell(numY,1);

for j = 1:numY
    if eq(mmS(1),1)
        d1 = datenum(years(j)-1,12,1);
        eqTng = [12 1 2 3 4];
    else
        d1 = datenum(years(j),mmS(1)-1,1);
        eqTng = [mmS(1)-1 mmS(1) mmS(2) mmS(3) mmS(3)+1];
    end
    d2 = datenum(years(j),mmS(3)+2,0);
    useI = ge(dates,d1) & le(dates,d2);

    dateT= dates(useI);
    mmT  = mm(useI);
    wtrT = wtr(useI);
    % remove NaNs from wtrT
    nanI = isnan(wtrT);
    wtrT = wtrT(~nanI);
    mmT  = mmT(~nanI);
    dateT= dateT(~nanI);
    unDt = unique(dateT);
    % ** average duplicates **
    if ne(length(unDt),length(dateT))
        wtrAve = NaN(length(unDt),1);
        mmAve  = NaN(length(unDt),1);
        for w = 1:length(unDt)
            mnI = eq(unDt(w),dateT);
            wtrAve(w) = mean(wtrT(mnI));
            mmAve(w)  = mean(mmT(mnI));
        end
        wtrT = wtrAve;
        mmT  = mmAve;
        dateT= unDt;
    end
    % strip year off dates for fit (if needed)
    dVec = datevec(dateT);
    dStrip = datenum([zeros(length(dateT),1) dVec(:,2:end)]);
    % do we have data for the months around the mean months? AND all months
    % for calculating stats?
    calc = true;
    intDays = datenum(years(j),mmS(1),1):datenum(years(j),mmS(3)+1,0);
    dVec = datevec(intDays);
    iStrip = datenum([zeros(length(intDays),1) dVec(:,2:end)]); % valid for JFM
    if all([any(eq(mmT,eqTng(1))) any(eq(mmT,eqTng(2))) any(eq(mmT,eqTng(3))) ...
            any(eq(mmT,eqTng(4))) any(eq(mmT,eqTng(5)))])
        
        % first 4
    elseif all([any(eq(mmT,eqTng(1))) any(eq(mmT,eqTng(2))) any(eq(mmT,eqTng(3))) ...
            any(eq(mmT,eqTng(4)))])
        logMessage{j} = ['only ' datestr(datenum(0,eqTng(1:4),1),'m')' ...
            ' used (beyond ' datestr(dateT(end),'yyyy-mmm-dd') ...
            ' fit to (' sprintf('%0.4f',fitParams.a) ')*dayNum^2+(' ...
            sprintf('%0.4f',fitParams.b) ')*dayNum'  '+c; '...
            'R2=' sprintf('%0.4f',R2) ')'];
        pivotPt = [dStrip(end) wtrT(end)];
        intDts  = dStrip(end)+1:iStrip(end);
        addDts  = dateT(end)+1:intDays(end);
        [wtrAdd] = getValsFromFit(intDts,fitParams,pivotPt);
        wtrT  = [wtrT; wtrAdd];
        dateT = [dateT; addDts'];
       
        % last 4
    elseif all([any(eq(mmT,eqTng(2))) any(eq(mmT,eqTng(3))) ...
            any(eq(mmT,eqTng(4))) any(eq(mmT,eqTng(5)))])
        logMessage{j} = ['only ' datestr(datenum(0,eqTng(2:5),1),'m')' ...
            ' used (before ' datestr(dateT(1),'yyyy-mmm-dd') ...
            ' fit to (' sprintf('%0.4f',fitParams.a) ')*dayNum^2+(' ...
            sprintf('%0.4f',fitParams.b) ')*dayNum'  '+c; '...
            'R2=' sprintf('%0.4f',R2) ')'];
        pivotPt = [dStrip(1) wtrT(1)];
        intDts  = iStrip(1):dStrip(1)-1;
        addDts  = intDays(1):dateT-1;
        [wtrAdd] = getValsFromFit(intDts,fitParams,pivotPt);
        wtrT  = [wtrAdd; wtrT];
        dateT = [addDts'; dateT];
        % middle 3
    elseif all([any(eq(mmT,eqTng(2))) any(eq(mmT,eqTng(3))) ...
            any(eq(mmT,eqTng(4)))])
        logMessage{j} = ['only ' datestr(datenum(0,eqTng(2:4),1),'m')' ...
            ' used (before ' datestr(dateT(1),'yyyy-mmm-dd') ...
            ' and beyond ' datestr(dateT(end),'yyyy-mmm-dd') ...
            ' fit to (' sprintf('%0.4f',fitParams.a) ')*dayNum^2+(' ...
            sprintf('%0.4f',fitParams.b) ')*dayNum'  '+c; '...
            'R2=' sprintf('%0.4f',R2) ')'];
        pivotPt = [dStrip(1) wtrT(1)];
        intDts  = iStrip(1):dStrip(1)-1;
        addDts  = intDays(1):dateT-1;
        [wtrAdd] = getValsFromFit(intDts,fitParams,pivotPt);
        wtrT  = [wtrAdd; wtrT];
        dateT = [addDts'; dateT];
        pivotPt = [dStrip(end) wtrT(end)];
        intDts  = dStrip(end)+1:iStrip(end);
        addDts  = dateT(end)+1:intDays(end);
        [wtrAdd] = getValsFromFit(intDts,fitParams,pivotPt);
        wtrT  = [wtrT; wtrAdd];
        dateT = [dateT; addDts'];
    else
        calc = false;
    end
    if calc
        if gt(length(wtrT),2)
            disp(logMessage{j})
            [dateT,unI] = unique(dateT);
            wtrT = wtrT(unI);
            meVal(j)= mean(interp1(dateT,wtrT,intDays));
            gpDates = dates(ge(dates,datenum(years(j),mmS(1),1)) & ...
                le(dates,datenum(years(j),mmS(3)+1,0)));
            gaps    = gpDates(2:end)-gpDates(1:end-1);
            mxGap(j)= max(gaps);
            meGap(j)= mean(gaps);
            nmGap(j)= length(gaps);
        end
    end
    
end
