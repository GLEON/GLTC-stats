function [dates, wtr, z, lakeNm] = loadLakes( fileName )

defaultsGLTC

if strcmp(fileName,'11Swedish_boreal_lakes.txt')
    reader = '%s %f %f %f %f %f %f'; 
    delim  = '\t';
    zi     = 0;
    lakeNmI= 1;
    yyyyI  = 4;
    mmI    = 5;
    ddI    = 6;
    wtrI   = 7;
    
    fileID = fopen([rootDir fileName]);
    data = textscan(fileID,reader,'HeaderLines',1,'Delimiter',delim);
    fclose all;
    
    dates = datenum(data{yyyyI},data{mmI},data{ddI});
    wtr   = data{wtrI};
    z     = ones(length(wtr),1)*zi;
    lakeNm= data{lakeNmI};
    

elseif strcmp(fileName,'Historical_FL.txt')
    reader = '%s %s %s %f %s %f %f %f';
    delim  = '\t';
    zi     = 0;
    lakeNmI= 5;
    yyyyI  = 6;
    mmI    = 7;
    ddI    = 8;
    wtrI   = 4;
    
    fileID = fopen([rootDir fileName]);
    data = textscan(fileID,reader,'HeaderLines',1,'Delimiter',delim);
    fclose all;
    
    dates = datenum(data{yyyyI},data{mmI},data{ddI});
    wtr   = data{wtrI};
    z     = ones(length(wtr),1)*zi;
    lakeNm= data{lakeNmI};
    
elseif strcmp(fileName,'Lake Orta 1980-2001.csv')
    reader = '%f %f %f %f %s';
    delim  = ',';
    zi     = 0;
    dI     = 5;
    wtrI   = 4;
    
    fileID = fopen([rootDir fileName]);
    data = textscan(fileID,reader,'HeaderLines',1,'Delimiter',delim);
    fclose all;
    
    dates = datenum(data{dI},'yyyy-mm-dd');
    wtr   = data{wtrI};
    z     = ones(length(wtr),1)*zi;
    lakeNm= 'Orta';
    
elseif strcmp(fileName,'Lake Maggiore 1990-2011.csv')
    reader = '%f %f %f %f %s';
    delim  = ',';
    zi     = 0;
    dI     = 5;
    wtrI   = 4;
    
    fileID = fopen([rootDir fileName]);
    data = textscan(fileID,reader,'HeaderLines',1,'Delimiter',delim);
    fclose all;
    
    dates = datenum(data{dI},'yyyy-mm-dd');
    wtr   = data{wtrI};
    z     = ones(length(wtr),1)*zi;
    lakeNm= 'Maggiore';
    
elseif strcmp(fileName,'Lake Taupo 1995-2011 NEED JFM means.csv')
    reader = '%s %s %f %f';
    delim  = ',';
    zi     = 1;
    dI     = 2;
    wtrI   = 3;
    
    fileID = fopen([rootDir fileName]);
    data = textscan(fileID,reader,'HeaderLines',1,'Delimiter',delim);
    fclose all;
    
    dates = datenum(data{dI},'yyyy-mm-dd');
    wtr   = data{wtrI};
    z     = ones(length(wtr),1)*zi;
    lakeNm= 'Taupo';
    
elseif strcmp(fileName,'Malaren 0.5m 1964-2010.csv')
    reader = '%s %f';
    delim  = ',';
    zi     = 0.5;
    dI     = 1;
    wtrI   = 2;
    
    fileID = fopen([rootDir fileName]);
    data = textscan(fileID,reader,'HeaderLines',1,'Delimiter',delim);
    fclose all;
    
    dates = datenum(data{dI},'yyyy-mm-dd');
    wtr   = data{wtrI};
    z     = ones(length(wtr),1)*zi;
    lakeNm= 'Malaren';
    
elseif strcmp(fileName,'Vanern 1973-2010.csv')
    reader = '%s %f';
    delim  = ',';
    zi     = 0.0;
    dI     = 1;
    wtrI   = 2;
    
    fileID = fopen([rootDir fileName]);
    data = textscan(fileID,reader,'HeaderLines',1,'Delimiter',delim);
    fclose all;
    
    dates = datenum(data{dI},'yyyy-mm-dd');
    wtr   = data{wtrI};
    z     = ones(length(wtr),1)*zi;
    lakeNm= 'Vanern';
