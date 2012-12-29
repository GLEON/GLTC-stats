function [ fitParams, R2 ] = fitDayNum( dates, wtr, fitRange,timeRange)

% strips year from date, fits curve to wtr temperature, returns fit
% parameters.

dates = reshape(dates,length(dates),1);
wtr   = reshape(wtr,length(wtr),1);

%% remove year from dates
dVec = datevec(dates);
dStrip = datenum([zeros(length(dates),1) dVec(:,2:end)]);

if strcmp(timeRange,'JFM')
    % convert December days to negatives of the previous year
    for j = 1:length(dStrip)
        if eq(dVec(j,2),12)
            dStrip(j) = datenum(dVec(j,:))-datenum(dVec(j,1)+1,0,0);
        end
    end
end

%% fit to curve
if gt(length(dates),0)
    useI = le(dStrip,fitRange(2)) & ge(dStrip,fitRange(1)) & ~isnan(wtr);
else
    useI = 0;
end

if gt(sum(useI),2)
    %% build the fit model
    s = fitoptions('Method','NonlinearLeastSquares',...
        'Lower',[-inf -inf -inf],...
        'Upper',[inf inf inf],...
        'Startpoint',[1 1 1],...
        'MaxFunEvals',1000,...
        'MaxIter',1000);
    
    f = fittype('a*x^2+b*x+c','coefficients',{'a','b','c'},'options',s);
    [fitParams,mod] = fit(dStrip(useI),wtr(useI),f);
    
    R2 = mod.rsquare;
else
    fitParams.a = 0;
    fitParams.b = 1;
    fitParams.c = 0;
    R2 = -999;
end
    
end

