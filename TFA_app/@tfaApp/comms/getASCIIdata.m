function [asciiData,uint8Data, received] = getASCIIdata(app)
%RETRIEVEASCIIDATA Summary of this function goes here
%   Detailed explanation goes here
if ~app.echo
    count = 0;
    err_count = 0;
    max_tries = 3;
    while count == err_count && err_count < max_tries
        try
            app.tcpTF.Timeout = 3;  
            sendCmdToClient(app,app.tcpTF, "STRING:MEASUREM:DATA?");
            maxWait = 5;  % Maximum seconds to wait for data
            waitStep = 0.25;
            elapsed = 0;
            asciiData = "";
            uint8Data = uint8(0);
            pause(0.05)
            while elapsed < maxWait
                uint8Data = read(app.tcpTF);
                asciiData = char(uint8Data);
                idcs = strfind(asciiData, 'STRING:');
                lastIdx = idcs(end); 
                asciiData2 = asciiData(lastIdx:end); 
                if ~isempty(asciiData) && (~contains(asciiData2,"STRING:IDLE") && ~contains(asciiData2,"STRING:ACTIVE")&& ~contains(asciiData2,"STRING:Remote access:") )
                    pause(0.333)
                    break;
                end
                pause(waitStep);
                elapsed = elapsed + waitStep;
                received = false;
            end
            
            if ~ischar(uint8Data) && ~isstring(uint8Data)  
                asciiData = char(asciiData);
            end
            asciiData = strtrim(asciiData);
            [~,~]=processData(uint8Data);
            received = true;
            disp('Received ASCII Data:');
        catch ME 
            if contains(ME.message,"Could not find data header starting with 'Measurement Status'")||contains(ME.message,"Numeric block size")||contains(ME.message,"Array indices must be positive")
                err_count = err_count+1;
            else
                error(ME.message);
            end
            warning("Try %d: %s",count+1,ME.message);
            received = false;
        end
        count = count +1;
        pause(0.2)
    end
else
    % Construct an absolute path (example: place file next to the app)
    filePath = fullfile(pwd, '@myOwnApp_refr', 'expData','TestReads', 'PMDataPUNDuint8.txt');
    
    % Try open and check errors
    [fid, msg] = fopen(filePath, 'r', 'n', 'UTF-8');
    if fid == -1
        error('Failed to open file: %s\nMATLAB message: %s', filePath, msg);
    end
    
    % Safe read and close
    txtChar = fread(fid, '*char')';
    fclose(fid);
    uint8Data = uint8(double(split(string(txtChar))))';
    asciiData = char(uint8Data);
    received = true;
end
end