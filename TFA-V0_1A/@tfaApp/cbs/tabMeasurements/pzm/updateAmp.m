function updateAmp(app,~,~)
    mode = string(app.TabGroup2.SelectedTab.Title);
    sendCmdToClient(app,app.tcpTF, "STRING:para:"+mode+":amp", 'value',app.PZMAmpEditField.Value);
    focus(app.PZMBiasEditField);
end
% AMp must be between +-126 with the HVA