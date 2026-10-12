function updatePMWPu(app,~,~)
    [app.PMwpu,app.PMwpuEditField.Value,app.PMwpuUnit.Text]=convertSeconds(app.PMwpuEditField.Value,app.PMwpuUnit.Text);
    sendCmdToClient(app,app.tcpTF, "STRING:para:PM:wpu", 'value',app.PMwpu);
end