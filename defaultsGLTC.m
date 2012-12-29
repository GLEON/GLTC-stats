timeRange = 'JAS';
plotSumm  = true;           % plot summary figure?

if strcmp(timeRange,'JAS')
    mmS = [7 8 9];
    toolMmS = [6 7 8];
    fitRange = [153 305];       % June 1 to Oct 31st
    toolFitRange = [153 245];   % June 1 to Sept 1st
elseif strcmp(timeRange,'JFM')
    mmS = [1 2 3];
    toolMmS = [1 2 3];
    fitRange = [-30 121];       % Dec 1 to April 30th
    toolFitRange = [-30 121];   % Dec 1 to April 30th
end

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