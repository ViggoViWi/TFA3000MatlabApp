function statusIDLE = tcpTFw84TF(tcpTF)
        maxWait = 2;
        waitStep = .5;
        elapsed = 0;
        statusIDLE = false;
        while elapsed < maxWait
            try
                write(tcpTF, "STRING:STATU?"); 
                statusResp = read(tcpTF);
                if ~ischar(statusResp) && ~isstring(statusResp)
                    statusResp = char(statusResp);
                end
                statusResp = strtrim(statusResp);
                
                if ~isempty(statusResp) && contains(statusResp, 'IDLE')
                    statusIDLE = true;
                    break;
                end
            catch ME_status
                disp(['Status query error: ' ME_status.message]);
            end
                pause(waitStep);
                elapsed = elapsed + waitStep;
        end
end