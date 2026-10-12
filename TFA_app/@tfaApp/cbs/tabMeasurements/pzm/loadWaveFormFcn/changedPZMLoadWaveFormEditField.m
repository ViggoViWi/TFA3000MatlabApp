function changedPZMLoadWaveFormEditField(app,~,~)
    
    if isempty(char(app.PZMLoadWaveFormEditField.Value))
    
    else
            sendCmdToClient(app,app.tcpTF,"STRING:"+string(app.TabGroup2.SelectedTab.Title)+":para:loadwave", 'value', app.PZMLoadWaveFormEditField.Value);
    end
    
end