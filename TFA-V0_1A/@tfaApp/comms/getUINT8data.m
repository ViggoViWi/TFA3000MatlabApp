function [asciiData, received] = getUINT8data(app)
%RETRIEVEASCIIDATA Summary of this function goes here
%   Detailed explanation goes here
if ~app.echo
    try
        app.tcpTF.Timeout = 2;  
        sendCmdToClient(app,app.tcpTF, "STRING:MEASUREM:DATA?");
        maxWait = 5;  % Maximum seconds to wait for data
        waitStep = 1;
        elapsed = 0;
        uint8Data = ;
        while elapsed < maxWait
            asciiData = read(app.tcpTF);
            if strcmp(asciiData,"IDLE")
                error("Asked for data and received IDLE")
            end
            if ~isempty(asciiData) 
                received = false;
                pause(0.333)
                break;
            end
            pause(waitStep);
            elapsed = elapsed + waitStep;
        end
        
        if ~ischar(asciiData) && ~isstring(asciiData)  
            asciiData = char(asciiData);
        end
        asciiData = strtrim(asciiData);
        received = true;
        disp('Received ASCII Data:');
    catch ME
        warning('Retrieving ASCII Data failed: %s', ME.message);
        received = false;
        return;
    end
else
    % Construct an absolute path (example: place file next to the app)
    filePath = fullfile(pwd, '@myOwnApp_refr', 'expData','TestReads', 'PMDataPUND.txt');
    
    % Try open and check errors
    [fid, msg] = fopen(filePath, 'r', 'n', 'UTF-8');
    if fid == -1
        error('Failed to open file: %s\nMATLAB message: %s', filePath, msg);
    end
    
    % Safe read and close
    txtChar = fread(fid, '*char')';
    fclose(fid);
    asciiData = string(txtChar);
    
    received = true;
end
end