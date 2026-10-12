function SKamplifierChange(app,src,~)
    if strcmpi(src.Value,"FE-HeadAmp")
        app.SKCuRangeDropDown.Items = {'10 nC', '1 nC', '100 pC'};
        app.SKCuRangeDropDown.ItemsData ={15,16,17};
        if app.SKSetDir.Value == 1
            app.SKSeqButton1.Icon = fullfile(app.currPWD, 'images', 'rectPulses', 'posRed.png');
        elseif app.SKSetDir.Value == -1
            app.SKSeqButton1.Icon = fullfile(app.currPWD, 'images', 'rectPulses', 'negRed.png');
        end
    elseif strcmpi(src.Value,"HV-Amp")
        app.SKCuRangeDropDown.Items = {'1 A', '100 mA', '10 mA', '1 mA','100 µA', '10 µA', '1 µA', '100 nA', '10 nA', '1 nA', '100 pA', '10 pA'};
        app.SKCuRangeDropDown.ItemsData ={0,1,4,5,6,7,8,9,10,11,12,13};
        if app.SKSetDir.Value == 1
            app.SKSeqButton1.Icon = fullfile(app.currPWD, 'images', 'rectPulses', 'posBlue.png');
        elseif app.SKSetDir.Value == -1
            app.SKSeqButton1.Icon = fullfile(app.currPWD, 'images', 'rectPulses', 'negBlue.png');
        end
    end
end