function [fileN] = startLog

defaultsGLTC

fileN = [resultsDir 'GLTC_log_' datestr(now,'yyyymmdd') '.txt'];

fID   = fopen(fileN,'a');

fprintf(fID,['log file created ' datestr(now,dateForm) '\r\n']);
fprintf(fID,'******\r\n');
fclose all;
end

