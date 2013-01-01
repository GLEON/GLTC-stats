function [fig_h,ax_h] = createUncyFigure(lkNm)

titl = regexprep(lkNm,'_',' ');
defaultsGLTC

%% build figure
lM  = 0.75;
rM  = 0.25;
tM  = 0.5;
bM  = 0.5;
W   = figW-lM-rM;
H   = figH-tM-bM;
axLW= 1.25;


fig_h = figure('Color','w','units','inches','Position',[0 0 figW figH]);
movegui(fig_h,'center');

ax_h  = axes('Parent',fig_h,'Position',[lM/figW bM/figH W/figW H/figH],...
    'FontSize',fontS,'FontName',fontN,'box','on','LineWidth',axLW,...
    'TickDir','out');
hold on;

ylabel('Uncertainty relative to best estimate (±°C)','Parent',ax_h,...
    'FontSize',fontS,'FontName',fontN)
xlabel('Number of samples (per JAS)','Parent',ax_h,...
    'FontSize',fontS,'FontName',fontN)
title(titl,'Parent',ax_h);

end

