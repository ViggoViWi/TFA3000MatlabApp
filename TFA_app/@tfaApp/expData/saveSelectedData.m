function saveSelectedData(app,src,~)
    if src == app.DASaveButton
        selectedData = app.DAListBox.Value;
        index = selectedData;
        inputUINT8orString = app.dataBuffer{index};
        if class(inputUINT8orString)=="uint8"
            asciidata=string(char(inputUINT8orString));
        elseif class(inputUINT8orString)=="string" ||class(inputUINT8orString)=="char" 
            asciidata=string(inputUINT8orString);
        end
        if startsWith(asciidata, "STRING:IDLESTRING:")
            asciidata = regexprep(asciidata, '^STRING:IDLESTRING:', '');
        end
        if startsWith(asciidata, "STRING:")
            asciidata = regexprep(asciidata, '^STRING:', '');
        end
        [filename, pathname] = uiputfile('*.dat', 'Save selected data as .dat','@myOwnApp_refr\expData');
        if isequal(filename,0)
            % User canceled
            return;
        end
        
        fullfileName = fullfile(pathname, filename);
        fid = fopen(fullfileName, 'w');
        if fid == -1
            error('Unable to open file for writing: %s', fullfileName);
        end
        fprintf(fid, '%s\n', asciidata);  % write string with newline
        fclose(fid);
    elseif src == app.DASaveAllButton
        % Choose a folder
        folderPath = uigetdir(fullfile(pwd,"@myOwnApp_refr","expData"), 'Select folder to save all data');
        if isequal(folderPath, 0)
            return; % user cancelled
        end

        % Use the last folder name (not full path) as prefix
        [~, folderName] = fileparts(folderPath);
        

        % Get all items from the listbox (assumes Items is a cell array or string array)
        items = app.DAListBox.Items;
        if isempty(items)
            return;
        end

        % Loop and write each item to a separate file
        for k = 1:numel(items)
            itemName = items{k};
            selectedData = app.DAListBox.ItemsData{k};
            index = selectedData;
            uint8Data = app.dataBuffer{index};
            asciidata = char(uint8Data);
            if startsWith(asciidata, "STRING:IDLESTRING:")
                asciidata = regexprep(asciidata, '^STRING:IDLESTRING:', '');
            end
            if startsWith(asciidata, "STRING:")
                asciidata = regexprep(asciidata, '^STRING:', '');
            end
            % Remove characters invalid on Windows and many filesystems
            itemName = regexprep(itemName, '[\/\\:\*\?"<>\|]', '');
            % Replace remaining non-alphanumeric runs with underscore
            itemName = regexprep(itemName, '[^A-Za-z0-9]+', '_');
            % Trim leading/trailing underscores
            itemName = regexprep(itemName, '^_+|_+$', '');

            % Build filename as FolderName_ItemName.dat
            outName = sprintf('%s_%s.dat', folderName, itemName);
            outPath = fullfile(folderPath, outName);

            if exist(outPath, 'file')
                idx = 1;
                newName = sprintf('%s_%s_%d.dat', folderName, itemName, idx);
                newPath = fullfile(folderPath, newName);
                while exist(newPath, 'file')
                    idx = idx + 1;
                    newName = sprintf('%s_%s_%d.dat', folderName, itemName, idx);
                    newPath = fullfile(folderPath, newName);
                end
                outPath = newPath;
            end

            % Open and write (assumes item text is the data to save)
            fid = fopen(outPath, 'w');
            if fid == -1
                warning('Could not open file for writing: %s', outPath);
                continue;
            end
            % If the ListBox item stores the data string directly:
            fprintf(fid, '%s\n', char(asciidata));
            fclose(fid);
        end
    end
end