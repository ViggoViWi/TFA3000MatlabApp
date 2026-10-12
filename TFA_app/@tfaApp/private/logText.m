function logText(app, formatSpec, varargin)
    fileID = fopen(app.logPath, 'a');
    if fileID == -1
        error('Cannot open log file.');
    end

    fprintf(fileID, formatSpec, varargin{:});
    fclose(fileID);
    app.LogsTextArea.Value(end+1) = {sprintf(formatSpec, varargin{:})};
    scroll(app.LogsTextArea, "bottom");
end
