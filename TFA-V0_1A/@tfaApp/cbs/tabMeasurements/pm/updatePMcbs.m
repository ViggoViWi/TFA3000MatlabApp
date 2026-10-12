function updatePMcbs(app,src,~)
    % The callback comes from any of the PMMode dropdown
    if src == app.PMMode
        if src.Value == "PUND"
            app.PMSeqButton1.UserData = -1;
            app.PMSeqButton2.UserData = 1;
            app.PMSeqButton3.UserData = 1;
            app.PMSeqButton4.UserData = -1;
            app.PMSeqButton5.UserData = -1;
            app.PMSeqButton6.UserData = 1;
            app.PMSeqButton7.UserData = 0;
        elseif src.Value == "SS/NS"
            app.PMSeqButton1.UserData = 0;
            app.PMSeqButton2.UserData = 0;
            app.PMSeqButton3.UserData = 1;
            app.PMSeqButton4.UserData = 1;
            app.PMSeqButton5.UserData = 0;
            app.PMSeqButton6.UserData = 0;
            app.PMSeqButton7.UserData = 0;
        elseif src.Value == "SS/S"
            app.PMSeqButton1.UserData = -1;
            app.PMSeqButton2.UserData = 0;
            app.PMSeqButton3.UserData = 1;
            app.PMSeqButton4.UserData = 1;
            app.PMSeqButton5.UserData = 0;
            app.PMSeqButton6.UserData = 0;
            app.PMSeqButton7.UserData = 0;
        elseif src.Value == "OS/NS"
            app.PMSeqButton1.UserData = 1;
            app.PMSeqButton2.UserData = 0;
            app.PMSeqButton3.UserData = 1;
            app.PMSeqButton4.UserData = -1;
            app.PMSeqButton5.UserData = 0;
            app.PMSeqButton6.UserData = 0;
            app.PMSeqButton7.UserData = 0;
        elseif src.Value == "OS/S"
            app.PMSeqButton1.UserData = 0;
            app.PMSeqButton2.UserData = 0;
            app.PMSeqButton3.UserData = 1;
            app.PMSeqButton4.UserData = -1;
            app.PMSeqButton5.UserData = 0;
            app.PMSeqButton6.UserData = 0;
            app.PMSeqButton7.UserData = 0;
        elseif src.Value == "W"
            app.PMSeqButton1.UserData = 1;
            app.PMSeqButton2.UserData = 0;
            app.PMSeqButton3.UserData = 0;
            app.PMSeqButton4.UserData = 0;
            app.PMSeqButton5.UserData = 0;
            app.PMSeqButton6.UserData = 0;
            app.PMSeqButton7.UserData = 0;
        elseif src.Value == "Manual"
            app.PMSeqButton1.UserData = 0;
            app.PMSeqButton2.UserData = 0;
            app.PMSeqButton3.UserData = 0;
            app.PMSeqButton4.UserData = 0;
            app.PMSeqButton5.UserData = 0;
            app.PMSeqButton6.UserData = 0;
            app.PMSeqButton7.UserData = 0;
        end 
        updatePMSeq(app,src,[])
    % The callback comes from any of the PMSeqButtons
    elseif  (src==app.PMSeqButton1) ||...
            (src==app.PMSeqButton2) ||...
            (src==app.PMSeqButton3) ||...
            (src==app.PMSeqButton4) ||...
            (src==app.PMSeqButton5) ||...
            (src==app.PMSeqButton6) ||...
            (src==app.PMSeqButton7)
            if src==app.PMSeqButton1
                if src.UserData == 0
                    src.UserData = 1;
                elseif src.UserData == 1
                    src.UserData = -1;
                elseif src.UserData == -1
                    src.UserData = 0;
                end
            elseif src==app.PMSeqButton2
                if src.UserData == 0
                    src.UserData = 1;
                elseif src.UserData == 1
                    src.UserData = -1;
                elseif src.UserData == -1
                    src.UserData = 0;
                end
            elseif src==app.PMSeqButton3
                if src.UserData == 0
                    src.UserData = 1;
                elseif src.UserData == 1
                    src.UserData = -1;
                elseif src.UserData == -1
                    src.UserData = 0;
                end
            elseif src==app.PMSeqButton4
                if src.UserData == 0
                    src.UserData = 1;
                elseif src.UserData == 1
                    src.UserData = -1;
                elseif src.UserData == -1
                    src.UserData = 0;
                end
            elseif src==app.PMSeqButton5
                if src.UserData == 0
                    src.UserData = 1;
                elseif src.UserData == 1
                    src.UserData = -1;
                elseif src.UserData == -1
                    src.UserData = 0;
                end
            elseif src==app.PMSeqButton6
                if src.UserData == 0
                    src.UserData = 1;
                elseif src.UserData == 1
                    src.UserData = -1;
                elseif src.UserData == -1
                    src.UserData = 0;
                end
            elseif src==app.PMSeqButton7
                if src.UserData == 0
                    src.UserData = 1;
                elseif src.UserData == 1
                    src.UserData = -1;
                elseif src.UserData == -1
                    src.UserData = 0;
                end
            end
            updatePMSeq(app,[],[]);
        % The callback comes from any of the Write Pulse Edit Fields
        elseif src==app.PMwamEditField
            sendCmdToClient(app,app.tcpTF, "STRING:para:PM:wam", 'value', app.PMwamEditField.Value);
        elseif src==app.PMwpuEditField
            [app.PMwpu,app.PMwpuEditField.Value,app.PMwpuUnit.Text]=convertSeconds(app.PMwpuEditField.Value,app.PMwpuUnit.Text);
            sendCmdToClient(app,app.tcpTF, "STRING:para:PM:wpu", 'value', app.PMwpu);
        elseif src==app.PMwriEditField
            [app.PMwri,app.PMwriEditField.Value,app.PMwriUnit.Text]=convertSeconds(app.PMwriEditField.Value,app.PMwriUnit.Text);
            sendCmdToClient(app,app.tcpTF, "STRING:para:PM:wri", 'value',app.PMwri);
        elseif src==app.PMdel2readEditField
            [app.PMdel2read,app.PMdel2readEditField.Value,app.PMdel2readUnit.Text]=convertSeconds(app.PMdel2readEditField.Value,app.PMdel2readUnit.Text);
            sendCmdToClient(app,app.tcpTF, "STRING:para:PM:read", 'value',app.PMdel2read);
        % The callback comes from any of the Read Pulse Edit Fields
        elseif src==app.PMampEditField
            sendCmdToClient(app,app.tcpTF, "STRING:para:PM:amp", 'value',app.PMampEditField.Value);
        elseif src==app.PMrpuEditField
            [app.PMrpu,app.PMrpuEditField.Value,app.PMrpuUnit.Text]=convertSeconds(app.PMrpuEditField.Value,app.PMrpuUnit.Text);
            app.PMrriEditField.Value = app.PMrpuEditField.Value;
            app.PMrriUnit.Text = app.PMrpuUnit.Text;
            sendCmdToClient(app,app.tcpTF, "STRING:para:PM:rri", 'value',app.PMrpu);
        % elseif src==app.PMrriEditField
        %     [app.PMwri,app.PMrriEditField.Value,app.PMwriUnit.Text]=convertSeconds(app.PMrri,app.PMrriEditField.Value,app.PMrriUnit.Text);
        %     sendCmdToClient(app,app.tcpTF, "STRING:para:PM:rri", 'value',app.PMrri);
        elseif src==app.PMdelaytEditField
            [app.PMdelayt,app.PMdelaytEditField.Value,app.PMdelaytUnit.Text]=convertSeconds(app.PMdelaytEditField.Value,app.PMdelaytUnit.Text);
            sendCmdToClient(app,app.tcpTF, "STRING:para:PM:delayt", 'value',app.PMdelayt);
    end
end