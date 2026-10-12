function  SKModeChange(app,src,~)
    if src.Value == 1
        app.SKSeqButton1.Icon = fullfile(app.currPWD, 'images', 'rectPulses', 'posRed.png');
        if strcmpi(app.SKAmplifierDropDown.Value,"FE-HeadAmp")
            app.SKSeqButton1.Icon = fullfile(app.currPWD, 'images', 'rectPulses', 'posRed.png');
        elseif strcmpi(app.SKAmplifierDropDown.Value,"HV-Amp")
            app.SKSeqButton1.Icon = fullfile(app.currPWD, 'images', 'rectPulses', 'posBlue.png');
        end
        if app.SKSmAmpCheckBox.Value
            app.SKSeqButton3.Icon = fullfile(app.currPWD, 'images', 'rectPulses', 'posRed.png');
        end
            % app.SKSeqButton4.Icon = fullfile(app.currPWD, 'images', 'rectPulses', 'negRed.png');
        app.SKSeqButton6.Icon = fullfile(app.currPWD, 'images', 'rectPulses', 'negRed.png');
        app.SKSeqButton7.Icon = fullfile(app.currPWD, 'images', 'rectPulses', 'negRed.png');
    elseif src.Value == -1
        if strcmpi(app.SKAmplifierDropDown.Value,"FE-HeadAmp")
            app.SKSeqButton1.Icon = fullfile(app.currPWD, 'images', 'rectPulses', 'negRed.png');
        elseif strcmpi(app.SKAmplifierDropDown.Value,"HV-Amp")
            app.SKSeqButton1.Icon = fullfile(app.currPWD, 'images', 'rectPulses', 'negBlue.png');
        end
        if app.SKSmAmpCheckBox.Value
            app.SKSeqButton3.Icon = fullfile(app.currPWD, 'images', 'rectPulses', 'negRed.png');
        end
        % app.SKSeqButton4.Icon = fullfile(app.currPWD, 'images', 'rectPulses', 'posRed.png');
        app.SKSeqButton6.Icon = fullfile(app.currPWD, 'images', 'rectPulses', 'posRed.png');
        app.SKSeqButton7.Icon = fullfile(app.currPWD, 'images', 'rectPulses', 'posRed.png');
    end

end