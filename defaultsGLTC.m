fitRange = [153 305];       % June 1 to Oct 31st
toolFitRange = [122 274];   % May 1 to Sept 30th
timeRange = 'JAS';

if strcmp(timeRange,'JAS')
    mmS = [7 8 9];
    toolMmS = [6 7 8];
elseif strcmp(timeRange,'JFM')
    mmS = [1 2 3];
end

mxTemp = 45;                % degrees C, for outlier removal

dateForm = 'yyyy-mm-dd HH:MM:SS';
figRes   = '-m1';

rootDir = 'G:\GLTC\Raw Data\';
plotDir = 'G:\GLTC\Figures\';
resultsDir = 'G:\GLTC\Processed Data\';