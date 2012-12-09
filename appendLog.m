function appendLog_GLTC(fileN, lakeName, logMessage, years)

lakeName = regexprep(lakeName,' ','_');
lakeName = regexprep(lakeName,'…','');


fID   = fopen(fileN,'a');
for j = 1:length(years);
    if ~isempty(logMessage{j})
        fprintf(fID,[lakeName ' ' num2str(years(j)) ' ' logMessage{j} '\r\n']);
    end
end
fclose all;

end

