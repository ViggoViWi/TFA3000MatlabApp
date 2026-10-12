% This script should give me a plot of the I(V) curve and show me the V(t)
% diagramm
function [resultTable, data] = extractTF3000PM(filepath) 
    % Was ich machen muss: Ursprungsordner automatisch durchsuchen nach namen
    
    % Dateipfad
        %only for testing
        % filepath = 'U:\NxtCloud\CAU\N4F\Daten\aixTF3000\MollyProben\FHGM4332-Cycling1e4\Sample1\FHGM4332-Cycling1e4-Sample1-R1P1.dat';
        % filepath = 'U:\NxtCloud\CAU\N4F\Daten\aixTF3000\MollyProben\FHGM4332-26p5Amp\NewReadProc\FHGM4332-Cycling1e5-Sample5-R1P30-BreakdownAt5e4.dat';
    [fPath, fName, fExt] = fileparts(filepath);
    disp(filepath)
    % char-Vector mit komplettem Dateiinhalt
    lines = readlines(filepath);  

    
    % string pattern für den Start einer neuen Tabelle
    % patter ist "Table {int}" nach dem integer darf kein char mehr kommen.
    pat1   = "Result Table " + digitsPattern(0, Inf) + textBoundary("end");
    pat2   = "Data Table [" + digitsPattern(0, Inf)+","+ digitsPattern(0, Inf)+"]" + textBoundary("end");
    
    % Finde alle leeren Zeilen
    blankLines = cellfun('isempty', lines);


    % Start of the result table
    resultTabStart =  find(matches(lines, pat1));
    resultTabEnd = find(blankLines(resultTabStart:end,1), 1, 'first') + resultTabStart-1;
    % Erstelle cell array mit den Tabellen 
    resulttablesAsLines= cell(1,length(resultTabStart));
    for i=1:length(resultTabStart)
        resulttablesAsLines{i}=lines(resultTabStart(i):resultTabEnd(i));
    end

    for i=1:length(resulttablesAsLines)
        % Index der Kopfzeile finden
        idxHeader = find(contains(resulttablesAsLines{i}, 'Measurement Status'), 1, 'first')+1;
        % Kopfzeile und Datenzeilen
        headerLine = resulttablesAsLines{i}{idxHeader};
        dataLines  = resulttablesAsLines{i}(idxHeader+1:end);
        % Meta-Infos (alles davor)
        metaLines = resulttablesAsLines{i}(1:idxHeader-1);
        % Datenzeilen zu einem einzigen String mit Zeilenumbrüchen verbinden
        headerText=string(headerLine);
        dataText = strjoin(dataLines, newline);
        % erste Zeile extrahieren
        newlineIdx = regexp(dataText, '\r\n|\n|\r', 'once');% Suche das erste Newline-Zeichen (\n, \r\n oder \r) im String.
        if isempty(newlineIdx)% Falls kein Newline gefunden wird, besteht dataText nur aus einer Zeile.
            firstLine = strtrim(dataText);% strtrim entfernt dabei Leerzeichen/Tabs am Anfang und Ende.
        
        else
            firstLine = extractBefore(dataText,newlineIdx-1);% Sonst: nimm alles von Anfang bis direkt vor das Newline als erste Zeile.
        end
        
        % Spalten zählen (Whitespace-Delimiter)
        % strsplit zerlegt den String in Teile (Tokens) an Leerzeichen/Tabs. 
        % numel gibt die Anzahl der Elemente in einem Array zurück. ALSO:  wie viele Spalten.
        cols = numel(strsplit(firstLine));
    
        % Daten auslesen: 9 Spalten double
        fmt = repmat('%f', 1, cols);
        convertData = textscan(dataText, fmt, 'Delimiter', {'\t',' '}, 'MultipleDelimsAsOne', true);
        colLengths = cellfun(@numel, convertData);
        if numel(unique(colLengths)) ~= 1 || colLengths(1) == 0
            warning('Skipping table %d: inconsistent column lengths or empty data of File %s%s.', i,fName,fExt);
        continue   % go to next table
        else 
            convertData2 = cell2mat(convertData);   % -> N×M double
            if size(convertData2,1) == 1 % Only one Line? something wrong with this table!
                continue 
            else
                convertData = convertData2;
            end
            
        end
    
        header = strsplit(strtrim(headerText),'\t');
        
        [headerNames,headerDescr,headerUnits] = varNamesForMatlabTab(header);


        tablesAsTable{i} = array2table(convertData, 'VariableNames', headerNames); 
        tablesAsTable{i}.Properties.VariableDescriptions = headerDescr; 
        tablesAsTable{i}.Properties.VariableUnits = headerUnits; 

   
        % same for the meta information
        metaText = strjoin(metaLines(2:end), newline);
        
        

        rows = splitlines(string(metaText));  % split at '\n'
        rows(rows == "") = [];           % remove possible empty line at end
        
        metapartstmp = regexp(rows,':','split','once') ;      % split each row into columns
        metaparts = string(vertcat(metapartstmp{:}));

        [metaNames,metaDescr,metaUnits] = varNamesForMatlabTab(transpose(metaparts(:,1)));
        
        metaInfTables{i} = array2table(transpose(metaparts(:,2)), 'VariableNames', metaNames); 
        metaInfTables{i}.Properties.VariableDescriptions = metaDescr; 
        metaInfTables{i}.Properties.VariableUnits = metaUnits;
        clear metaNames
    end
    metaInfTables{end+1}.Properties.VariableDescriptions = 'FilePath';

    resultTable = struct('T',[],'M',[]);   % preallocation

    convTab         =   tablesAsTable;
    convMeta        =   metaInfTables;
    resultTable(1).T     =   convTab{1}; 
    % add filepath in front using addvars
    convMeta{1} = addvars(convMeta{1}, string(filepath), ...
    'Before', 1, ...                  % insert before first column
    'NewVariableNames', 'FilePath');  % name of the new variable
    resultTable.M     =   convMeta{1};






    % FROM HERE WE EXTRACT THE DATA AND NOT THE RESULTTABLE 

    % Er soll alle Zeilen durchsuchen, ob eine neue Tabelle startet.
    % Erstellt ein logical array
    idxLogical   = matches(lines, pat2);

    % Nur die Indizes abspeichern
    idxTabStart = find(idxLogical);
    
    %init idxTabEnd
    idxTabEnd=nan(size(idxTabStart));
    
    % Finde die Enden der Tabellen
    for i=1:length(idxTabStart) % iteriere über den array der Tabellenstart Indizes
        curridx=idxTabStart(i); % Aktueller Tabellenstart Index
    
        % Find die nächste leere Zeile 
        % array aus index tabellen start bis ende
        % nächste leere Zeile finden 
        % Die Zeilen, die weggelassen wurden wieder hinzufügen
        k = find(blankLines(curridx:end,1), 1, 'first') + curridx-1;
        % Füge Index dem array hinzu
        idxTabEnd(i) = k; 
    end
    

    % Übersicht halber
    clearvars blankLines k i idxLogical pat curridx
    % Erstelle cell array mit den Tabellen 
    tablesAsLines= cell(1,length(idxTabStart));
    for i=1:length(idxTabStart)
        tablesAsLines{i}=lines(idxTabStart(i):idxTabEnd(i));
    end
    
    
    tablesAsTable = cell(1,length(tablesAsLines));
    metaInfTables = cell(1,length(tablesAsLines));
    
    tableNames = lines(idxTabStart);
    
    tmpa = cellfun(@(tn) tn(strfind(tn,'[')+1:strfind(tn,']')-1), tableNames, 'UniformOutput', false);
    tmpb = cellfun(@(tn) strsplit(tn,','),tmpa, 'UniformOutput', false);
    PZMMeasMat = cell2mat(cellfun(@(tn) cell2mat(cellfun(@(tmpc) str2num(tmpc),tn,'UniformOutput',false)),tmpb,'UniformOutput',false));
    


        for i=1:length(tablesAsLines)
        
        PZMnum = PZMMeasMat(i,1);
        measurementNum = PZMMeasMat(i,2);
        % Index der Kopfzeile finden
        idxHeader = find(contains(tablesAsLines{i}, 'Measurement Status'), 1, 'first')+1;
        tempT = tablesAsLines{i};
        if contains(tempT(idxHeader), 'Failed') 
            idxHeader = idxHeader+1;
        end
        % Kopfzeile und Datenzeilen
        headerLine = tablesAsLines{i}{idxHeader};
        dataLines  = tablesAsLines{i}(idxHeader+1:end);
        % Meta-Infos (alles davor)
        metaLines = tablesAsLines{i}(1:idxHeader-1);
        % Datenzeilen zu einem einzigen String mit Zeilenumbrüchen verbinden
        headerText=string(headerLine);
        dataText = strjoin(dataLines, newline);
        % erste Zeile extrahieren
        newlineIdx = regexp(dataText, '\r\n|\n|\r', 'once');% Suche das erste Newline-Zeichen (\n, \r\n oder \r) im String.
        if isempty(newlineIdx)% Falls kein Newline gefunden wird, besteht dataText nur aus einer Zeile.
            firstLine = strtrim(dataText);% strtrim entfernt dabei Leerzeichen/Tabs am Anfang und Ende.
        
        else
            firstLine = extractBefore(dataText,newlineIdx-1);% Sonst: nimm alles von Anfang bis direkt vor das Newline als erste Zeile.
        end
        
        % Spalten zählen (Whitespace-Delimiter)
        % strsplit zerlegt den String in Teile (Tokens) an Leerzeichen/Tabs. 
        % numel gibt die Anzahl der Elemente in einem Array zurück. ALSO:  wie viele Spalten.
        cols = numel(strsplit(firstLine));
    
        % Daten auslesen: 9 Spalten double
        fmt = repmat('%f', 1, cols);
        convertData = textscan(dataText, fmt, 'Delimiter', {'\t',' '}, 'MultipleDelimsAsOne', true);
        colLengths = cellfun(@numel, convertData);
        if numel(unique(colLengths)) ~= 1 || colLengths(1) == 0
            warning('Skipping table %d: inconsistent column lengths or empty data of File %s%s.', i,fName,fExt);
        continue   % go to next table
        else 
            convertData2 = cell2mat(convertData);   % -> N×M double
            if size(convertData2,1) == 1 % Only one Line? something wrong with this table!
                continue 
            else
                convertData = convertData2;
            end
            
        end
    
        header = strsplit(strtrim(headerText),'\t');
        
        [headerNames,headerDescr,headerUnits] = varNamesForMatlabTab(header);


        tablesAsTable{i} = array2table(convertData, 'VariableNames', headerNames); 
        tablesAsTable{i}.Properties.VariableDescriptions = headerDescr; 
        tablesAsTable{i}.Properties.VariableUnits = headerUnits; 

   
        % same for the meta information
        metaText = strjoin(metaLines(2:end), newline);
        
        

        rows = splitlines(string(metaText));  % split at '\n'
        rows(rows == "") = [];           % remove possible empty line at end
        
        metapartstmp = regexp(rows,':','split','once') ;      % split each row into columns
        metaparts = string(vertcat(metapartstmp{:}));
        
        metaparts = ["PZM" , PZMnum; "Measurement", measurementNum; metaparts];

        [metaNames,metaDescr,metaUnits] = varNamesForMatlabTab(transpose(metaparts(:,1)));
        
        metaInfTables{i} = array2table(transpose(metaparts(:,2)), 'VariableNames', metaNames); 
        metaInfTables{i}.Properties.VariableDescriptions = metaDescr; 
        metaInfTables{i}.Properties.VariableUnits = metaUnits;
        clear metaNames
    end
    metaInfTables{end+1}.Properties.VariableDescriptions = 'FilePath';
    N=length(tablesAsTable);


    data(max(PZMMeasMat(:,2)),max(PZMMeasMat(:,1))) = struct('T',[],'M',[]);   % preallocation
    
    
    
    for k = 1:N 
        PZMnum = PZMMeasMat(k,1);
        MeasurementNum = PZMMeasMat(k,2);
        convTab         =   tablesAsTable(k);
        convMeta        =   metaInfTables(k);
        data(MeasurementNum,PZMnum).T     =   convTab{1}; 
        % add filepath in front using addvars
        convMeta{1} = addvars(convMeta{1}, string(filepath), ...
        'Before', 1, ...                  % insert before first column
        'NewVariableNames', 'FilePath');  % name of the new variable
        data(MeasurementNum,PZMnum).M     =   convMeta{1};
    end
end
% 