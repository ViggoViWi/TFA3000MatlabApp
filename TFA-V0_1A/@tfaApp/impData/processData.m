function [metaTable, dataTable] = processData(inputUINT8orString)
    
    if class(inputUINT8orString)=="uint8"
        inputString=string(char(inputUINT8orString));
    elseif class(inputUINT8orString)=="string" ||class(inputUINT8orString)=="char" 
        inputString=string(inputUINT8orString);
    end

    % Normalize and split into non-empty lines
    inputString = strtrim(string(inputString));
    % Remove a leading "STRING:" if present (case-sensitive as requested)
    if startsWith(inputString, "STRING:IDLESTRING:")
        inputString = regexprep(inputString, '^STRING:IDLESTRING:', '');
    end
    if startsWith(inputString, "STRING:")
        inputString = regexprep(inputString, '^STRING:', '');
    end
    lines = splitlines(inputString);
    lines = lines(strlength(strtrim(lines))>0);
    
    % Find data header (line starting with 'Time [s]')
    if isempty(find(startsWith(strtrim(lines),"Failed"),1))
        dataHeaderIdx = find(startsWith(strtrim(lines), "Measurement Status"), 1)+1;
    else
         dataHeaderIdx = find(startsWith(strtrim(lines),"Failed"),1)+1;
    end
    if isempty(dataHeaderIdx)
        disp(inputString)
        error("Could not find data header starting with 'Measurement Status'.");
    end
    
    % Parse metadata (all lines before header)
    metaLines = strtrim(lines(1:dataHeaderIdx-1));
    % Keep only lines containing a colon
    metaLines = metaLines(contains(metaLines, ":"));
    % Parse key and value by splitting at the first colon
    keys = strings(1,0);
    vals = strings(1,0);
    for k = 1:numel(metaLines)
        
        % split at first colon
        parts =  regexp(metaLines(k),':','split','once'); % Splits the line at first ":"
        key = strtrim(parts(1)); % First part
        value = ""; % preallocate, so that if the value doesnt exist, it will still be saved
        if numel(parts) > 1
            value = strtrim(parts(2));    % value may contain additional ':' but split limited
        end
        if key == ""
            continue
        end
        keys(end+1) = key; 
        vals(end+1) = value; 
    end
    
    % Make unique, valid MATLAB variable names from keys (preserve order)
    varNames = matlab.lang.makeUniqueStrings(matlab.lang.makeValidName(regexprep(keys,'\s+','_')));
    % Build metadata table: one row, many columns (keys -> variables)
    % If a key repeats, take last occurrence (makeUniqueStrings handled name collisions)
    metaStruct = struct();
    for i = 1:numel(varNames)
        % store as string
        metaStruct.(varNames{i}) = vals(i);
    end
    metaTable = struct2table(metaStruct, 'AsArray', true);
    
    % --- Parse data header to produce variable names for numeric block ---
    hdrLine = strtrim(lines(dataHeaderIdx));
    % split header tokens by tabs or two+ spaces
    tokens = regexp(hdrLine, '\t+|\s{2,}', 'split');
    tokens = tokens(~ismissing(tokens) & tokens ~= "");
    % Determine columns per repeated group by finding repeated first token
    firstToken = tokens{1};
    repIdx = find(strcmp(tokens, firstToken));
    if numel(repIdx) >= 2
        colsPerGroup = repIdx(2) - repIdx(1);
    else
        colsPerGroup = numel(tokens);
    end
    % Build sanitized variable names like Time1, V1, I1, P1, Time2, ...
    numGroups = numel(tokens) / colsPerGroup;
    if abs(numGroups - round(numGroups)) > 1e-12
        error("Header tokens do not form equal groups.");
    end
    numGroups = round(numGroups);
    varNamesData = strings(1,numel(tokens));
    
    for g = 1:numGroups
        for c = 1:colsPerGroup
            base = tokens{(g-1)*colsPerGroup + c};
            base = replace(base, ["+","-"], ["plus","minus"]);
            baseClean = regexprep(base, '\s*\[.*\]', '');    % remove units
            baseClean = regexprep(baseClean, '[^\w]', '');   % remove non-word chars
            if baseClean == ""
                baseClean = "Var";
            end
            varNamesData((g-1)*colsPerGroup + c) = baseClean + string(g);
        end
    end
    % Make unique only where needed (unique names stay unchanged)
    varNamesData = matlab.lang.makeUniqueStrings(varNamesData, {}, namelengthmax);
    
    % Make valid MATLAB identifiers
    varNamesData = matlab.lang.makeValidName(varNamesData);
    
    
    
    % --- Read numeric data lines (from dataHeaderIdx+1 to end) ---
    dataLines = lines(dataHeaderIdx+1:end);
    dataText = join(dataLines, newline);
    dataText = char(strrep(dataText, char(9), ' '));     % tabs -> spaces
    dataText = regexprep(dataText, ' +', ' ');           % compress spaces
    nums = sscanf(dataText, '%f');
    nCols = numel(varNamesData);
    if nCols == 0
        error("No data columns detected in header.");
    end
    if mod(numel(nums), nCols) ~= 0
        error("Numeric block size (%d numbers) is not divisible by column count (%d).", numel(nums), nCols);
    end
    nRows = numel(nums)/nCols;
    M = reshape(nums, nCols, nRows).';
    dataTable = array2table(M, 'VariableNames', varNamesData);
end
