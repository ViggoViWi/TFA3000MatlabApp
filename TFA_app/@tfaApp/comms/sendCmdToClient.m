function sendCmdToClient(app,tcpClient, command, opts)
% sendCommandToClient  Write a command (optionally with a value) and read reply.
% resp = sendCommandToClient(tcpClient, command)
% resp = sendCommandToClient(tcpClient, command, value)
% resp = sendCommandToClient(tcpClient, command, value, waitTime)
%
% Inputs:
%  - tcpClient : tcpclient object
%  - command   : char or string (e.g. "STRING:sam:para:area")
%  - value     : optional numeric / string to append (if omitted no value appended)
%  - waitTime  : optional timeout in seconds (default 1.0)
%
% Output:
%  - resp : response as string ('' if timed out)

    arguments
        app
        tcpClient 
        command   {mustBeTextScalar}
        opts.value     = []
        opts.logClosedl8r = false
    end
    
    value=opts.value;
    waitTime=0.2;
    % Build line
    if isempty(value)
        lineStr = char(command);
    else
        lineStr = sprintf('%s %s', char(command), char(string(value)));
    end

    % Write line (writeline appends terminator configured on tcpClient)
    try
        writeline(tcpClient, lineStr);
        pause(0.01);
        if opts.logClosedl8r
            logTextjustWrite(app,app.logFileID,'%s: %s\n%s\n', datestr(now, 0), 'Line sent to TFA-3000:', lineStr);
        else
            logText(app,'%s: %s\n%s\n', datestr(now, 0), 'Line sent to TFA-3000:', lineStr);
        end
    catch ME
        %uialert(app.UIFigure, "Failed to communicate with tcp client (TFA-3000). "+char(10) + ME.message, 'Error');
        app.connectionStatusChange(false);
    end

    % Try to read reply using readline (blocks until terminator or tcpClient.Timeout)
    % If readline returns empty (timeout) we try a short polling loop until waitTime.
    if (app.echo && app.returnEcho)
        resp = "";
        tstart = tic;
        try
            % Use readline inside a guarded loop so we can enforce waitTime (readline uses tcpClient.Timeout)
            while toc(tstart) < waitTime
                % If terminator-based reply is expected, try readline but wrap so errors don't abort
                try
                    r = readline(tcpClient);    % blocks until terminator or internal Timeout
                    if ~isempty(r)
                        resp = r;
                        disp(resp)
                        return
                    end
                catch
                    % If readline throws (e.g. timeout), fall back to polling raw bytes
                    % Poll NumBytesAvailable
                    if tcpClient.NumBytesAvailable > 0
                        bytes = read(tcpClient, tcpClient.NumBytesAvailable);
                        resp = string(char(bytes(:)'));
                        return
                    end
                end
                pause(0.01)
            end
        catch ME
            %uialert(app.UIFigure, "Failed to read from tcp client (TFA-3000). "+char(10) + ME.message, 'Error');
        end
    end
end

