function updatePMWAm(app,~,~)
    sendCmdToClient(app,app.tcpTF, "STRING:para:PM:wam", 'value',app.PMwamEditField.Value);
end