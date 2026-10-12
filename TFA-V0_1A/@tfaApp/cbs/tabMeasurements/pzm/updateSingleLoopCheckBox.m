function updateSingleLoopCheckBox(app,~,~)
    if strcmp(string(app.TabGroup2.SelectedTab.Title),"PZM")
        if app.PZMSingleLoopCheckBox.Value
            sendCmdToClient(app,app.tcpTF, "STRING:para:PZM:single 1");
        else 
            sendCmdToClient(app,app.tcpTF, "STRING:para:PZM:single 0");
        end
    end
end