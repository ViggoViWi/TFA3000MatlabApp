function [asciiData,uint8Data, received] = tcpTFgetASCIIdata(tcpTF)
%RETRIEVEASCIIDATA Summary of this function goes here
%   Detailed explanation goes here

try
    tcpTF.Timeout = 5;  
    write(tcpTF, "STRING:MEASUREM:DATA?");
    maxWait = 5;  % Maximum seconds to wait for data
    waitStep = 1;
    elapsed = 0;
    asciiData = "";
    uint8Data = uint8(0);
    pause(0.05)
    while elapsed < maxWait
        uint8Data = read(tcpTF);
        asciiData = char(uint8Data);
        idcs = strfind(asciiData, 'STRING:');
        lastIdx = idcs(end); 
        asciiData2 = asciiData(lastIdx:end); 
        uint8Data = unicode2native(asciiData2, 'UTF-8');
        asciiData = asciiData2;
        prefix = "STRING:";
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
    received = true;
    disp('Received ASCII Data:');
catch ME
    error('Retrieving ASCII Data failed: %s', ME.message);
    received = false;
    return;
end
end