elseif strcmp(fileName,'Erken 1m 1988-2007.csv')
    reader = '%s %f';
    delim  = ',';
    zi     = 1.0;
    dI     = 1;
    wtrI   = 2;
    
    fileID = fopen([rootDir fileName]);
    data = textscan(fileID,reader,'HeaderLines',1,'Delimiter',delim);
    fclose all;
    
    dates = datenum(data{dI},'yyyy-mm-dd');
    wtr   = data{wtrI};
    z     = ones(length(wtr),1)*zi;
    lakeNm= 'Erken';
    
elseif strcmp(fileName(1:4),'Okee')
    reader = '%s %s %s %s %s %s %s %s';
    delim  = ',';
    zI     = 4;
    dI     = 1;
    wtrI   = 5;
    
    fileID = fopen([rootDir fileName]);
    data = textscan(fileID,reader,'HeaderLines',1,'Delimiter',delim,...
        'TreatAsEmpty','"."');
    fclose all;
    
    data{zI} = regexprep(data{zI},'"','');
    data{wtrI} = regexprep(data{wtrI},'"','');
    
    dates = datenum(data{dI},'yyyy-mm-dd');
    wtr   = str2double(data{wtrI});
    z     = str2double(data{zI});
    lakeNm= fileName(1:end-4);
elseif strcmp(fileName,'Index Surface Temp 1967-2012 Tahoe.xlsx')
    
    StationID = 'Index'; % or Mid-lake'
    
    date_I = 3;
    dep_I  = 3;
    Ts_I   = 4;
    mnZ    = 0;
    mxZ    = 1.2;
    sta_I  = 1;
    
    [num,txt] = xlsread([rootDir fileName],...
        'Surface Temp');
    
    
    dates = NaN(length(txt)-2,1);
    varL = length(dates);
    Ts   = dates;
    dep  = dates;
    
    for j = 1:varL
        dates(j) = datenum(txt{j+2,date_I});
        Ts(j)    = num(j,Ts_I);
        dep(j)   = num(j,dep_I);
        station{j} = txt{j+2,sta_I};
    end
    
    rmvI = gt(dep,mxZ) | lt(dep,mnZ);
    
    dates = dates(~rmvI);
    Ts    = Ts(~rmvI);
    station = station(~rmvI);
    
    useI = strcmp(station,StationID);
    
    wtr = Ts(useI);
    dates = dates(useI);
    z   = zeros(length(wtr),1);
    lakeNm = ['Tahoe_' StationID];
elseif strcmp(fileName,'Mid-lake Surface Temp 1967-2012 Tahoe.xlsx')
    
    StationID = 'Mid-lake'; % or Mid-lake'
    
    date_I = 3;
    dep_I  = 3;
    Ts_I   = 4;
    mnZ    = 0;
    mxZ    = 1.2;
    sta_I  = 1;
    
    [num,txt] = xlsread([rootDir fileName],...
        'Surface Temp');
    
    
    dates = NaN(length(txt)-2,1);
    varL = length(dates);
    Ts   = dates;
    dep  = dates;
    
    for j = 1:varL
        dates(j) = datenum(txt{j+2,date_I});
        Ts(j)    = num(j,Ts_I);
        dep(j)   = num(j,dep_I);
        station{j} = txt{j+2,sta_I};
    end
    
    rmvI = gt(dep,mxZ) | lt(dep,mnZ);
    
    dates = dates(~rmvI);
    Ts    = Ts(~rmvI);
    station = station(~rmvI);
    
    useI = strcmp(station,StationID);
    
    wtr = Ts(useI);
    dates = dates(useI);
    z   = zeros(length(wtr),1);
    lakeNm = ['Tahoe_' StationID];
elseif strcmp(fileName,'Biwa_LBERI.csv')
    reader = '%s %f %f %s %f %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s';
    delim  = ',';
    yyyyI  = 1;
    mmI    = 2;
    ddI    = 3;
    zI     = 4;
    wtrI   = 5;
    
    fileID = fopen([rootDir fileName]);
    data = textscan(fileID,reader,'HeaderLines',1,'Delimiter',delim);
    fclose all;
    yyyy  = str2double(regexprep(data{yyyyI},'"',''));
    dates = datenum(yyyy,data{mmI},data{ddI});
    wtr   = data{wtrI};
    z     = str2double(data{zI});
    nanI  = isnan(z);
    z = z(~nanI);   % REMOVING DEPTH FROM BOTTOM MEASUREMENTS
    wtr = wtr(~nanI);
    dates = dates(~nanI);
    lakeNm= 'Biwa';
