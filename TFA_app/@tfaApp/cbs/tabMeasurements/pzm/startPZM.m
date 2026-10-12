function startPZM(app,src,~)
    function         isIdle= w84Measurement(app)
                maxWait = 5;
                waitStep = .25;
                elapsed = 0;
                isIdle = false;
                while elapsed < maxWait
                    try
                        write(app.tcpTF, "STRING:STATU?"); 
                        statusResp = read(app.tcpTF);
                        if ~ischar(statusResp) && ~isstring(statusResp)
                            statusResp = char(statusResp);
                        end
                        idcs = strfind(statusResp, 'STRING:');
                        lastIdx = idcs(end);
                        lastResp = statusResp(lastIdx:end);
                        if ~isempty(lastResp) && contains(lastResp, 'IDLE')
                            isIdle = true;
                            break;
                        end
                    catch ME_status
                        disp(['Status query error: ' ME_status.message]);
                    end
                        pause(waitStep);
                        elapsed = elapsed + waitStep;
                end
        end
    if src == app.PZMStartMeasButton
        try
            paras=["FRE","AMP","REPET","WAV","DELAYT","SIN","PREP","UNIP","BIA","CUR"];
            values={...
            app.PZMFreqEditField.Value*1000,...
            app.PZMAmpEditField.Value,...
            app.PZMRepsEditField.Value,...
            app.PZMWaveFormDropDown.Value,...
            app.PZMDelayEditField.Value/1000,...
            app.PZMSingleLoopCheckBox.Value,...
            app.PZMPrePolDropDown.Value,...
            app.PZMUnipCheckBox.Value,...
            app.PZMBiasEditField.Value,...
            app.PZMCuRangeDropDown.Value};
            
            string2Send = sprintf("STRING:para:pzm:%s %s; %s %s; %s %s; %s %s; %s %s; %s %s; %s %s; %s %s; %s %s; %s %s",...
            paras(1),string(values{1}),...
            paras(2),string(values{2}),...
            paras(3),string(values{3}),...
            paras(4),string(values{4}),...
            paras(5),string(values{5}),...
            paras(6),string(values{6}),...
            paras(7),string(values{7}),...
            paras(8),string(values{8}),...
            paras(9),string(values{9}),...
            paras(10),string(values{10}));
        
            write(app.tcpTF, string2Send);
           
            w84TF(app);
            sendCmdToClient(app,app.tcpTF, ...
                "STRING:mode PZM" + newline + ...
                "STRING:file:SELEC pzm"+ newline);
            measComplQuery(app,src);
            pause(1);
            pause(1);
            pause(1);
            pause(0.5);
            w84TF(app);
            measCounts=getMeasCounts(app);
            write(app.tcpTF,sprintf("STRING:measurem:selec pzm, %s",string(measCounts)));
            % fprintf("STRING:measurem:selec pzm, %s",string(measCounts))
            w84TF(app);
            pause(1)
            
            [asciiData,uint8Data,~]=getASCIIdata(app);
            assignin("base","asciiData",asciiData);
            pause(0.05)
            dataReceived(app,uint8Data,'mode','pzm');
            w84TF(app);
            updateMeasRunningStatus(app,src,false)
        catch me
            updateMeasRunningStatus(app,src,false)
            error(me.message)
        end
    end
end