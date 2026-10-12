function addToLog(app,text)
    for idx = 1:numel(text)
        addLogLines = text;
        addLogLine = addLogLines{idx};
        logText(app,'%s: %s\n', datestr(now, 0), addLogLine);
    end
    app.AddtoLogTextArea.Value = "";
end
