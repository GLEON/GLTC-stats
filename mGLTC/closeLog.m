function closeLog(fileN)

defaultsGLTC

fID   = fopen(fileN,'a');
fprintf(fID,'******\r\n');
fprintf(fID,['log file closed ' datestr(now,dateForm)]);

fclose all;

end
