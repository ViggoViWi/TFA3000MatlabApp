function updateStatusLamps(app)
    green = [0.2314 0.6667 0.1961];
    red = [1 0 0];
    if app.connectionStatus
        app.StatusLampControl.Color = green;
        app.StatusButtonUIFig.Icon = fullfile(app.currPWD, 'images', 'connected.png');
        app.StatusButtonUIFig.Tooltip = "Status: Connected";
    else
        app.StatusLampControl.Color = red;
        app.StatusButtonUIFig.Icon = fullfile(app.currPWD, 'images', 'disconnected.png');
        app.StatusButtonUIFig.Tooltip = "Status: Disconnected";
    end
end
