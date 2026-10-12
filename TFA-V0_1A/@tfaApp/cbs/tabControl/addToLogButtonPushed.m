function addToLogButtonPushed(app, event)
    for idx = 1:numel(app.AddtoLogTextArea.Value)
        addLogLines = app.AddtoLogTextArea.Value;
        addLogLine = addLogLines{idx};
        logText(app,'%s: %s\n', datestr(now, 0), addLogLine);
    end
    app.AddtoLogTextArea.Value = "";
end
