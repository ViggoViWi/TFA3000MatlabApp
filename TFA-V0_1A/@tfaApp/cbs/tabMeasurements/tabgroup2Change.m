function tabgroup2Change(app,src,~)
    if src==app.TabGroup2
        if app.TabGroup2.SelectedTab==app.PZMTab
            sendCmdToClient(app,app.tcpTF, "STRING:mode PZM");
        elseif app.TabGroup2.SelectedTab==app.PMTab
            sendCmdToClient(app,app.tcpTF, "STRING:mode PM");
        end
    end
end