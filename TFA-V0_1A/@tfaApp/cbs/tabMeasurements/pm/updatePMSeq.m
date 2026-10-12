function updatePMSeq(app,src,~)

    % Collect UserData values for buttons 1..7 into a numeric vector
    vals = [ ...
        app.PMSeqButton1.UserData, ...
        app.PMSeqButton2.UserData, ...
        app.PMSeqButton3.UserData, ...
        app.PMSeqButton4.UserData, ...
        app.PMSeqButton5.UserData, ...
        app.PMSeqButton6.UserData, ...
        app.PMSeqButton7.UserData ];

    imgFolder = fullfile(app.currPWD, 'images', 'rectPulses');
    
    % Map numeric userdata to filename prefix
    %  0 -> 'dis',  1 -> 'pos', -1 -> 'neg'
    mapPrefix = containers.Map([-1,0,1], {'neg','dis','pos'});
    
    % button handles in order
    btns = { ...
        app.PMSeqButton1, app.PMSeqButton2, app.PMSeqButton3, ...
        app.PMSeqButton4, app.PMSeqButton5, app.PMSeqButton6, ...
        app.PMSeqButton7 };
    
    for i = 1:7
        v = vals(i);
        % choose color: blue for write pulses (1 and 7), red otherwise
        if i == 1 || i == 7
            color = 'Blue';
        else
            color = 'Red';
        end
        prefix = mapPrefix(v);            % 'neg','dis' or 'pos'
        fname = sprintf('%s%s.png', prefix, color);   % e.g. 'posBlue.png'
        btns{i}.Icon = fullfile(imgFolder, fname);
    end
    
    
    % Helper for write pulses (indices 1 and 7)
    mapWrite = containers.Map({-1,0,1},{'0','-','1'}); % -1->'0', 0->'-', 1->'1'
    app.PMSeq(1) = mapWrite(vals(1));
    app.PMSeq(7) = mapWrite(vals(7));


    % Process read pulses (indices 2..6)
    lastBias = 0;   % 0 means no previous non-disabled read yet
    for i = 2:6
        v = vals(i);
        if v == 0
            app.PMSeq(i) = '-';
            continue
        end
        if lastBias == 0
            % First applied (non-disabled) read pulse
            app.PMSeq(i) = (v == 1) * 'X' + (v == -1) * 'Y';
            % the above arithmetic yields ASCII codes; convert to char
            app.PMSeq(i) = char(app.PMSeq(i));
        else
            % Compare with lastBias to determine switching/non-switching
            if v == lastBias
                % non-switching: positive->'U', negative->'D'
                app.PMSeq(i) = (v == 1) * 'U' + (v == -1) * 'D';
                app.PMSeq(i) = char(app.PMSeq(i));
            else
                % switching: If lastBias was negative, positive->'P'
                %             If lastBias was positive, negative->'N'
                if v == 1 && lastBias == -1
                    app.PMSeq(i) = 'P';
                elseif v == -1 && lastBias == 1
                    app.PMSeq(i) = 'N';
                else
                    % fallback (shouldn't occur), mark as '-'
                    app.PMSeq(i) = '-';
                end
            end
        end
        % Update lastBias to this applied (non-disabled) read pulse
        lastBias = v;
    end
    if isempty(src)
        if all(app.PMSeq == '0XUNDP-') || all(app.PMSeq == '1YDPUN-')
            app.PMMode.Value = "PUND";
        elseif all(app.PMSeq == '--XU---') || all(app.PMSeq == '--YD---')
            app.PMMode.Value = "SS/NS";
        elseif all(app.PMSeq == '0-XU---') || all(app.PMSeq == '1-YD---')
            app.PMMode.Value = "SS/S";
        elseif all(app.PMSeq == '1-XN---') || all(app.PMSeq == '0-YP---')
            app.PMMode.Value = "OS/NS";
        elseif all(app.PMSeq == '--XN---') || all(app.PMSeq == '--YP---')
            app.PMMode.Value = "OS/S";
        elseif all(app.PMSeq == '1------') || all(app.PMSeq == '0------')
            app.PMMode.Value = "W";
        else
            app.PMMode.Value = "Manual";
        end
    end
    sendCmdToClient(app,app.tcpTF, "STRING:para:PM:pulseseq", 'value',app.PMSeq);
    % Somehow the Pulsesequence is not visibly updated if no other
    % parameter is changed. Therefore, I introduce following block
    oldVal = app.PMwamEditField.Value;
    app.PMwamEditField.Value=oldVal+1;
    updatePMWAm(app,[],[]);
    app.PMwamEditField.Value=oldVal;
    updatePMWAm(app,[],[]);



end