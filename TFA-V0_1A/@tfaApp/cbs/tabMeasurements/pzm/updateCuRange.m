function updateCuRange(app,src,~)
   mode = string(app.TabGroup2.SelectedTab.Title);
if src==app.PZMCuRangeDropDown
    if ~(app.PZMCuRangeDropDown.Value==-1)
        sendCmdToClient(app,app.tcpTF, "STRING:para:PZM:curr", 'value',app.PZMCuRangeDropDown.Value);
    else
        sendCmdToClient(app,app.tcpTF, "STRING:para:PZM:curr");
    end
elseif src==app.PMCuRangeDropDown
    if ~(app.PMCuRangeDropDown.Value==-1)
        sendCmdToClient(app,app.tcpTF, "STRING:para:PM:curr", 'value',app.PMCuRangeDropDown.Value);
    else
        sendCmdToClient(app,app.tcpTF, "STRING:para:PM:curr Auto");
    end
end