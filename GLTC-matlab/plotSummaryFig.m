function plotSummaryFig(fitParams,R2,years,meVal,logMessage,dates,wtr,lkNm,z)

close all
defaultsGLTC
if strcmp(lkNm,'Toolik')
    fitRange = toolFitRange;
    timeRange = 'JJA';
end
titl = regexprep(lkNm,'_',' ');

titl = [titl ' z=' num2str(z)];
%% build figure
lM  = 0.75;
rM  = 0.25;
tM  = 0.5;
bM  = 0.5;
hSpc= 0.75;
W   = figW-lM-rM;
H   = (figH-tM-bM)/2-hSpc/2;
axLW= 1.25;
if strcmp(timeRange,'JAS') || strcmp(timeRange,'JJA')
    xL_t= [0 365];
else
    xL_t= [-30 335];
end

mS  = 3;

yTxt = 0.03;
yBmp = 0.1;
xTxt = 0.015;


fig_h = figure('Color','w','units','inches','Position',[0 0 figW figH]);
movegui(fig_h,'center');

ax_b  = axes('Parent',fig_h,'Position',[lM/figW bM/figH W/figW H/figH],...
    'FontSize',fontS,'FontName',fontN,'box','on','LineWidth',axLW,...
    'TickDir','out');
hold on;
ylabel('Temperature (°C)','FontSize',fontS,'FontName',fontN);

ax_t  = copyobj(ax_b,fig_h);
set(ax_t,'Position',[lM/figW (bM+hSpc+H)/figH W/figW H/figH],...
    'XLim',xL_t);
hold on;
xlabel('Day Number','Parent',ax_t)
xlabel('Year','Parent',ax_b)

%% fit calculations and plotting
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
plot(dStrip,wtr,'k.','Parent',ax_t);
inDts = fitRange(1):fitRange(2);
fitNum = sum(gt(dStrip,fitRange(1)) & lt(dStrip,fitRange(2)));
[vals] = getValsFromFit(inDts,fitParams);
hold on
plot(inDts,vals,'k-','LineWidth',2.5,'Parent',ax_t);

title(titl,'Parent',ax_t);

% add garnish for legends
yL_t = get(ax_t,'YLim');
yDist= yL_t(2)-yL_t(1);
yLoc = yL_t(2)-yTxt*yDist;
yJmp = yDist*yBmp;
xL_t = get(ax_t,'XLim');
xDist= xL_t(2)-xL_t(1);
xLoc = xL_t(1)+xTxt*xDist;
txt1 = ['R^{2}=' num2str(R2)];
txt2 = ['n=' num2str(fitNum) ' (for fit)'];
txt3 = ['n=' num2str(length(dates)) ' (for all)'];
text(xLoc,yLoc,txt1,'Parent',ax_t,'HorizontalAlignment','left',...
    'VerticalAlignment','top');
text(xLoc,yLoc-yJmp,txt2,'Parent',ax_t,'HorizontalAlignment','left',...
    'VerticalAlignment','top');
text(xLoc,yLoc-yJmp*2,txt3,'Parent',ax_t,'HorizontalAlignment','left',...
    'VerticalAlignment','top');

%% trend plotting
plot(years,meVal,'ko','Parent',ax_b,'MarkerSize',mS,...
    'MarkerFaceColor','k');
mdlCnt = 0;
for j = 1:length(years)
    if ~isempty(logMessage{j})
        plot(years(j),meVal(j),'ro','LineWidth',1.5,'Parent',ax_b,...
            'MarkerFaceColor','w','MarkerSize',mS+2);
        mdlCnt = mdlCnt+1;
    end
end
% add garnish for legends
yL_t = get(ax_b,'YLim');
yDist= yL_t(2)-yL_t(1);
yLoc = yL_t(2)-yTxt*yDist;
yJmp = yDist*yBmp;
xL_t = get(ax_b,'XLim');
xDist= xL_t(2)-xL_t(1);
xLoc = xL_t(1)+xTxt*xDist;
txt1 = ['n=' num2str(length(meVal(~isnan(meVal)))) ' (for all)'];
txt2 = ['n=' num2str(mdlCnt) ' (modeled; {\bf{\color{red}o}})'];
text(xLoc,yLoc,txt1,'Parent',ax_b,'HorizontalAlignment','left',...
    'VerticalAlignment','top');
text(xLoc,yLoc-yJmp,txt2,'Parent',ax_b,'HorizontalAlignment','left',...
    'VerticalAlignment','top');

plotTitle = regexprep(titl,' ','_');
plotTitle = regexprep(plotTitle,'=','-');
export_fig([plotDir plotTitle '_' timeRange],figType,figRes,'-nocrop')

end
