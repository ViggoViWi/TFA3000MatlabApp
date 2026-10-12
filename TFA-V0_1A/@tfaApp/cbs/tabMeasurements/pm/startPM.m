function startPM(app,src,~)
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
    if src == app.PMStartMeasButton
        updateMeasRunningStatus(app,src,true)
        try
            paras=["WAV","MODE","PULSESEQUENCE","WAM","WPU","WRI","READDELAY","AMP","RRI","DELAYT","CURR"];
            wav                 =string(app.PMWaveformDropDown.Value);
            mode                = string(app.PMMode.Value);
            pulsese             =string(app.PMSeq);
            wam                     =string(app.PMwamEditField.Value);
            [wpu,app.PMwpuEditField.Value,app.PMwpuUnit.Text]=convertSeconds(app.PMwpuEditField.Value,app.PMwpuUnit.Text);
            wpu = string(wpu);
            [wri,app.PMwriEditField.Value,app.PMwriUnit.Text]=convertSeconds(app.PMwriEditField.Value,app.PMwriUnit.Text);
            wri = string(wri);
            [readdelay,app.PMdel2readEditField.Value,app.PMdel2readUnit.Text]=convertSeconds(app.PMdel2readEditField.Value,app.PMdel2readUnit.Text);
            readdelay = string(readdelay);
            amp                 =string(app.PMampEditField.Value);
            [rri,app.PMrriEditField.Value,app.PMrriUnit.Text]=convertSeconds(app.PMrriEditField.Value,app.PMrriUnit.Text);
            rri= string(rri);
            [delayt,app.PMdelaytEditField.Value,app.PMdelaytUnit.Text]=convertSeconds(app.PMdelaytEditField.Value,app.PMdelaytUnit.Text);
            delayt = string(delayt);
            curr                =string(app.PMCuRangeDropDown.Value);
            disp(curr)
            
            
            values={...
                wav                     ,...
                mode                    ,...
                pulsese                 ,...
                wam                     ,...
                wpu                     ,...
                wri                     ,...
                readdelay               ,...
                amp                     ,...
                rri                     ,...
                delayt                  ,...
                curr                    };
            
            string2Send = sprintf("STRING:para:PM:%s %s; %s %s; %s %s; %s %s; %s %s; %s %s; %s %s; %s %s; %s %s; %s %s; %s %s",...
            paras(1),string(values{1}),...
            paras(2),string(values{2}),...
            paras(3),string(values{3}),...
            paras(4),string(values{4}),...
            paras(5),string(values{5}),...
            paras(6),string(values{6}),...
            paras(7),string(values{7}),...
            paras(8),string(values{8}),...
            paras(9),string(values{9}),...
            paras(10),string(values{10}),...
            paras(11),string(values{11}));
        
            write(app.tcpTF, string2Send);
           
            w84TF(app);
            sendCmdToClient(app,app.tcpTF, ...
                "STRING:mode PM" + newline + ...
                "STRING:file:SELEC pm"+ newline);
        % Start Measuring:
        sendCmdToClient(app,app.tcpTF,"STRING:start ",'logClosedl8r',true);
        % Wait until TFA is in IDLE
        isIdle = false;
        while ~isIdle %
            isIdle = w84Measurement(app);
            if isIdle
                break
            end
            disp("Measurement still ongoing. Wait again until TFA is in Idle.");
        end
            pause(4)
            measCounts=getMeasCounts(app);
            write(app.tcpTF,sprintf("STRING:measurem:selec pm, %s",string(measCounts)));
            w84TF(app);
            pause(0.05)
            [~,uint8Data,~]=getASCIIdata(app);
            pause(0.5)
            dataReceived(app,uint8Data,'mode','pm');
            w84TF(app);
            updateMeasRunningStatus(app,src,false)
        catch me 
            updateMeasRunningStatus(app,src,false)
            error(me.message)
        end
    end
end