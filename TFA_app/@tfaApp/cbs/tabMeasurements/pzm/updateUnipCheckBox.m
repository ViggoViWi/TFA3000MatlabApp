function updateUnipCheckBox(app,~,~)
    mode = string(app.TabGroup2.SelectedTab.Title);
    if app.PZMUnipCheckBox.Value
        sendCmdToClient(app,app.tcpTF, "STRING:para:"+mode+":unip 1");
    else 
        sendCmdToClient(app,app.tcpTF, "STRING:para:"+mode+":unip 0");
    end
end
% If Unip set true, then prepol can only be disabled and non-switching.
% If Unio set true, then single loop check box is set true AND will be not
% be editable (greyed out).
