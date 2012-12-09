function [fileN] = startLog


fileN = ['G:\GLTC\Processed Data\GLTC_log_' datestr(now,'yyyymmdd') '.txt'];

fID   = fopen(fileN,'a');

fprintf(fID,['log file created ' datestr(now,'yyyy-mm-dd HH:MM:SS') '\r\n']);
fprintf(fID,'******\r\n');
fclose all;
end

