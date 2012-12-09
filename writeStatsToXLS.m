function writeStats_GLTC(years,meVal,mxGap,meGap,nmGap,lakeName,z,timeRange)

lakeN = regexprep(lakeName,' ','_');
lakeN = regexprep(lakeN,'…','');

disp(['lake name is ' lakeN]);

warning off MATLAB:xlswrite:AddSheet
outFile= ['Processed Data\' lakeN '_GLTC-' timeRange '.xls'];

% build cell for writing
topHeads = {'Year',[timeRange '_mean'],'max gap','mean gap','number of gaps'};

numY = length(years);

writeCell = cell(length(topHeads),numY+1);
for i = 1:length(topHeads)
    writeCell{i,1} = topHeads{i};
end

rmvI = false(numY+1,1);
for j = 1:numY
    if ~isnan(meVal(j))
        writeCell{1,j+1} = years(j);
        writeCell{2,j+1} = meVal(j);
        writeCell{3,j+1} = mxGap(j);
        writeCell{4,j+1} = meGap(j);
        writeCell{5,j+1} = nmGap(j);
    else
        rmvI(j+1) = true;
    end
end

writeCell = writeCell(:,~rmvI)';
if all(eq(size(writeCell),[1 5]))
    disp(['not writing sheet z_' num2str(z) ' on ' lakeN '. It is empty'])
else
    xlswrite(outFile,writeCell,['z_' num2str(z)]);
    excelObj = actxserver('Excel.Application');
    excelWorkbook = excelObj.workbooks.Open([cd '\' outFile]);
    worksheets = excelObj.sheets;
    numSheets = worksheets.count;
    worksheet.excelObj.EnableSound = false;
    j = 1;
    while j < numSheets
        name = worksheets.Item(j).Name;
        if ge(length(name),5) && strcmp(name(1:5),'Sheet')
            worksheets.Item(j).Delete;
            numSheets =  worksheets.count;
        else
            j = j+1;
        end
    end
    % after done deleting
    excelObj.EnableSound = true;
    excelWorkbook.Save;
    excelWorkbook.Close(false);
    excelObj.Quit;
    delete(excelObj);
    return;
end





end