elseif strcmp(fileName,'Toolik.csv')
    reader = '%s %s %s %s';
    delim  = ',';
    zI     = 3;
    dI     = 2;
    wtrI   = 4;
    
    fileID = fopen([rootDir fileName]);
    data = textscan(fileID,reader,'HeaderLines',3,'Delimiter',delim);
    fclose all;
    
    dates = datenum(data{dI},'yyyy-mm-dd');
    wtr   = str2double(data{wtrI});
    z     = str2double(data{zI});
    rmvI  = isnan(wtr) | eq(z,-1);
    dates = dates(~rmvI);
    z     = z(~rmvI);
    wtr   = wtr(~rmvI);
    % remove AIR temp measurements (anything < 0)
    
    % now bin measurements (rounding to neaest 50 cm)
    z = round(z*2)/2;
    lakeNm= 'Toolik';
elseif strcmp(fileName,'Kinneret.csv')
    reader = '%s %f';
    delim  = ',';
    zi     = 0.0;
    dI     = 1;
    wtrI   = 2;
    
    fileID = fopen([rootDir fileName]);
    data = textscan(fileID,reader,'HeaderLines',1,'Delimiter',delim);
    fclose all;
    
    dates = datenum(data{dI}(1:end-1),'yyyy-mm-dd');
    wtr   = data{wtrI};
    if ne(length(dates),length(wtr))
        error('dates and water temps are different lengths')
    end
    z     = ones(length(wtr),1)*zi;
    lakeNm= 'Kinneret';
elseif strcmp(fileName,'Mendota_all_0m.csv')
    reader = '%f %f %f %f';
    delim  = ',';
    yyyyI  = 1;
    mmI    = 2;
    ddI    = 3;
    wtrI   = 4;
    zi     = 0;
    
    fileID = fopen([rootDir fileName]);
    data = textscan(fileID,reader,'HeaderLines',1,'Delimiter',delim);
    fclose all;
    
    dates = datenum(data{yyyyI},data{mmI},data{ddI});
    wtr   = data{wtrI};
    if ne(length(dates),length(wtr))
        error('dates and water temps are different lengths')
    end
    z     = ones(length(wtr),1)*zi;
    lakeNm= 'Mendota';
elseif strcmp(fileName,'Lake_Pyhaselka.csv')
    reader = '%s %s %f %f'; 
    delim  = ',';
    zI     = 3;
    lakeNmI= 1;
    dI     = 2;
    wtrI   = 4;
    
    fileID = fopen([rootDir fileName]);
    data = textscan(fileID,reader,'HeaderLines',1,'Delimiter',delim);
    fclose all;
    
    dates = datenum(data{dI},'yyyy-mm-dd');
    wtr   = data{wtrI};
    z     = data{zI};
    lakeNm= data{lakeNmI};
    for i = 1:length(lakeNm)
        lakeNm{i} = ['Pyhaselka_' lakeNm{i}];
    end
elseif strcmp(fileName,'Lake_Valkea-Kotinen_Temp_data_1990_2009.csv')
    reader = '%f %f %f %f %f';
    delim  = ',';
    wwI    = 1;
    mmI    = 2;
    yyyyI  = 3;
    zI     = 4;
    wtrI   = 5;
    
    
    fileID = fopen([rootDir fileName]);
    data = textscan(fileID,reader,'HeaderLines',1,'Delimiter',delim);
    fclose all;
    
    weeks = data{wwI};
    mm    = data{mmI};
    yyyy  = data{yyyyI};
    varL  = length(mm);
    
    % find the tuesday of each week given, convert to dates
    dates = NaN(varL,1);
    
    unYr = unique(yyyy);
    for j = 1:length(unYr)
        useI = eq(yyyy,unYr(j));
        % find first tuesday of each year
        % end of wk 1 is first sat
        for dd = datenum(unYr(j),1,1):datenum(unYr(j),1,7)
            if eq(weekday(dd),7)
                wks = unique([datenum(unYr(j),1,1) dd:7:datenum(unYr(j)+1,1,0)]);
                break
            end
        end
        tues = wks*NaN;
        for t = 1:length(wks)-1
            poss = wks(t):wks(t+1);
            if any(eq(weekday(poss),3))
                tues(t) = poss(eq(weekday(poss),3));
            end
        end
        disp(['working on ' num2str(unYr(j))])
        dates(useI) = tues(weeks(useI));
    end


    wtr   = data{wtrI};
    if ne(length(dates),length(wtr))
        error('dates and water temps are different lengths')
    end
    z     = data{zI};
    lakeNm= 'Valkea-Kotinen';
