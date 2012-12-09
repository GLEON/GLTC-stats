function [fileN] = startLog_GLTC


fileN = ['Processed Data\GLTC_log_' datestr(now,'yyyymmdd') '.txt'];

fID   = fopen(fileN,'a');

fprintf(fID,['log file created ' datestr(now,'yyyy-mm-dd HH:MM:SS') '\r\n']);
fprintf(fID,['******\r\n']);
fclose all;
end

