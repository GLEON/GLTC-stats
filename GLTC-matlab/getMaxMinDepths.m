function getMaxMinDepths

% displays min and max depth for each lake

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
    [~, ~, z, lakeNm] = loadLakes( fileName );
    unLk = unique(lakeNm);
    for i = 1:length(unLk);
        useI = strcmp(lakeNm,unLk(i));
        mxZ = max(z(useI));
        mnZ = min(z(useI));
        if gt(mxZ-mnZ,1)
            disp(['lake ' unLk{i} ' zmin=' num2str(mnZ)...
                ', zmax=' num2str(mxZ)])
        end
    end
    
end

