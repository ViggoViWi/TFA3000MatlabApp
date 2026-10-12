function clearData(app,src,~)

    if src == app.DAClearButton
        if isempty(app.DAListBox.Items)
            return
        end
        items = app.DAListBox.Items;
        dataIDs  = app.DAListBox.ItemsData;

        val   = app.DAListBox.Value;

        if ~isempty(dataIDs)
            idx = find(cellfun(@(x) isequal(x,val), dataIDs));
        else
            idx = find(strcmp(items, val), 1);
        end

        if isempty(idx)
            return
        end
        IDtoclear = dataIDs{idx};
        
        items(idx) = [];
        dataIDs(idx) = [];
        app.DAListBox.Items = items;
        app.DAListBox.ItemsData = dataIDs;
        app.dataBuffer{IDtoclear} = []; 

        if isempty(app.DAListBox.Items)
            app.DAListBox.Items = {};
            app.DAListBox.ItemsData = {};
            app.DAListBox.Value = {};
            app.dataBuffer = cell(1,1000);
            app.DAUITable.Data = table();
            app.DAUITable2.Data = table();
            app.DAUITable.ColumnName = {};
            app.DAUITable2.ColumnName = {};
            app.DADropDown_x1.Items = {};
            app.DADropDown_y1.Items = {};
            app.DADropDown_y2.Items = {};
            updateAxis(app,[],[]);
            app.DAUIAxes.Visible ="off";
            

        else
            if ~all(cellfun(@isempty, app.DAListBox.ItemsData))
                if idx<numel(app.DAListBox.Items)
                    app.DAListBox.Value = app.DAListBox.ItemsData{idx};
                elseif idx==numel(app.DAListBox.Items)
                    app.DAListBox.Value = app.DAListBox.ItemsData{idx};
                elseif idx>numel(app.DAListBox.Items)
                    app.DAListBox.Value = app.DAListBox.ItemsData{idx-1};
                end
                
                index = app.DAListBox.Value;
                dataFromBuffer = app.dataBuffer{index};
                [metaTable, dataTable] = processData(dataFromBuffer);
                app.DAUITable.Data = metaTable;
                app.DAUITable2.Data = dataTable;
                app.DAUITable.ColumnName = cellstr(metaTable.Properties.VariableNames);
                app.DAUITable2.ColumnName = cellstr(dataTable.Properties.VariableNames);
                updateAxis(app,[],[]);
            else
                error("Something went wrong")
                
            end
        end

    elseif src == app.DAClearAllButton
        app.DAListBox.Items = {};
        app.dataBuffer = cell(1,1000); 
        app.DAListBox.ItemsData = {};
        app.DAListBox.Value = {};
        app.DAUITable.Data = table();
        app.DAUITable2.Data = table();
        app.DAUITable.ColumnName = {};
        app.DAUITable2.ColumnName = {};
        app.DADropDown_x1.Items = {};
        app.DADropDown_y1.Items = {};
        app.DADropDown_y2.Items = {};
        updateAxis(app,[],[]);
        app.DAUIAxes.Visible ="off";
    end
end