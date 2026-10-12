function updateThickness(app,src,event)
    sendCmdToClient(app,app.tcpTF, "STRING:sam:para:thickness", 'value',app.ThicknessEditField.Value);
    focus(app.PadAreaEditField)
end