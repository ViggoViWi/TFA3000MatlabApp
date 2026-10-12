function statusIDLE = w84TF(app,src)
        maxWait = 2;
        waitStep = .5;
        elapsed = 0;
        statusIDLE = false;
        if app.echo % If I dont program with connection to the TF i need a dummy
            stopIDX=1;
            for i=1:stopIDX
                
                pause(0.005);
                if i==stopIDX
                    
                end
            end
        else
            while elapsed < maxWait
                try
                    sendCmdToClient(app,app.tcpTF, "STRING:STATU?"); 
                    statusResp = read(app.tcpTF);
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
end