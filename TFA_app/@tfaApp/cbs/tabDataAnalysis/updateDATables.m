function updateDATables(app,src,~)
    index = src.Value;
    itemData=app.dataBuffer{index};
    [metaTable, dataTable] = processData(itemData);
    app.DAUITable.Data = metaTable;
    app.DAUITable2.Data = dataTable;
    app.DAUITable.ColumnName = cellstr(metaTable.Properties.VariableNames);
    app.DAUITable2.ColumnName = cellstr(dataTable.Properties.VariableNames);
    
    app.DADropDown_x1.Items = dataTable.Properties.VariableNames;
    app.DADropDown_y1.Items = dataTable.Properties.VariableNames;
    app.DADropDown_y2.Items = dataTable.Properties.VariableNames;
    updateAxis(app,[],[]);
end