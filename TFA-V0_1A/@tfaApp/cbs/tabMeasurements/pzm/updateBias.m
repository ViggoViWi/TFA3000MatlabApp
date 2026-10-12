function updateBias(app,~,~)
    mode = string(app.TabGroup2.SelectedTab.Title);
    sendCmdToClient(app,app.tcpTF, "STRING:para:"+mode+":bia", 'value',app.PZMBiasEditField.Value);
    focus(app.PZMDelayEditField);
end