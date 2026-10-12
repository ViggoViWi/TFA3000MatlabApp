function  loadData(app,src,event)
    oldpwd=pwd;
    [filenames, pathname] = uigetfile('*.dat', 'Select a .dat file',".\expData\",'MultiSelect', 'on');
    if (class(filenames)=="cell") 
        numFiles = numel(filenames);
    elseif (class(filenames)=="char") 
        numFiles = 1;
    end
    for f=1:numFiles
        if (class(filenames)=="cell") 
            filename = filenames{f};
        elseif (class(filenames)=="char") 
            filename = filenames;
        end
        if isequal(filename, 0)
            disp('User canceled')
            return
        else
            filePath = fullfile(pathname, filename);
        end
        [fid, msg] = fopen(filePath, 'r', 'n', 'UTF-8');
        if fid == -1
            error('Failed to open file: %s\nMATLAB message: %s', filePath, msg);
        end
        % Safe read and close
        txtChar = fread(fid, '*char')';
        fclose(fid);
        pause(1)
        cd(oldpwd);
        asciiData = string(txtChar);
        
        % Determine if file contains a single table or multiple tables.
        % If "Table 1" appears exactly twice -> treat as single; otherwise multiple.
        occurrences = count(asciiData, "Table 1");
        single = (occurrences <= 2);
        if single
            [meta,~]  = processData(asciiData);
            items = string(app.DAListBox.Items);      % ensures a string array
            sampleName = meta.SampleName;
            if ~isempty(app.DAListBox.ItemsData)
                if ~all(cellfun(@isempty, app.DAListBox.ItemsData)) 
                    IDs = [app.DAListBox.ItemsData{:}];  
                    highestID = max(IDs);                  
                    dataID = highestID+1;
                else
                    dataID=1;
                end
            else
                dataID=1;
            end
            items(end+1) = sprintf("%s", filename);  % append one element (keeps row/col shape)
            items = items(:)';                        % ensure 1-by-N row
            app.DAListBox.Items = items;
            app.DAListBox.ItemsData{end+1} = dataID;
            app.dataBuffer{dataID}=asciiData;
        else
            [~,~,DataString]  = multiTableProcess(asciiData);
            for i=1:numel(DataString)
                [meta,~]=processData(DataString(i));
                items = string(app.DAListBox.Items);      % ensures a string array
                sampleName = meta.SampleName;
                items(end+1) = sprintf("%s", sampleName);  % append one element (keeps row/col shape)
                if ~all(cellfun(@isempty, app.DAListBox.ItemsData))
                    IDs = [app.DAListBox.ItemsData{:}];   
                    highestID = max(IDs);                  
                    dataID = highestID+1;
                else
                    dataID=1;
                end
                items(end+1) = sprintf("%s", sampleName);  % append one element (keeps row/col shape)
                items = items(:)';                        % ensure 1-by-N row
                app.DAListBox.Items = items;
                app.DAListBox.ItemsData{end+1} = dataID;
                app.dataBuffer{dataID}=asciiData;
            end
        end
    end
end