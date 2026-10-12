function updateWaveForm(app,src,~)
    mode = string(app.TabGroup2.SelectedTab.Title);
    sendCmdToClient(app,app.tcpTF, "STRING:para:"+mode+":waveform", 'value',src.Value);
    if src==app.PMWaveformDropDown
        if src.Value == 2
            app.PMCuRangeDropDown.Items = {'10 nC', '1 nC', '100 pC'};
            app.PMCuRangeDropDown.ItemsData ={15,16,17};
            app.PMCuRangeDropDown.Value = 15;
            updateCuRange(app,app.PMCuRangeDropDown,[]);
        else
            app.PMCuRangeDropDown.Items = {'auto', '1 A', '100 mA', '10 mA', '1 mA','100 µA', '10 µA', '1 µA', '100 nA', '10 nA', '1 nA', '100 pA', '10 pA'};
            app.PMCuRangeDropDown.ItemsData ={-1,0,1,4,5,6,7,8,9,10,11,12,13};
            app.PMCuRangeDropDown.Value = -1;
            updateCuRange(app,app.PMCuRangeDropDown,[]);
        end
    end
    if mode=="PZM"
        app.UIFigure.CurrentObject = app.PZMCuRangeDropDown;
    end
end