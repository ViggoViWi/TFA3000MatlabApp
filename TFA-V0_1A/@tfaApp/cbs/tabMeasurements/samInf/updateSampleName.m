function updateSampleName(app,src,event)
    sendCmdToClient(app,app.tcpTF, "STRING:sam:para:name", 'value',app.SampleNameEditField.Value);
    focus(app.ThicknessEditField)
end