elseif strcmp(fileName,'Valkea-Kotinen_Temp_data_1990_2010.csv')
    reader = '%s %f %f';
    delim  = ',';
    dI     = 1;
    wtrI   = 3;
    zI     = 2;
    
    fileID = fopen([rootDir fileName]);
    data = textscan(fileID,reader,'HeaderLines',1,'Delimiter',delim);
    fclose all;
    dates = NaN(length(data{dI}),1);
    for i = 1:length(data{dI})
        txt = char(data{dI}(i));
        repI = strfind(txt,'.');
        txt(repI) = '-';
        if le(length(txt),8)
            dates(i) = datenum(txt,'dd-mm-yy');
        else
            dates(i) = datenum(txt,'yyyy-mm-dd');
        end
    end
    
    wtr   = data{wtrI};
    z     = data{zI};
    lakeNm= 'Valkea-Kotinen';
elseif strcmp(fileName,'Rusak_lakes.txt')
    reader = '%s %s %f %f %f %s';
    delim  = '\t';
    lakeNmI= 6;
    dI     = 2;
    wtrI   = 4;
    zI     = 3;
    
    fileID = fopen([rootDir fileName]);
    data = textscan(fileID,reader,'HeaderLines',1,'Delimiter',delim);
    fclose all;
    
    dates = datenum(data{dI},'mm-dd-yyyy');
    wtr   = data{wtrI};
    z     = data{zI};
    lakeNm= data{lakeNmI};
    % redundant (but different) naming
    nm = {'DICKIE LAKE','Dickie'};
    repI  = strcmp(lakeNm,nm{1});
    for i = 1:length(repI)
        if repI(i)
            lakeNm{i} = nm{2};
        end
    end
    nm = {'CHUB LAKE','Chub'};
    repI  = strcmp(lakeNm,nm{1});
    for i = 1:length(repI)
        if repI(i)
            lakeNm{i} = nm{2};
        end
    end
    nm = {'BLUE CHALK LAKE','Blue Chalk'};
    repI  = strcmp(lakeNm,nm{1});
    for i = 1:length(repI)
        if repI(i)
            lakeNm{i} = nm{2};
        end
    end
    nm = {'CROSSON LAKE','Crosson'};
    repI  = strcmp(lakeNm,nm{1});
    for i = 1:length(repI)
        if repI(i)
            lakeNm{i} = nm{2};
        end
    end
    nm = {'HARP LAKE','Harp'};
    repI  = strcmp(lakeNm,nm{1});
    for i = 1:length(repI)
        if repI(i)
            lakeNm{i} = nm{2};
        end
    end    
    nm = {'HARP LAKE','Harp'};
    repI  = strcmp(lakeNm,nm{1});
    for i = 1:length(repI)
        if repI(i)
            lakeNm{i} = nm{2};
        end
    end  
    nm = {'HENEY LAKE','Heney'};
    repI  = strcmp(lakeNm,nm{1});
    for i = 1:length(repI)
        if repI(i)
            lakeNm{i} = nm{2};
        end
    end 
    nm = {'PLASTIC LAKE','Plastic'};
    repI  = strcmp(lakeNm,nm{1});
    for i = 1:length(repI)
        if repI(i)
            lakeNm{i} = nm{2};
        end
    end
    nm = {'RED CHALK LAKE - EAST','Red Chalk East'};
    repI  = strcmp(lakeNm,nm{1});
    for i = 1:length(repI)
        if repI(i)
            lakeNm{i} = nm{2};
        end
    end
    nm = {'RED CHALK LAKE - MAIN','Red Chalk Main'};
    repI  = strcmp(lakeNm,nm{1});
    for i = 1:length(repI)
        if repI(i)
            lakeNm{i} = nm{2};
        end
    end

