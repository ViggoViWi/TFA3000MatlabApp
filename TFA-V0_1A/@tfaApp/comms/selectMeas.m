function selectMeas(app,mode,MeasID)
    cmd = sprintf("STRING:measurement:selec %s, %s",mode,string(MeasID));
    writeline(app.tcpTF, cmd);
end