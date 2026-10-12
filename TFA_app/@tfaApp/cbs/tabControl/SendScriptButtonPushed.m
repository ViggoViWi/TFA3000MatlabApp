function SendScriptButtonPushed(app, event)
    if isempty(app.tcpTF) || ~isa(app.tcpTF, 'tcpclient') %WORK
        uialert(app.UIFigure, 'Not connected to TFA.', 'Error');
        app.connectionStatusChange(false);
        return
    else
    end
    if ~app.connectionStatus
        return
    end
    for idx = 1:numel(app.Skript.Value)
        scriptLines = app.Skript.Value;
        lineStr = scriptLines{idx}; % string scalar
        sendCmdToClient(app,app.tcpTF, lineStr);
    end
end
