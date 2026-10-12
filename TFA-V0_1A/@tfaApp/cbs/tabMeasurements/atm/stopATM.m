function stopATM(app,src,~)
    updateMeasRunningStatus(app,src, false);
    sendCmdToClient(app,app.tcpTF, "STRING:STOP");
end