fitRange = [183 274]; %July 1 to Sept 30th
timeRange = 'JAS';

if strcmp(timeRange,'JAS')
    mmS = [7 8 9];
elseif strcmp(timeRange,'JFM')
    mmS = [1 2 3];
end

dateForm = 'yyyy-mm-dd HH:MM:SS';
figRes   = '-m1';

rootDir = 'G:\GLTC\Raw Data\';
plotDir = 'G:\GLTC\Figures\';
resultsDir = 'G:\GLTC\Processed Data\';