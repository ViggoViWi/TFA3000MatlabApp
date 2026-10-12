function NewStatus = connectionStatusChange(app, NewStatus)
    app.connectionStatus = NewStatus;
    if NewStatus
        app.ConnectButton.Visible = "off";
        app.StatusLabel.Visible = "on";
        updateStatusLamps(app);
        app.Skript.BackgroundColor = [1 1 1];
        app.Skript.Editable = "on";
        app.SendscripttoTFA300Button.Enable = "on";
    else
        app.ConnectButton.Visible = "on";
        app.StatusLabel.Visible = "off";
        updateStatusLamps(app);
        app.Skript.BackgroundColor = [0.651 0.651 0.651];
        app.Skript.Editable = "off";
        app.SendscripttoTFA300Button.Enable = "off";
    end
end
