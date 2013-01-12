timeRange = 'JAS';
plotSumm  = true;           % plot summary figure?

if strcmp(timeRange,'JAS')
    mmS = [7 8 9];
    toolMmS = [6 7 8];
    fitRange = [153 305];       % June 1 to Oct 31st
    toolFitRange = [122 274];   % May 1 to Sept 30th
elseif strcmp(timeRange,'JFM')
    mmS = [1 2 3];
    toolMmS = [1 2 3];
    fitRange = [-30 121];       % Dec 1 to April 30th
    toolFitRange = [-30 121];   % Dec 1 to April 30th
end

numIter = 1000;              % number of iterations for subsampling
minValsUncy = 20;           % minimum number of values (any JAS) to run uncy
endValsUncy = 3;            % bootstrapping cutoff
mxTemp = 45;                % degrees C, for outlier removal
mnTemp = -5;
confInt= 95;
spans  = [7 14 21 30];                 % LOWESS fit spans

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