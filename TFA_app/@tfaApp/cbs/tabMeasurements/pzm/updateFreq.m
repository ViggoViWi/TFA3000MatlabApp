function updateFreq(app,~,~)
    mode = string(app.TabGroup2.SelectedTab.Title);
    sendCmdToClient(app,app.tcpTF, "STRING:para:"+mode+":freq", 'value',app.PZMFreqEditField.Value*1000);
    focus(app.PZMAmpEditField);
end