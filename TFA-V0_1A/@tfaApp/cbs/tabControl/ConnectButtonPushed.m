function ConnectButtonPushed(app, event)
    if ~app.connectionStatus
        logText(app,'%s: %s\n', datestr(now, 0), "Connecting to TFA...");
        pause(0.04);
        ip = app.IPv4AdressEditField.Value;
        port = app.PortEditField.Value;
        if app.echo
            echotcpip('off');
            pause(0.1)
            echotcpip('on',2000)
        end
        try
            app.tcpTF = tcpclient(ip, port); 
            logText(app,'%s: %s\n', datestr(now, 0), "Connection to TFA successful");
            app.connectionStatus = app.connectionStatusChange(true);
            pause(0.05);
            assignin("base","tcpTF",app.tcpTF);
            return
        catch ME
            logText(app,'%s: %s\n%s\n', datestr(now, 0), "Connections Failed", ME.message);
            app.connectionStatus = app.connectionStatusChange(false);
            pause(0.05);
            return
        end
    else
        delete(app.tcpTF);
        app.connectionStatus = app.connectionStatusChange(false);
        pause(0.05);
end
