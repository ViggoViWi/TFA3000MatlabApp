function updateMeasRunningStatus(app,src,bool)
    if bool
        app.measRunning = bool;
        if src==app.ATMStartMeasButton
            app.ATMStartMeasButton.Text = "Stop ATM";
        elseif src==app.PZMStartMeasButton
            app.PZMStartMeasButton.Enable ="off";
        elseif src==app.PMStartMeasButton
             app.PMStartMeasButton.Enable ="off";
        end
    else
        app.measRunning = bool;
        if src==app.ATMStartMeasButton
            app.ATMStartMeasButton.Text = "Start ATM";
        elseif src==app.PZMStartMeasButton
            app.PZMStartMeasButton.Enable ="on";
        elseif src==app.PMStartMeasButton
            app.PMStartMeasButton.Enable ="on";
        end
    end
end