elseif strcmp(fileName,'Lake Pääjärvi_Temp_data_1994-2010.xlsx')
    
    [num,txt] = xlsread([rootDir fileName],...
        'Data');
    
    dd_mm  = txt(2,3:end);  % dd.mm format
    yyyy   = num(1,3:end);  % yyyy in doubles
    wtrT    = num(3:end-4,3:end);
    zT      = num(3:end-4,1);
    numZ    = length(zT);
    numD    = length(dd_mm);
    dates   = NaN(numD*numZ,1);
    wtr     = dates;
    z       = dates;
    cnt = 1;
    for j = 1:numD
        for i = 1:numZ
            txt = char(dd_mm(j));
            repI = strfind(txt,'.');
            txt(repI) = '-';
            dates(cnt) = datenum([txt num2str(yyyy(j))],'dd-mm-yyyy');
            wtr(cnt) = wtrT(i,j);
            z(cnt)   = zT(i);
            cnt = cnt+1;
            
        end
    end
    
    nanI = gt(wtr,40);
    wtr(nanI) = NaN;
            
       
    lakeNm= 'Pääjärvi';
elseif strcmp(fileName,'1975-2011 June-October Oneida Lake Surface Temperatures.xlsx')
    
    [num,txt] = xlsread([rootDir fileName],...
        'Site Surface Temperatures');
    
    date    = txt(2:end,1);  
    wtr     = num(1:end,2);
    z       = num(1:end,1);
    dates   = datenum(date,'yyyy-mm-dd');
    siteNm  = txt(2:end,2);
    lakeNm  = cell(length(wtr),1);
    for k = 1:length(wtr)
        lakeNm{k} = ['Oneida_' siteNm{k}];
    end
    [dates,srtI] = sort(dates);
    wtr = wtr(srtI);
    z   = z(srtI);
elseif strcmp(fileName,'DR32900-Various lakes and reservoirs-Site details and water quality and other variables.xlsx')
    
    [num,txt] = xlsread([rootDir fileName],...
        'Water Quality');
    methI = 16;
    wtrI  = 32;
    zI    = 18;
    dI    = 6;
    siteI = 4;
    date  = txt(2:end,dI);  % hh:mm:ss dd-mm-yyyy
    wtr   = num(1:end,wtrI);  
    z     = num(1:end,zI);  
    collMethod = txt(2:end,methI);  
    replI = strcmp(collMethod,'Grab sample') & isnan(z);
    z(replI) = 0;
    dates   = datenum(date);
    lakeNm  = txt(2:end,siteI);
    nanI = isnan(z) | isnan(wtr);
    wtr = wtr(~nanI);
    z   = z(~nanI);
    dates = dates(~nanI);
    lakeNm = lakeNm(~nanI);
elseif strcmp(fileName,'GesaLAKEvATtEMP.xlsx')
    
    [num,txt] = xlsread([rootDir fileName],...
        'Blad1');
    wtrI  = 6;
    zI    = 5;
    dI    = 4;
    siteI = 2;
    date  = txt(2:end,dI);  % hh:mm:ss dd-mm-yyyy
    wtr   = num(1:end,wtrI);  
    z     = num(1:end,zI);  
    dates   = datenum(date);
    lakeNm  = txt(2:end,siteI);
    nanI = isnan(z) | isnan(wtr);
    wtr = wtr(~nanI);
    z   = z(~nanI);
    dates = dates(~nanI);
    lakeNm = lakeNm(~nanI);
elseif strcmp(fileName,'GLWC_Lake-Stechlin_water-temperatures_1957-2012.xls')
    % weird format: different columns for different years
    
    [num,txt] = xlsread([rootDir fileName],...
        'Tabelle1');
    wtrI  = 2:3:245;
    zI    = 1:3:244;
    dI    = 1:3:243;
    date  = txt(9:end,dI);  % hh:mm:ss dd-mm-yyyy
    wtr   = num(1:end,wtrI);  
    z     = num(1:end,zI);
    
    dates = NaN(1000000,1);
    wtrT  = dates;
    zT    = dates;
    cnt   = 0;
    for j = 1:size(date,1);
        for i = 1:size(date,2);
            cnt = cnt+1;
            if ~strcmp(date{j,i},'') && ~strcmp(date{j,i},'no data')...
                    && ~strcmp(date{j,i},'Datum') 
                
                dates(cnt) = datenum(date{j,i});
                wtrT(cnt)  = wtr(j,i);
                zT(cnt)    = z(j,i);
            end
        end
        
    end
    wtr = wtrT;
    z   = zT;
    wtr(gt(wtr,40)) = NaN;  % remove temp > 40;
    nanI = isnan(z) | isnan(wtr);
    wtr = wtr(~nanI);
    z   = z(~nanI);
    dates = dates(~nanI);
    [dates,srtI] = sort(dates);
    wtr = wtr(srtI);
    z   = z(srtI);
    lakeNm = 'Stechlin';
