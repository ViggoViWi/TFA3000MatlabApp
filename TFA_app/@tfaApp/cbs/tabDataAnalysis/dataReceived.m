function dataReceived(app,uint8Data,opts)
    arguments
        app
        uint8Data
        opts.cycleCounter = -1;
        opts.mode = '';
    end
    if ~(opts.cycleCounter==-1) 
        cC=opts.cycleCounter;
    end
    if ~isempty(opts.mode)
        mode = opts.mode;
    end
    % get current items as string array (works if already string array or char cell)
    
    items = string(app.DAListBox.Items);      % ensures a string array
    % if isempty(dataTable)
    %         items(end+1) = sprintf("NoDataCycle %d", cC);  % append one element (keeps row/col shape)
    % else
    % 
    %     items(end+1) = sprintf("Cycle %d", cC);  % append one element (keeps row/col shape)
    % end
    
    if strcmp(mode,'atm')
        items(end+1) = sprintf("Cycle %d", cC);  % append one element (keeps row/col shape)
    elseif strcmp(mode,'pzm')|| strcmp(mode,'pm')
        items(end+1) = "dummy";
    elseif contains(mode,'skm')
        items(end+1) = "dummy";
    end
    
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
    app.DAListBox.ItemsData{end+1} = dataID;
    app.dataBuffer{dataID}=uint8Data;
    items = items(:)';                        % ensure 1-by-N row
    [metaTable, ~] = processData(uint8Data);
    if strcmp(mode,'pzm') 
        items(end) = metaTable.SampleName+" pzm";
    elseif strcmp(mode,'pm')
        items(end) = metaTable.SampleName+" pm";
    elseif contains(mode,'skm')
        vns = metaTable.Properties.VariableNames;
        mask = contains(vns, 'Write') & contains(vns, 'Pulse') & contains(vns, 'Time') & ~contains(vns, 'Rise');
        varName = vns{mask};
        pulseWidth = metaTable.(varName);
        if strcmp(mode,'skmSet')
            items(end) = sprintf("Set: %.1e", double(pulseWidth));
        elseif strcmp(mode,'skmSmAmp')
            items(end) = sprintf("Small Amp: %.1e", double(pulseWidth));
        elseif strcmp(mode,'skmReset')
            items(end) = sprintf("Reset: %.1e", double(pulseWidth));
        end
    end
    app.DAListBox.Items = items;
end