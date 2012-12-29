timeRange = 'JAS';
plotSumm  = true;           % plot summary figure?
mmS = [7 8 9];
toolMmS = [6 7 8];
fitRange = [153 305];       % June 1 to Oct 31st
toolFitRange = [122 274];   % May 1 to Sept 30th

JFM_offset = 183;           % days offset for JFM calcs
mxTemp = 45;                % degrees C, for outlier removal

dateForm = 'yyyy-mm-dd HH:MM:SS';
figRes   = '-m1';
figType  = '-png';
figW     = 8;
figH     = 6;
fontS    = 11;
fontN    = 'Times New Roman';



rootDir = 'G:\GLTC\Raw Data\';
plotDir = 'G:\GLTC\Figures\';
resultsDir = 'G:\GLTC\Processed Data\';