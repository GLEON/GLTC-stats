function closeLog(fileN)

fID   = fopen(fileN,'a');
fprintf(fID,'******\r\n');
fprintf(fID,['log file closed ' datestr(now,'yyyy-mm-dd HH:MM:SS')]);

fclose all;

end
