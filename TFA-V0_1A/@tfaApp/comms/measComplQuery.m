function measComplete=measComplQuery(app,src)
        maxWait = 60;
        waitStep = 1;
        elapsed = 0;
        measComplete = false;
        updateMeasRunningStatus(app,src,~measComplete);
        if app.echo % If I dont program with connection to the TF i need a dummy
            stopIDX=1;
            sendCmdToClient(app, app.tcpTF, "STRING:start");
            for i=1:stopIDX
                disp("Fake Status: STRING:ACTIVE");
                pause(0.005);
                if ~app.measRunning
                        disp("Measurement is not running");
                        updateMeasRunningStatus(app,src,false);
                        break
                end
                if i==stopIDX
                    disp("Fake Status: STRING:IDLE");
                end
            end
        else
            try
                sendCmdToClient(app,app.tcpTF, "STRING:start");
                pause(1)
                while elapsed < maxWait
                    if ~app.measRunning
                        disp("Measurement is not running");
                        updateMeasRunningStatus(app,src,false);
                        break
                    end
                    try
                        sendCmdToClient(app,app.tcpTF, "STRING:STATU?"); 
                        statusResp = read(app.tcpTF);
                        if ~ischar(statusResp) && ~isstring(statusResp)
                            statusResp = char(statusResp);
                        end
                        statusResp = strtrim(statusResp);

                        if ~isempty(statusResp) && contains(statusResp, 'IDLE')
                            measComplete = true;
                            break;
                        end
                    catch ME_status
                        disp(['Status query error: ' ME_status.message]);
                    end
                    pause(waitStep);
                    elapsed = elapsed + waitStep;
                end
            catch ME_stat_main
                uialert(app.UIFigure, sprintf('Status query block error: %s', ME_stat_main.message), 'Error');
            end
        end
        if measComplete || app.echo
            disp('Measurement complete.');
            updateMeasRunningStatus(app,src,~measComplete);
        else
            return;
        end
end