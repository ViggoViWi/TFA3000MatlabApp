% This function writes to the log file. The logfile is already open and
% does not have to be closed.
function logTextjustWrite(app,logFileID, formatSpec, varargin)
    if logFileID == -1
        error('Cannot open log file.');
    end

    fprintf(logFileID, formatSpec, varargin{:});
    app.LogsTextArea.Value(end+1) = {sprintf(formatSpec, varargin{:})};
    scroll(app.LogsTextArea, "bottom");
end
