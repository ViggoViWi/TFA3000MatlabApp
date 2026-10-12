function updateDelay(app,~,~)
    mode = string(app.TabGroup2.SelectedTab.Title);
    if strcmp(mode,"PZM")
        if ge(app.PZMDelayEditField.Value,50) && le(app.PZMDelayEditField.Value,1000000)
            sendCmdToClient(app,app.tcpTF, "STRING:para:"+mode+":delayt", 'value',app.PZMDelayEditField.Value./1000);
            focus(app.PZMRepsEditField);
        elseif app.PZMDelayEditField.Value==0
            if ge(app.PZMRepsEditField.Value,2)
                sendCmdToClient(app,app.tcpTF, "STRING:para:"+mode+":delayt", 'value',app.PZMDelayEditField.Value./1000);
                focus(app.PZMRepsEditField);
            elseif app.PZMRepsEditField.Value==1
                sendCmdToClient(app,app.tcpTF, "STRING:para:"+mode+":delayt", 'value',50./1000);
                app.PZMDelayEditField.Value = 50;
                uialert(app.UIFigure, 'For delay time = 0, repetition must be >1.', 'Error');
            else % Should never happen
                
            end
        elseif app.PZMDelayEditField.Value<50
            uialert(app.UIFigure, 'Delay time must be between 50 ms and 1000s, or exactly 0, if repetitions >2.', 'Error');
            sendCmdToClient(app,app.tcpTF, "STRING:para:"+mode+":delayt", 'value',50./1000);
            app.PZMDelayEditField.Value = 50;
        elseif app.PZMDelayEditField.Value>1000000
            uialert(app.UIFigure, 'Delay time must be between 50 ms and 1000s, or exactly 0, if repetitions >2.', 'Error');
            sendCmdToClient(app, app.tcpTF, "STRING:para:" + mode + ":delayt", 'value', 1000000./1000);
            app.PZMDelayEditField.Value = 1000000;
        end

    % OTHER MODES....
    end
end
% Changable only if single loop true && prepol switching or non-switching (goes to 1s if changed
% back to disabled). 