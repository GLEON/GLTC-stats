function getAllLakes
% writes all files for raw data in directory.

defaultsGLTC


%% file finder

availfiles = dir(fullfile(rootDir));
% remove directories from this structure
numFiles = length(availfiles);
rmvFile = false(numFiles,1);
for k = 1:numFiles
    if availfiles(k).isdir
        rmvFile(k) = true;
    else
        disp(availfiles(k).name);
    end
end

availfiles = availfiles(~rmvFile);      % now only files

%% loop through files, read out, parse and write stats

numFiles = length(availfiles);
for k = 1:numFiles
    fileName = availfiles(k).name;
    disp('******-------********');
    disp(['working on ' fileName]);
    [~, ~,~, lakeNm] = loadLakes( fileName );
    unNm = unique(lakeNm);
    if iscell(unNm)
        for j = 1:length(unNm)
            disp(['lake ' unNm{j} ' is from ' fileName])
        end
    else
        disp(['lake ' unNm ' is from ' fileName])
    end
    
end
end