elseif strcmp(fileName,'MW Temperature Data.xls')
    % ONLY USING SURFACE DATA!!
    [num,txt] = xlsread([rootDir fileName],...
        'Sheet1');
    
    useNames = {'CARDINIA DAM NEAR TOWER - SURF',...
        'GREENVALE RES NEAR TOWER-SURF',...
        'MAROONDAH RES AT TOWER-SURF',...
        'SILVAN RES NEAR TOWER-SURFACE',...
        'SUGARLOAF RES MIDDLE-SURF',...
        'U/YARRA DAM NEAR WALL-SURF',...
        'YAN YEAN RES MIDDLE SURFACE',...
        'YAN YEAN RES SURFACE'};
        
    transNames = {'Cardinia',...
        'Greenvale',...
        'Maroondah',...
        'Silvan',...
        'Sugarloaf',...
        'U-Yarra',...
        'Yan Yean',...
        'Yan Yean'};
    wtrI  = 1;
    siteI = 2;
    dI    = 3;
    lakeNm  = txt(2:end,siteI);
    date  = txt(2:end,dI);
    wtr   = num(1:end,wtrI);
    dates   = datenum(date);
    z     = NaN(length(dates),1);
    for j = 1:length(dates);
        if any(strcmp(useNames,lakeNm{j}))
            z(j) = 0;
            useI = strcmp(useNames,lakeNm{j});
            lakeNm{j} = transNames{useI};
            
        end
    end
    % rid of all nan z's
    nanI = isnan(z) | isnan(wtr);
    wtr = wtr(~nanI);
    z   = z(~nanI);
    dates = dates(~nanI);
    lakeNm = lakeNm(~nanI);
elseif strcmp(fileName,'Temp_Greifensee.xls')
    
    [num,txt] = xlsread([rootDir fileName],...
        'Sheet 1');
    wtrI  = 2;
    zI    = 1;
    dI    = 1;
    date  = txt(6:end,dI);  % hh:mm:ss dd-mm-yyyy
    wtr   = num(1:end,wtrI);  
    z     = num(1:end,zI);  
    dates   = datenum(date);
    nanI = isnan(z) | isnan(wtr);
    wtr = wtr(~nanI);
    z   = z(~nanI);
    dates = dates(~nanI);
    lakeNm = 'Greifensee';
elseif strcmp(fileName,'TemperaturesAnnecy.xlsx')
    
    % ONLY using 2.5m depth!!!! ONLY SUMMER!
    [num,txt] = xlsread([rootDir fileName],...
        'Summer');
    wtrI  = 3;
    dI    = 2;
    siteI = 1;
    date  = txt(2:end,dI);  % hh:mm:ss dd-mm-yyyy
    dates = NaN(length(date),1);
    for j = 1:length(dates)
        if ~strcmp(date{j},'')
            dates(j) = datenum(date{j});
        end
    end
    wtr   = num(1:end,wtrI); 
    z     = ones(length(wtr),1)*2.5;  % given as 2.5+-0.5m 
    lakeNm  = txt(2:end,siteI);
    nanI = isnan(z) | isnan(wtr);
    wtr = wtr(~nanI);
    z   = z(~nanI);
    dates = dates(~nanI);
    lakeNm = lakeNm(~nanI);
elseif strcmp(fileName,'TemperaturesBourget.xlsx')
    
    % ONLY using 2.0m depth!!! ONLY SUMMER!
    [num,txt] = xlsread([rootDir fileName],...
        'Summer');
    wtrI  = 15;
    dI    = 13;
    date  = txt(2:end,dI);  % hh:mm:ss dd-mm-yyyy
    dates = NaN(length(date),1);
    for j = 1:length(dates)
        if ~strcmp(date{j},'')
            dates(j) = datenum(date{j});
        end
    end
    wtr   = num(1:end,wtrI); 
    z     = ones(length(wtr),1)*2.;  % given as 2.0+-0.4m 
    nanI = isnan(z) | isnan(wtr);
    wtr = wtr(~nanI);
    z   = z(~nanI);
    dates = dates(~nanI);
    lakeNm = 'Bourget';
end
lakeNm = regexprep(lakeNm,' ','_');
lakeNm = regexprep(lakeNm,'…','');
rmvI = gt(wtr,mxTemp);
wtr = wtr(~rmvI);
z   = z(~rmvI);
dates = dates(~rmvI);
if iscell(lakeNm)
    lakeNm = lakeNm(~rmvI);
end

end
