function SKSmAmpCBChange(app,src,event)
if src.Value
    app.SKSmAmpampLabel.Visible =           'on';
    app.SKSmAmpampEditField.Visible =       'on';
    app.SKSmAmpampUnit.Visible =            'on';

    app.SKSmAmprpuLabel.Visible =           'on';
    app.SKSmAmprpuEditField.Visible =       'on';
    app.SKSmAmprpuUnit.Visible =            'on';

    app.SKSmAmprriLabel.Visible =           'on';
    app.SKSmAmprriEditField.Visible =       'on';
    app.SKSmAmprriUnit.Visible =            'on';

    app.SKSmAmpdelaytLabel.Visible =        'on';
    app.SKSmAmpdelaytEditField.Visible =    'on';
    app.SKSmAmpdelaytUnit.Visible =         'on';

    app.SKSeqButton3.Visible =              'on';

    app.SKSmAmpCuRangeDropDown.Enable = 'on';
    app.SKSmAmpCuRangeDropDown.Items = {'1 A', '100 mA', '10 mA', '1 mA','100 µA', '10 µA', '1 µA', '100 nA', '10 nA', '1 nA', '100 pA', '10 pA'};
    app.SKSmAmpCuRangeDropDown.ItemsData ={0,1,4,5,6,7,8,9,10,11,12,13};
    app.SKSmAmpCuRangeDropDown.Value = 8;
else
    app.SKSmAmpampLabel.Visible =           'off';
    app.SKSmAmpampEditField.Visible =       'off';
    app.SKSmAmpampUnit.Visible =            'off';

    app.SKSmAmprpuLabel.Visible =           'off';
    app.SKSmAmprpuEditField.Visible =       'off';
    app.SKSmAmprpuUnit.Visible =            'off';

    app.SKSmAmprriLabel.Visible =           'off';
    app.SKSmAmprriEditField.Visible =       'off';
    app.SKSmAmprriUnit.Visible =            'off';
    
    app.SKSmAmpdelaytLabel.Visible =        'off';
    app.SKSmAmpdelaytEditField.Visible =    'off';
    app.SKSmAmpdelaytUnit.Visible =         'off';

    app.SKSeqButton3.Visible =              'off';

    app.SKSmAmpCuRangeDropDown.Enable = 'off';
    app.SKSmAmpCuRangeDropDown.Items = {'-'};
    app.SKSmAmpCuRangeDropDown.ItemsData ={-1};

end

end