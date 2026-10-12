function SKStartStopBtn(app,~,~)
    if ~app.measRunning
        app.measRunning = true;
        app.measStopped = false;
        app.SKStartMeasButton.Text = 'STOP MEASUREMENT';  
        SKStartMeas(app,[],[]);
    elseif app.measRunning
        app.measStopped = true;
        app.measRunning = false;
        app.SKStartMeasButton.Text = 'Start SKM';   
        assignin("base","app",app)
        sendCmdToClient(app,app.tcpTF,"STRING:stop",'logClosedl8r',true);
    end
end
